Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D008A643AE2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbiLFBkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiLFBkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1E910DE
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 549CB614FE
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B19A8C433C1;
        Tue,  6 Dec 2022 01:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670290815;
        bh=WiCL0WXHkx9f0rSH0Q/5JD/MXSQTMu0Xp8j7brk0fNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tGX5ntIcDKMa/lUzaQc/3573ILuP5GMTp5th7e0VJMtBlTE7G4IBmmgQWxUwjJ+aL
         Kg91gxuzxB2C/NMafubJkms57pzgFLNrrWAL1ctq3qvXhE6Fq9SCz7BWt1MIoAIC5E
         lnBkilb7/8deB/V93nKsskjgzYXlrE087ZYkEuYmdJxW/rcnWfkN7tOYJ0RpgVO4TM
         hlga7ptyOm3GXO5P/J4UyJRc9wthsRqSto7nsOQmgfBIExXu7KrBgIEXfrolmOmhRI
         22OaQnhfbZimSXvzKMBmwmTl/bwR39a2tpGIbeqgEA7SschqZjiygz/H6PD1/O+w4Z
         bEXcwt0ZAG/qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 978DDC5C7C6;
        Tue,  6 Dec 2022 01:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167029081561.23476.6495412884380397288.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 01:40:15 +0000
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
In-Reply-To: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  1 Dec 2022 16:25:55 -0800 you wrote:
> Add netlink based support for "ethtool -x <dev> [context x]"
> command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> This is equivalent to functionality provided via ETHTOOL_GRSSH
> in ioctl path. It sends RSS table, hash key and hash function
> of an interface to user space.
> 
> This patch implements existing functionality available
> in ioctl path and enables addition of new RSS context
> based parameters in future.
> 
> [...]

Here is the summary with links:
  - [net-next,v7] ethtool: add netlink based get rss support
    https://git.kernel.org/netdev/net-next/c/7112a04664bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


