Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADB156BF81
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbiGHQdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbiGHQdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:33:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAAD63CC;
        Fri,  8 Jul 2022 09:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDED361F9F;
        Fri,  8 Jul 2022 16:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF8EC341C0;
        Fri,  8 Jul 2022 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657298015;
        bh=nKH6gYQDKhqyQUfiHI88nG96xCC/NcvafNEHPE+Gors=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AiKEgo8Oky8/LC8YX2qOsr7VO/Uv32xq3F/yuCTH3CTXXl95tG9iHCGVg8NWflfOP
         YiWS/NeVNmulrGYIWrwrY6pFft71g8UKqmkhlVpD7RxJ7/qINW9SBf60D8F3XtdWoS
         hbMw0nAquAgsMHdp9Yzsbdv5fPf+HaGa9fM6aiUUCcXdKBBEXIZS05S7ovmiid17mU
         NH+5S7s2O5UOy6ndCpdlLwPxMdENjsBgepBR11XSzs6bQZR74g9prcwvD8Ur5O7Hig
         GehzfVp/+ZZx06og0YRjz1AIXsKEKCxbUBkp+VHv/bQZmX4Xk1Y0pPAZJDQEXmrAwF
         Msm2bUJFFNvdg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     jirislaby@kernel.org, mickflemm@gmail.com, mcgrof@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/ath: fix repeated words in comments
References: <20220708154929.19199-1-yuanjilin@cdjrlc.com>
Date:   Fri, 08 Jul 2022 19:33:28 +0300
In-Reply-To: <20220708154929.19199-1-yuanjilin@cdjrlc.com> (Jilin Yuan's
        message of "Fri, 8 Jul 2022 23:49:29 +0800")
Message-ID: <875yk7tvhj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> writes:

>  Delete the redundant word 'don't'.
>  Delete the redundant word 'but'.
>
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c         | 2 +-
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

The title prefix should be "wifi: ath5k:", but I can fix that during
commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
