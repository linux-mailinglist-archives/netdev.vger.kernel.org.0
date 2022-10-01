Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8832E5F189B
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 04:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiJACU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 22:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiJACU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 22:20:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163A8F4782
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 19:20:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3855625AE
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 02:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13677C433C1;
        Sat,  1 Oct 2022 02:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664590826;
        bh=puJAppcmhWtMo92Pyp7lZVtHp7t4HZ/ptezB+ENGWMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N8Rg365NcLvecSbRrh0hTBZPQWHaDe+CGKDzSeZaOuGNosnER0/cjHnf6ZtfUkTiU
         716d82Ke3oOtjYBKP+RiN21650XoDnbceuG5G33YjvMtFl2j1AgtL7XqZsN34y0aXt
         CXdk7HphbjiRmn1Fi04VF+bJN7hCD/xiAouoKZjtb82BkIcRCulSUg+jGoZbU+BRnl
         dDjSKZXFlCR23mRo/CmC5589dXHwsnqSwPxZ3nABcexOpN7XZzu3lD0zqp1qlXEpCZ
         IC0yuTyNtSdWlA5K708ZmGaZIAj3pvlPe/2WJzMB78EMLrPEP/i5MCGB3INe1WAqt4
         89X0+7AygN4Pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1FD5E50D64;
        Sat,  1 Oct 2022 02:20:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] nfp: support FEC mode reporting and auto-neg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166459082598.26825.11227191844514804675.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 02:20:25 +0000
References: <20220929085832.622510-1-simon.horman@corigine.com>
In-Reply-To: <20220929085832.622510-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yinjun.zhang@corigine.com, fei.qin@corigine.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 29 Sep 2022 10:58:27 +0200 you wrote:
> Hi,
> 
> this series adds support for the following features to the nfp driver:
> 
> * Patch 1/5: Support active FEC mode
> * Patch 2/5: Don't halt driver on non-fatal error when interacting with fw
> * Patch 3/5: Treat port independence as a firmware rather than port property
> * Patch 4/5: Support link auto negotiation
> * Patch 5/5: Support restart of link auto negotiation
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] nfp: add support for reporting active FEC mode
    https://git.kernel.org/netdev/net-next/c/fc26e70f8aca
  - [net-next,v2,2/5] nfp: avoid halt of driver init process when non-fatal error happens
    https://git.kernel.org/netdev/net-next/c/965dd27d9893
  - [net-next,v2,3/5] nfp: refine the ABI of getting `sp_indiff` info
    https://git.kernel.org/netdev/net-next/c/b1e4f11e426d
  - [net-next,v2,4/5] nfp: add support for link auto negotiation
    https://git.kernel.org/netdev/net-next/c/8d545385bf26
  - [net-next,v2,5/5] nfp: add support restart of link auto-negotiation
    https://git.kernel.org/netdev/net-next/c/2820a400dfd3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


