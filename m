Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0336F1338
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbjD1IZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjD1IZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803C92691;
        Fri, 28 Apr 2023 01:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160EA641EE;
        Fri, 28 Apr 2023 08:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD25C433D2;
        Fri, 28 Apr 2023 08:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682670346;
        bh=w5yCz57oyTSCh6Oi51x22fM1rpCghklaZbV/wpoVFG0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=sN62OQZxnAILMx8t1jVWj6WRaFiAvdL9YhNR/AxsAWq1D0U4t0eG7uANHhGTFAM7W
         jSC+k2dUcWywOzrzXIjk5rXpYszPQdpVqGu9S9eHPaxV0yUBxPSw50Vk1Zdou9t49Q
         EABBWn/+lHIBD18sYu2Q56+Ml1HBCW8Iyov35V+aePN9XfoUIhcAsmknZvur1doa9L
         VsNuHLUWD4te8EEQSllLu/xOWuzQkdvdruTOqlw6Zyd+c127irTTFg5YAe4OhqPBjF
         2vBhm4rBPoRo7va1wws02IyAE72TxWPTop8/czSNokHmrBvSjzuCRhTgPVf9ra7JEW
         ScPnV1/3uruhQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     wo <luyun_611@163.com>
Cc:     "Larry Finger" <Larry.Finger@lwfinger.net>, Jes.Sorensen@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to incorrect RCR value
References: <20230427020512.1221062-1-luyun_611@163.com>
        <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
        <53e5cb36.2d9d.187c61b8405.Coremail.luyun_611@163.com>
Date:   Fri, 28 Apr 2023 11:25:40 +0300
In-Reply-To: <53e5cb36.2d9d.187c61b8405.Coremail.luyun_611@163.com> (wo's
        message of "Fri, 28 Apr 2023 12:25:04 +0800 (CST)")
Message-ID: <87ttx0s9a3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wo  <luyun_611@163.com> writes:

> In fact, there is another driver rtl8192cu.ko
> (drivers/net/wireless/realtek/rtlwifi/), that can also match this
> device.

It's not good if there are two drivers supporting same hardware. Should
the support be removed from rtlwifi?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
