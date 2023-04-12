Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B676DEAA9
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDLEkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLEkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D51B1BF1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3908462DE1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FC66C4339B;
        Wed, 12 Apr 2023 04:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681274418;
        bh=S8V99bkO9xrvNmcW6SprWnQAdsmt6U6fexS+1i1C1rQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oQM9LOHD80ppYCr6c/Gko5eVRoGPPc3sFuT7MukPGkG6tXBLiXLFaeazeewxpdRFy
         h7vkWbVG+35C+vrGtgdzqXDEJe0gxFqH/+MPX9Ti5LFkwuPE+WteAYPYtxpUAJuRsi
         AK4NxDh6Sx1WssV2BmBQtivTSANwBcJCoIgBLREKa8q7+KWC+qx7cSUl2VcEljopID
         W5VvDmEE0dBwOltF2v1o9rIdf/cM/kHUPfWUbsIfZ5+XP0gyS0nTxf9iNt3uQqXoil
         jZOzi34eIp7KpMOY9aXILuwrJyImq50iiGvJXqOS982Ob3ykQCPvrX03O/OVTcO9ys
         cYQtfNLF9QlcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CEB8E52448;
        Wed, 12 Apr 2023 04:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2][pull request] iavf: fix racing in VLANs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168127441844.15405.2875889687278679287.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 04:40:18 +0000
References: <20230407210730.3046149-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230407210730.3046149-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, ahmed.zaki@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri,  7 Apr 2023 14:07:28 -0700 you wrote:
> Ahmed Zaki says:
> 
> This patchset mainly fixes a racing issue in the iavf where the number of
> VLANs in the vlan_filter_list might be more than the PF limit. To fix that,
> we get rid of the cvlans and svlans bitmaps and keep all the required info
> in the list.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] iavf: refactor VLAN filter states
    https://git.kernel.org/netdev/net/c/0c0da0e95105
  - [net,v2,2/2] iavf: remove active_cvlans and active_svlans bitmaps
    https://git.kernel.org/netdev/net/c/9c85b7fa12ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


