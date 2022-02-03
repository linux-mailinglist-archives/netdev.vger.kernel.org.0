Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A25E4A8083
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 09:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349538AbiBCIjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 03:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiBCIjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 03:39:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14DEC061714;
        Thu,  3 Feb 2022 00:39:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33FBA61880;
        Thu,  3 Feb 2022 08:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72027C340E4;
        Thu,  3 Feb 2022 08:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643877558;
        bh=dmXgElrMno1Xr2jj1GEThEmeTJWLr2oYSbpQdJvmLr0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JpWTzQNdYa+zt7AH2clRJzr4UMp9QWSxeBKREX6IphMd5jkvjXxWEV70ecWtIXIvT
         VLkljM5SnAIsQfhz5Pit3M374azaKue4qGeqCrL+hrJQJm4WIN7UrMDLI+DZjxfGD3
         3U6o0bYNGRrMg5DaR37YtT4wxloGnbUsIqlBSYtYB18gdlHgiYHMyau+7XOdKHoaNr
         pv3lKnStEJEEYC1PcVgHPaL8kEkYiFUL8JA5HA2MQVyHGFu/H6lRxQcaRA/CCY2igo
         mkU2JOpEaHhtUt9Ua4WovGVFnULL5gtEIp6cZOfN2ak9u32z6HNBsk0+Z1EZu+IUCr
         hhiys5MgLfdDw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com,
        =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH] ath9k_htc: fix uninit value bugs
References: <20220115122733.11160-1-paskripkin@gmail.com>
        <164337315159.4876.15861801637015517784.kvalo@kernel.org>
        <0647fd91-f0a7-4cf7-4f80-cd5dc3f2f6a2@gmail.com>
Date:   Thu, 03 Feb 2022 10:39:12 +0200
In-Reply-To: <0647fd91-f0a7-4cf7-4f80-cd5dc3f2f6a2@gmail.com> (Pavel
        Skripkin's message of "Fri, 28 Jan 2022 23:52:42 +0300")
Message-ID: <87bkzocpjj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Hi Kalle,
>
> On 1/28/22 15:32, Kalle Valo wrote:
>>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>>> Reported-by: syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
>>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>>> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
>>
>> Patch applied to ath-next branch of ath.git, thanks.
>>
>> d1e0df1c57bd ath9k_htc: fix uninit value bugs
>>
>
> Thanks, Kalle! Can you also, please, check out this one too :)
> Quite old, but syzbot is getting mad with this bug (like 20k hits). Thanks!
>
>
> https://lore.kernel.org/all/20210922164204.32680-1-paskripkin@gmail.com/

I already provided feedback on August 6th:

"Separate patch for cleanups, please."

https://patchwork.kernel.org/project/linux-wireless/patch/20210804194841.14544-1-paskripkin@gmail.com/

Please submit v2. And Toke is the new ath9k maintainer, so please CC him
as well.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
