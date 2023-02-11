Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CE1692E2B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 05:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBKEA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 23:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKEAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 23:00:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F9680751
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 20:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82FC361F1B
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 04:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE52EC433EF;
        Sat, 11 Feb 2023 04:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676088023;
        bh=lWhZDi1UO95WoUqNdAlsytdicmZ1gsBqy3JW3V2LF/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jNVuO4iAHOWlnK8zcn1jASkY9t56RWCOU3EWD6YZvP3uaOdNH8WSo3Eeqls6cmgAF
         a3RCNNJ83NxwSYAhTqkl9HGALh1VJpjXrx1VBf1Vlj5ZRHShw8ZGP73eCZXhpCnBXi
         kZq1rYxee/Upt8z9L9ORXetIPnPbEJPsHcxk+cOoPk1a1Znr8dvIWQfuuAGXc823Lb
         WHI8FiNBlBK3piizmdlSJ42OFwD45rz1GkbcwN3MY67M4iL7qQJ8qqavVMhQuxhuGH
         Gp5dCYJO1kL0EqOdY6G0NznCnfsi1/Xv20z4mu4cfk7UFNdfLaSqwpKneSnQEd8LSd
         QTGkHPqyPf6CQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C49D0E21ECB;
        Sat, 11 Feb 2023 04:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5][pull request] Intel Wired LAN Driver Updates
 2023-02-09 (i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608802380.32607.15074636847208773440.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 04:00:23 +0000
References: <20230209172536.3595838-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230209172536.3595838-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  9 Feb 2023 09:25:31 -0800 you wrote:
> This series contains updates to i40e driver only.
> 
> Jan removes i40e_status from the driver; replacing them with standard
> kernel error codes.
> 
> Kees Cook replaces 0-length array with flexible array.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] i40e: Remove unused i40e status codes
    https://git.kernel.org/netdev/net-next/c/9d135352bb5d
  - [net-next,v2,2/5] i40e: Remove string printing for i40e_status
    https://git.kernel.org/netdev/net-next/c/5d968af27a16
  - [net-next,v2,3/5] i40e: use int for i40e_status
    https://git.kernel.org/netdev/net-next/c/5180ff1364bc
  - [net-next,v2,4/5] i40e: use ERR_PTR error print in i40e messages
    https://git.kernel.org/netdev/net-next/c/d5ba18423f87
  - [net-next,v2,5/5] net/i40e: Replace 0-length array with flexible array
    https://git.kernel.org/netdev/net-next/c/0d5292bb2966

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


