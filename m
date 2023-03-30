Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC06CFA4A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjC3Eka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjC3EkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:40:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B759F35B5;
        Wed, 29 Mar 2023 21:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 010CECE25FE;
        Thu, 30 Mar 2023 04:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 290C9C433AA;
        Thu, 30 Mar 2023 04:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680151219;
        bh=LLqhNol2VPadwvVDmQF6rxwq+EwKwn++oDkiYQRuqRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ij2/Ye5YKDG/8SqrKithKz7gdAuD4/xWIlc0LChFrNbCXx0ucdOnnamsv8yvTB1Cq
         17bt00rPlmw6pS+dkQ9VgPyGLfqo/MCU96z00CY7pc0RSGltWbJPF7MCnuXz4445lp
         RsFjnwwRqDzP/9SCx+I/vWrKNVLZMxtgIGBFnOpQcghyr2BZWbU4v3k9xLJhn/JH6u
         pVXZtlvAFnzl/3/PMvJxPdGJMOouD2Fx38YI1lOr4Z9aYkjl/hSmrpZ0RMu760fxb2
         5k6Ub8V5jbEfzQA6PC/9wdDz6pknenimhIfsTfnCb8g4Joox71otAEpJFPoRPH15iC
         WDJP5aAvBL0JA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 114CAE21EDD;
        Thu, 30 Mar 2023 04:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015121906.8019.5240784859731631730.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 04:40:19 +0000
References: <20230328142455.481146-1-tianfei.zhang@intel.com>
In-Reply-To: <20230328142455.481146-1-tianfei.zhang@intel.com>
To:     Zhang@ci.codeaurora.org, Tianfei <tianfei.zhang@intel.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-fpga@vger.kernel.org, ilpo.jarvinen@linux.intel.com,
        andriy.shevchenko@linux.intel.com, vinicius.gomes@intel.com,
        pierre-louis.bossart@linux.intel.com, marpagan@redhat.com,
        russell.h.weight@intel.com, matthew.gerlach@linux.intel.com,
        nico@fluxnic.net, raghavendrax.anand.khadatare@intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Mar 2023 10:24:55 -0400 you wrote:
> Adding a DFL (Device Feature List) device driver of ToD device for
> Intel FPGA cards.
> 
> The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> as PTP Hardware clock(PHC) device to the Linux PTP stack to synchronize
> the system clock to its ToD information using phc2sys utility of the
> Linux PTP stack. The DFL is a hardware List within FPGA, which defines
> a linked list of feature headers within the device MMIO space to provide
> an extensible way of adding subdevice features.
> 
> [...]

Here is the summary with links:
  - [v3] ptp: add ToD device driver for Intel FPGA cards
    https://git.kernel.org/netdev/net-next/c/615927f1a487

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


