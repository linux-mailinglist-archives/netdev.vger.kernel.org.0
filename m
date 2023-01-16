Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24DF66C808
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjAPQgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbjAPQfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:35:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9590F30EA7;
        Mon, 16 Jan 2023 08:24:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4902FB81065;
        Mon, 16 Jan 2023 16:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705F2C433F1;
        Mon, 16 Jan 2023 16:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673886244;
        bh=Xa4zXDzPxuSD1mCwh5IIhSowSMlMbPBGb/rtmYiebas=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WXwjYVnbosQ1VJJhJrleDAHRCqHh1veZTk6xuE7/uy6CythCGIrKTsIVdVasrrgvu
         niilM4/tp7llmASXnxH+EV5eeIK/1r+V995ZVTtD8s2MBPAdsKjxN0m3VQxirM61zU
         6ekDcfUu2yivuQWacrymNjyounhrLfBpvgs/UyFomcB2OwwHa2OTrZ80LBTK7SNhBe
         xTbXnddsHb9+OAHRpkrS0vu2L+NoLeeIdLMHfJKqFIXD7pTxkX0rzY7LcM/kjKyMT5
         4LQGhBxOWoJWg9EJWmKqBBc0fifM9fs55aBIRnUKdQb+uFoIlpc0ek0VwFz8h3pAND
         wSuqDeKesS5hg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: rt2x00: Remove useless else if
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230106022731.111243-1-jiapeng.chong@linux.alibaba.com>
References: <20230106022731.111243-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     stf_xl@wp.pl, helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167388623942.5321.8431065442138350705.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 16:24:01 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> The assignment of the else and else if branches is the same, so the else
> if here is redundant, so we remove it.
> 
> ./drivers/net/wireless/ralink/rt2x00/rt2800lib.c:8927:9-11: WARNING:
> possible condition with no effect (if == else).
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3631
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

ebe8dee7aea6 wifi: rt2x00: Remove useless else if

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230106022731.111243-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

