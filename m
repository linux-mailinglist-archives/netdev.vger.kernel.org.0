Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4FB4B9CB4
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbiBQKG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:06:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiBQKG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:06:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD5EB5618;
        Thu, 17 Feb 2022 02:06:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DF41B820B5;
        Thu, 17 Feb 2022 10:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46132C340E8;
        Thu, 17 Feb 2022 10:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645092400;
        bh=CpMkhyEggAbXw8Y2Xa5B91alz+d+1tT2IuOlwYGR6GU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=uQhw7NwcZ3Veoow5rB3RqsW3ZeEAk46cWAs0OGjM9QIlcn8SOXA3jbl8D/NQaO0W6
         9zgqWUDTXJxBDrTiHY3QxMy1bdcdOoXWVxInUIUkj89Yi1xT++TQm7Eb8KmJIKJaxz
         igf4R+zggUkeI2nhWe1Lx6e21cpQcg4LVNN3hztRueLXDRp63F9xLLENEFh9voHhQ3
         G9zLbpsSoQzORjfn3CNGiWcG6V4farUNmiqy20hY55NM6T1MIfYKP1EEgMQ+l1BRW8
         vRH0b5XruvC8KeMde3AIHFVYlzED2rcLrbwuKhjmNnxqLmAgRoaSpnXWeXpjSUbdEv
         JM3hMnB+UedDQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] tw89: core.h: Replace zero-length array with flexible-array member
References: <20220216195047.GA904198@embeddedor>
        <20220216184213.13328667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 17 Feb 2022 12:06:36 +0200
In-Reply-To: <20220216184213.13328667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 16 Feb 2022 18:42:13 -0800")
Message-ID: <874k4x24er.fsf@kernel.org>
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

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 16 Feb 2022 13:50:47 -0600 Gustavo A. R. Silva wrote:
>> There is a regular need in the kernel to provide a way to declare
>> having a dynamically sized set of trailing elements in a structure.
>> Kernel code should always use =E2=80=9Cflexible array members=E2=80=9D[1=
] for these
>> cases. The older style of one-element or zero-length arrays should
>> no longer be used[2].
>>=20
>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>> [2]
>> https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-lengt=
h-and-one-element-arrays
>>=20
>> Link: https://github.com/KSPP/linux/issues/78
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>
> The subject is off.

I can fix that during commit.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
