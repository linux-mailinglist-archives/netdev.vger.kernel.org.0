Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799F849FC73
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349274AbiA1PKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349246AbiA1PKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF2BC061714;
        Fri, 28 Jan 2022 07:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82EF2CE2697;
        Fri, 28 Jan 2022 15:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0AF2C340E6;
        Fri, 28 Jan 2022 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382611;
        bh=hdM3haELsJHetUr2wbDhTLAZ6OmJ5XC3m2VL6ZSjV4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=feNk8nDuUCv398dXyOtrTeYBRGVR6UWaFOnGUzwJlksFoukH8j5XwuSUi+b4JVWZK
         oyXalDXQ/+eB0HXUNB9nnUG+2cQj/xwv1ANr/rdRMvQUrfz6GxiWu8x8n4EGHWap2D
         cc/Pufek3/X2iTb4eRTAtG44GN+YiCHrfccrbr0q7TNNGDhRsj1Z/qlx7utVeI4ryF
         MDsKej57sfqB9upXiHZwRu/G3LJcsNQks4BadsbMT+l//Zi6u90S1ufvGBaZn9mRe1
         xj8tnGaNgRzHU6hKcoiYRyqLNDadUQYuhvt4222rEwuqU9ZJE0Djyu+3o9YAhliPx6
         9odP244x7HPdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84F64E5D098;
        Fri, 28 Jan 2022 15:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] gve: fix the wrong AdminQ buffer queue index check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261153.2420.3816050464539840623.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:11 +0000
References: <20220128104716.9020-1-haiyue.wang@intel.com>
In-Reply-To: <20220128104716.9020-1-haiyue.wang@intel.com>
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     netdev@vger.kernel.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, davem@davemloft.net, kuba@kernel.org,
        bcf@google.com, willemb@google.com, shailend@google.com,
        yangchun@google.com, sagis@google.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 18:47:14 +0800 you wrote:
> The 'tail' and 'head' are 'unsigned int' type free-running count, when
> 'head' is overflow, the 'int i (= tail) < u32 head' will be false:
> 
> Only '- loop 0: idx = 63' result is shown, so it needs to use 'int' type
> to compare, it can handle the overflow correctly.
> 
> typedef uint32_t u32;
> 
> [...]

Here is the summary with links:
  - [v2] gve: fix the wrong AdminQ buffer queue index check
    https://git.kernel.org/netdev/net/c/1f84a9450d75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


