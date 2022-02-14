Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0167E4B4F48
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352086AbiBNLs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:48:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBNLjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:39:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F5813DD3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 03:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D80AD611B2
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 11:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DF2CC340F0;
        Mon, 14 Feb 2022 11:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644838209;
        bh=bwyukgypZ/SZb3VxAhEVU7NdHYAoo6pa/1RJ1yrRJEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZpJBiidDu+035iEjG0+el2Y8c5ajDqFNkGvEkevmPxZdlZJzb6LKmh/P0HtKPniqi
         O1IkXX0nLbAVc5WMb/nJBHQPKpeJt8SnwuLN+ZzsVt0rWi5Z6z++9mPN0t3pxO8Ivf
         VbuZmHqRSePl9Hg7TI7WdvbyLKofSsm7lqNMTt12EWuvvQD/q7J8jWO3VTGBKmvl9V
         v5vhm00UaSDk7vIhFMlDDHqKx+66/2CMCowPnUT2hn/C4NwzlHxDWmird7NbZLaJr+
         2ps+6DBhHDRdMN5A8CS0D9BruVxhuVDcDVUN89fQkzvQBfsH0rz8XWgLV0kT6B0SHk
         GrkMFeOactwiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35AA9E6D4D5;
        Mon, 14 Feb 2022 11:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ice: enable parsing IPSEC SPI headers for RSS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164483820921.17157.14524611713549096897.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 11:30:09 +0000
References: <20220211171418.310044-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220211171418.310044-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Feb 2022 09:14:18 -0800 you wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> The COMMS package can enable the hardware parser to recognize IPSEC
> frames with ESP header and SPI identifier.  If this package is available
> and configured for loading in /lib/firmware, then the driver will
> succeed in enabling this protocol type for RSS.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ice: enable parsing IPSEC SPI headers for RSS
    https://git.kernel.org/netdev/net/c/86006f996346

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


