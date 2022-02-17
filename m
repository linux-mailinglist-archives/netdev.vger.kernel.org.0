Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC514B9CA2
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiBQJ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:59:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbiBQJ7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:59:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD619F6C8;
        Thu, 17 Feb 2022 01:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80690CE2B06;
        Thu, 17 Feb 2022 09:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813D4C340E8;
        Thu, 17 Feb 2022 09:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645091971;
        bh=kf4nnFyves4ytQtR0uAhDYL4Y82jWry/eJ/Oy/50d9g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aoR51P4HeOo98AzfA1TapyB9YI7tT3P9ywfw+wXKzjpii0A8E2uzQ2MVDBynYaq4T
         TUaIW3z7dtG/pn3asWhT2WgjRrzUN/imlwFmrGPoyLGX0PCueTQJ2Cu4W2bsS8JefE
         bFPfsTeez2m/81fUye372Xx2vtFL1ZDGKt2p9h1UoJ1eO65zyvtq0UlnUQ82Fcm7xy
         4c3F4yf8o20kLpgaPy/FlYlRY98+eUR9WrGOjLl4WlVYUibSm1GH0lkzJvnCemM2HR
         DJRJYbXLUWKRW7fSl9OpPRk/7QqYZxU9zMFcs/gTEQ2G0Ea8M//whaCAyzJZn+Nvsa
         vE0+yNEG4LIfg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/2] staging: wfx: apply the necessary SDIO quirks for the Silabs WF200
References: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
        <20220216093112.92469-3-Jerome.Pouiller@silabs.com>
Date:   Thu, 17 Feb 2022 11:59:24 +0200
In-Reply-To: <20220216093112.92469-3-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Wed, 16 Feb 2022 10:31:12 +0100")
Message-ID: <878ru924qr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Until now, the SDIO quirks are applied directly from the driver.
> However, it is better to apply the quirks before driver probing. So,
> this patch relocate the quirks in the MMC framework.

It would be good to know how this is better, what's the concrete
advantage?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
