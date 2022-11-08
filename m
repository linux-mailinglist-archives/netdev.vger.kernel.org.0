Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0969B620A73
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiKHHlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbiKHHkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A783BDF1C;
        Mon,  7 Nov 2022 23:40:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E103B818B2;
        Tue,  8 Nov 2022 07:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3720C433D6;
        Tue,  8 Nov 2022 07:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667893228;
        bh=Hz521y2nG4i/prC8mk5q9LErTf2Or5Iuh/J+I3KecKI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=llGnFzzLNf2z2NtfspBGFXEax81GNb8LWcA5cnpX6UiJafiELVyk90/ZFIhIIbJs2
         E37aVMlT5qrzDM7F+Ik1gQVsbHUVwFrdz3sj4OsmWNXsoyPmcGtFcUwX+PUnRAAR+k
         0egdjOzyeHUXYq0O51QaW7tUDF2q3HFTOQ9Aao0OReoZocIziEy9wGSOiGTIAnT5P5
         7XIKVcgPuqbBwWIBbjq2HNVvL+OlTrXbL4FqI9l/9TwTHYiIo9wMF5QAboxTAztJgn
         o3DoyYpkACzTjRo7Ot/170SBHwPat9qKiP6hSR5q7DZq2CoofHV5q8pn+lc+TxBES2
         5iKAv8KeIuSxw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: iwlegacy: remove redundant variable len
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221104135036.225628-1-colin.i.king@gmail.com>
References: <20221104135036.225628-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166789322416.4985.2717898272723414818.kvalo@kernel.org>
Date:   Tue,  8 Nov 2022 07:40:25 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Variable len is being assigned and modified but it is never
> used. The variable is redundant and can be removed.
> 
> Cleans up clang scan build warning:
> warning: variable 'len' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

9db485ce098f wifi: iwlegacy: remove redundant variable len

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221104135036.225628-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

