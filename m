Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7114050C8A1
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 11:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiDWJe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 05:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiDWJez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 05:34:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81B2236691;
        Sat, 23 Apr 2022 02:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84B7E60A52;
        Sat, 23 Apr 2022 09:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1129C385A5;
        Sat, 23 Apr 2022 09:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650706317;
        bh=40VDppNA61uLaHD8mnWnsPl1uZzmiYW2duAfGKkCnng=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jaI1BBTEeHvlWiFK/IBQm1FA5e03SkYP0ILt1tdiK3taFSg3o2KPKpCO0z0x7h+0d
         ZiaLqUVnKfr0Y39njPGzzSjE6GHNIi5vc4qsof1Pcs180HAn41B6JvmguojVZ8RmtA
         jl/vTTH3fQ2tPkQItmfrJ9YdNspIf4yTJiO3zF8HYbbuWDXipNk0UrtrMQdFqRstKC
         jBcfiFDxyFPadM4g6VUmdIVDOVO8W/yBiD/1F/x7wcT7MKQH527xpPp8CouMBmbVYD
         KV3IXC6XA+Y1uf0zK07C1QaasgN5tiD4+nsz+sWfcu/F40UcUgTHTkuC1b8OIA5RX/
         gyRZAABCJT/DA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: using pm_runtime_resume_and_get instead of
 pm_runtime_get_sync
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220411013602.2517086-1-chi.minghao@zte.com.cn>
References: <20220411013602.2517086-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     merez@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165070631276.13738.14649945913618590814.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 09:31:54 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> Using pm_runtime_resume_and_get() is more appropriate
> for simplifing code.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

45286070e9e7 wil6210: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220411013602.2517086-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

