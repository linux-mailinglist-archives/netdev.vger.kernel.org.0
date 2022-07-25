Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5625E57FE09
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 13:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiGYLG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 07:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiGYLG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 07:06:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0631213F7E;
        Mon, 25 Jul 2022 04:06:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6C0B80E4E;
        Mon, 25 Jul 2022 11:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E326C341CD;
        Mon, 25 Jul 2022 11:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658747213;
        bh=+hq3t9bHgvpbeCF8NFkCTLqDaz7CXhdNqHwezF7INHI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kAkrXTiopEEtZN8vUdJg9PiMEVYjRjZYLjOvDpdoV+Q1rNQbqAVj1CI1Z+uyqjsOc
         8KItxpxPQV4PDWmcrXzLRJpdqqomag9ahvpoEgzQH4YGhZLLlD0r8227qzS/9KuB7V
         O4WdrTowkLShWog6bm8URAMtFWRVAUGnZqBP6y27u4aUT+nMOxvi+s6cklZWHIZ575
         VlMmTBSjQqPzwj5gvHtQB1JRTJ0oNY3j14FMsqGTnztXteqeHTHqbxfZFeUaaKFkVQ
         B+kNLX3hEeDXELxHSj363Ci1UFWCrOe2b1a85P0H80d4F8WFIySHlakZyCEa5rZEoe
         PhWbCDt+SV9ZQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: ath: Fix typo 'the the' in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722082653.74553-1-slark_xiao@163.com>
References: <20220722082653.74553-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, loic.poulain@linaro.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org,
        Slark Xiao <slark_xiao@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165874719705.30937.12813347117072714125.kvalo@kernel.org>
Date:   Mon, 25 Jul 2022 11:06:50 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slark Xiao <slark_xiao@163.com> wrote:

> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Fails to apply, please rebase on top my ath.git master branch.

error: patch failed: drivers/net/wireless/ath/ath6kl/hif.h:92
error: drivers/net/wireless/ath/ath6kl/hif.h: patch does not apply
error: patch failed: drivers/net/wireless/ath/ath6kl/sdio.c:1185
error: drivers/net/wireless/ath/ath6kl/sdio.c: patch does not apply
error: patch failed: drivers/net/wireless/ath/wcn36xx/hal.h:4142
error: drivers/net/wireless/ath/wcn36xx/hal.h: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722082653.74553-1-slark_xiao@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

