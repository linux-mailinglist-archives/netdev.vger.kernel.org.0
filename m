Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E21468DDD0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjBGQUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjBGQUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A332E2684D
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 08:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3664360DD4
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B743C4339B;
        Tue,  7 Feb 2023 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675786818;
        bh=t+R2DWuMuiYUQ/oQj72muzF2ysG28x5Fee0s0tborpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lydmVx4f9TPi9LYlH92UZbcCvJWAZ9ecooCNr+34HL69W1MkImUj4stNz1oL3WOza
         IPm6oercZto38W3gCrSQmIiTkyiplhgGgmpWoNCWFkJDTLip5CyCt9ZzKeLwsPawXz
         ZtJBQA7eSqGh7vJBeIS0WWtNAtvFbe1z32v+FSzvvi0MwFbQybbrmfyJOjwlczngco
         1mfleGZkjT4mrsX72K/cKNDmrElQ5a30o3CEvfZiOBHn+4p1wlCGhVZUgMWXd/F9Rx
         SVixhfdNlUTcJs3gSe2c4AxyG2mEfKQ/ZZaS6A+IIYnjK+gyu+ZfF9WDN7QJNyXEfT
         Ivv7LPxbEC/Iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81C7EE55F09;
        Tue,  7 Feb 2023 16:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2 0/3] bridge: Support mcast_n_groups,
 mcast_max_groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167578681852.1661.11842550127865456255.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 16:20:18 +0000
References: <cover.1675765297.git.petrm@nvidia.com>
In-Reply-To: <cover.1675765297.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, razor@blackwall.org, idosch@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 7 Feb 2023 11:27:47 +0100 you wrote:
> In the Linux kernel commit cb3086cee656 ("Merge branch
> 'bridge-mdb-limit'"), the bridge driver gained support for limiting number
> of MDB entries that a given port or port-VLAN is a member of. Support these
> new attributes in iproute2's bridge tool.
> 
> After syncing the two relevant headers in patch #1, patch #2 introduces the
> meat of the support, and patch #3 the man page coverage.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2,1/3] uapi: Update if_bridge, if_link
    (no matching commit)
  - [iproute2-next,v2,2/3] bridge: Add support for mcast_n_groups, mcast_max_groups
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=4300ee77e807
  - [iproute2-next,v2,3/3] man: man8: bridge: Describe mcast_max_groups
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b96b06830fe1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


