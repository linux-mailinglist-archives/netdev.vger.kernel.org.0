Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238B96C00A7
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 12:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCSLA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 07:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCSLAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 07:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5232313E;
        Sun, 19 Mar 2023 04:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46EE2B80B46;
        Sun, 19 Mar 2023 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01CE3C433AC;
        Sun, 19 Mar 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223618;
        bh=PSYCF46BxXkgL9BPR72nf4ZQoBkxYuLpMACsn8pCjfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ToCBoW8nhaOVTIijsucWhHgkzS3eI8dhphmD1imM4NcG7OoCNahFH93UqEx/42GgG
         PBK1jrN0N8al07tnDAxJHcKNh532j0UquruKbW44C+oHirKUJt6FvN4al4dAkFvSeX
         DR0nI7aovPwQ8X3dxRKBM/10ZbQwe0btJi0O8Fuyu16Q+devn6/QjgxUTbdrON43s2
         urIfefUHw1syC/0NwurT3TPGGbyClqvj+B0gZVMGUdDt9QtnjpMTDSfJGKItfQMxa6
         cjBbaTiydNdCroti+VNKUocmJHGuZZ9a1X4P8gzKaZcdiC59HPvfjRIbDurAndtZCl
         dYi+TlwoEANzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D10BBE21EE6;
        Sun, 19 Mar 2023 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ixgb: Remove ixgb driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922361785.26931.9573620186873027791.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 11:00:17 +0000
References: <20230317200904.3796436-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230317200904.3796436-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 13:09:03 -0700 you wrote:
> There are likely no users of this driver as the hardware has been
> discontinued since 2010. Remove the driver and all references to it
> in documentation.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ixgb: Remove ixgb driver
    https://git.kernel.org/netdev/net-next/c/e485f3a6eae0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


