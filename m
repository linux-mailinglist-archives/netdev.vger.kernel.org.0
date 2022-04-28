Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0709512D9C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343712AbiD1IDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343711AbiD1IDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:03:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2C917E06
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 404C2B82B44
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 08:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEC4FC385A9;
        Thu, 28 Apr 2022 08:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651132814;
        bh=IGdMXm9WUsu0G+gjUEFP0ILF6TdDqRvpv7lQ6gbq+Yo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n1BQPIG5q4rI7TzA1f3EgiNKfflROX6DSrM/KSQ3yptOz9Fqk6sIAF/3Knkzb1nJn
         wkH5ZpZCYyRX/4o/nF9DlmLmi1ewQNCEPwPSNKyLg2hL+cTR0JI26EYb5ASDN6GTxQ
         lxlVZ2HpYokBx/ZSRXNGzRJSQnR8FvEm4r/grPcbBzoaz/j9+Q+s24fgTrnS9FQ7rH
         jxx29JVfpNPX7YxI3VsquXSJMciP7/Jh1iigiVnpeG+RGr8ILYrMl5IMVZn+VZlnUw
         n5q6TcJMyHGKNx3tNn2wQduzxY8IVrPfih+fxf+SkP4efk39aIZQtEYrWvU5kSNKvO
         Bu5dAJc1wk0mA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5CFEE85D90;
        Thu, 28 Apr 2022 08:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/13]: Move Siena into a separate subdirectory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165113281387.18320.11653436232989195004.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 08:00:13 +0000
References: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
In-Reply-To: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 28 Apr 2022 03:30:30 +0100 you wrote:
> The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
> Most of these adapters have been remove from our test labs, and testing
> has been reduced to a minimum.
> 
> This patch series creates a separate kernel module for the Siena architecture,
> analogous to what was done for Falcon some years ago.
> This reduces our maintenance for the sfc.ko module, and allows us to
> enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/13] sfc: Disable Siena support
    (no matching commit)
  - [net-next,v2,02/13] sfc: Move Siena specific files
    https://git.kernel.org/netdev/net-next/c/be5fd933f8c1
  - [net-next,v2,03/13] sfc: Copy shared files needed for Siena (part 1)
    https://git.kernel.org/netdev/net-next/c/be5fd933f8c1
  - [net-next,v2,04/13] sfc: Copy shared files needed for Siena (part 2)
    https://git.kernel.org/netdev/net-next/c/be5fd933f8c1
  - [net-next,v2,05/13] sfc: Copy a subset of mcdi_pcol.h to siena
    (no matching commit)
  - [net-next,v2,06/13] sfc/siena: Remove build references to missing functionality
    (no matching commit)
  - [net-next,v2,07/13] sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v2,08/13] sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v2,09/13] sfc/siena: Rename peripheral functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v2,10/13] sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v2,11/13] sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v2,12/13] sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v2,13/13] sfc: Add a basic Siena module
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


