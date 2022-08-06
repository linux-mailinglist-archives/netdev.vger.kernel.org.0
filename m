Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F75A58B352
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241601AbiHFCAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241414AbiHFCAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872CD112A;
        Fri,  5 Aug 2022 19:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34A96154A;
        Sat,  6 Aug 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 031ADC43143;
        Sat,  6 Aug 2022 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751216;
        bh=ZIxiHkFiEIUrY1ILj4Xwfj7+I0APQsa+pmZOV1AKuRU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tCQRPOizblryM+diXpiTdUpOH6j6QyQidmXpBNsVdfEHETKGkhEAGlF2sufZA/nic
         kAEar22dwZILK6yyMoEwqo9ZZisNxHxjfQ7hTjH+mwZ9OstznRGEYl9BlSsJ8+LD30
         ThpYHzN8QMI8qz1sIoHW/J01i5YejvlgD+QPVLM3T3jeUcwUhkCDGmk1wy7F0RAn/L
         AX3ogwGjGsUbLUdOfpMYg+DzqFs264gbh/I6yxQM1hv13q3W3S3axYWhNcHqs5F0fk
         rWCFJlW6YsSsDeLxJPvHU3l61LyxPw7O+9BRxTMoJik6cpQEHLjy8IGKr1fqVZ2zcb
         A30sJlnUhozjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D57D9C43145;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bnxt_en: Remove duplicated include bnxt_devlink.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975121586.22545.9937072590593832868.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:00:15 +0000
References: <20220804003722.54088-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220804003722.54088-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Aug 2022 08:37:22 +0800 you wrote:
> bnxt_ethtool.h is included twice in bnxt_devlink.c,
> remove one of them.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1817
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net-next] bnxt_en: Remove duplicated include bnxt_devlink.c
    https://git.kernel.org/netdev/net/c/07977a8a9e54

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


