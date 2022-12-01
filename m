Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241CF63E975
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLAFu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLAFuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DF423395
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 21:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 210C9B81DA5
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9A57C433D7;
        Thu,  1 Dec 2022 05:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669873817;
        bh=+GgXTX9/3kZO113RRXZcVhrpShcOkgER9vu+RQS6L3Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a2t7CYipuzvHXbX6yaP/7tWLxVQXrk563dc5CsY/ouk2PZryhWBc0b11eLoFoaVFR
         WTfuTI52snCqD7X+sEqMbSKU9p24GWBaFy1tScPeQrAjq92t1VYFZ7vhVHCy6WL2Ob
         UuIhcTDdcRW+xUf4qt80lss2PTA4/B6wUYyYxDslwnEeoPbm+rH8j5WwbSRtNAAhSh
         LKEblsVzZJsTqP95Zjh6ciUtbJAdWMKkjsm89DpMCz1xQrGjaFJz4HacmMBE07Tr7M
         XasgAAD2f4C21ppv7Qen+esWUdNAMfvoiTt2Povpa6AZhdb0WaaFrjL0DFrlpx44nd
         s6YPSvwHBTnaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD93DE29F38;
        Thu,  1 Dec 2022 05:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/9] support direct read from region
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987381770.9213.13433605043891965239.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 05:50:17 +0000
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
In-Reply-To: <20221128203647.1198669-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 28 Nov 2022 12:36:38 -0800 you wrote:
> Changes since v2:
> * Picked up ack/review tags
> * Added DEVLINK_ATTR_REGION_DIRECT so userspace must be explicit
> * Fixed the capitalization of netlink error messages
> 
> Changes since v1:
> * Re-ordered patches at the beginning slightly, pulling min_t change and
>   reporting of extended error messages to the start of the series.
> * use NL_SET_ERR_MSG_ATTR for reporting invalid attributes
> * Use kmalloc instead of kzalloc
> * Cleanup spacing around data_size
> * Fix the __always_unused positioning
> * Update documentation for direct reads to clearly explain they are not
>   atomic for larger reads.
> * Add a patch to fix missing documentation for ice.rst
> * Mention the direct read support in ice.rst documentation
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/9] devlink: use min_t to calculate data_size
    https://git.kernel.org/netdev/net-next/c/28e0c250f17a
  - [net-next,v3,2/9] devlink: report extended error message in region_read_dumpit()
    https://git.kernel.org/netdev/net-next/c/611fd12ce0fb
  - [net-next,v3,3/9] devlink: find snapshot in devlink_nl_cmd_region_read_dumpit
    https://git.kernel.org/netdev/net-next/c/e004ea10599d
  - [net-next,v3,4/9] devlink: remove unnecessary parameter from chunk_fill function
    https://git.kernel.org/netdev/net-next/c/284e9d1ebbe2
  - [net-next,v3,5/9] devlink: refactor region_read_snapshot_fill to use a callback function
    https://git.kernel.org/netdev/net-next/c/2d4caf0988bd
  - [net-next,v3,6/9] devlink: support directly reading from region memory
    https://git.kernel.org/netdev/net-next/c/af6397c9ee2b
  - [net-next,v3,7/9] ice: use same function to snapshot both NVM and Shadow RAM
    https://git.kernel.org/netdev/net-next/c/ed23debec5d1
  - [net-next,v3,8/9] ice: document 'shadow-ram' devlink region
    https://git.kernel.org/netdev/net-next/c/2d0197843f9e
  - [net-next,v3,9/9] ice: implement direct read for NVM and Shadow RAM regions
    https://git.kernel.org/netdev/net-next/c/3af4b40b0f2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


