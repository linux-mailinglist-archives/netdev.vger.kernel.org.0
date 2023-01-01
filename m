Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C76065A9EA
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 13:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjAAMAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 07:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjAAMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 07:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE81426DF;
        Sun,  1 Jan 2023 04:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D7B5B80B2F;
        Sun,  1 Jan 2023 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A46EC43392;
        Sun,  1 Jan 2023 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672574416;
        bh=NENl2Hr2/vULkPvCpzQqHlV9ZyyHzO8AMLvdL5EgzNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ogCNjQ/nUYywvxwbvDVUHbn3FXeUy51SURMLcqjVFOTChLK9wo/2on5PCFjNxfZ08
         qHNt4aCknOiTr37aOimIAfm1DAwXByEACDVciAI+Q8J42za1Hfggy5WldLc/ZB8e3D
         HnKzA+mPcsJbh3n49CgY+LdLFvlrvLHbbnVna5dDAPejGdL1eogHwpBrSqZ4Zhpdja
         tnWtNYtlVD9RsiCl87iiigc3Ptl+26wF0NvIL4ZkS1xdd1xOCJd/QN3Ss3FzWSBkLV
         DjxOMFLLhqPI7RG6FE69tGCkAZS2uPyjZ1RlVHctfL66Qb3M9wvDWh/yeZJM0uWhMH
         WhHbsJtsvhFhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9679C197B4;
        Sun,  1 Jan 2023 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2 0/5] net: dsa: qca8k: multiple fix on mdio read/write
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167257441588.10801.16019011909307502253.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Jan 2023 12:00:15 +0000
References: <20221229163336.2487-1-ansuelsmth@gmail.com>
In-Reply-To: <20221229163336.2487-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 29 Dec 2022 17:33:31 +0100 you wrote:
> Due to some problems in reading the Documentation and elaborating it
> some wrong assumption were done. The error was reported and notice only
> now due to how things are setup in the code flow.
> 
> First 2 patch fix mgmt eth where the lenght calculation is very
> confusing and in step of word size. (the related commit description have
> an extensive description about how this mess works)
> 
> [...]

Here is the summary with links:
  - [net,v2,1/5] net: dsa: qca8k: fix wrong length value for mgmt eth packet
    https://git.kernel.org/netdev/net/c/9807ae697461
  - [net,v2,2/5] net: dsa: tag_qca: fix wrong MGMT_DATA2 size
    https://git.kernel.org/netdev/net/c/d9dba91be71f
  - [net,v2,3/5] Revert "net: dsa: qca8k: cache lo and hi for mdio write"
    https://git.kernel.org/netdev/net/c/03cb9e6d0b32
  - [net,v2,4/5] net: dsa: qca8k: introduce single mii read/write lo/hi
    https://git.kernel.org/netdev/net/c/cfbd6de588ef
  - [net,v2,5/5] net: dsa: qca8k: improve mdio master read/write by using single lo/hi
    https://git.kernel.org/netdev/net/c/a4165830ca23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


