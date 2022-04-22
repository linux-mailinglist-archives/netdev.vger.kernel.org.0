Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C06B50C43E
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiDVXKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiDVXKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:10:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4DB17B981
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F269B832FF
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 22:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A77EC385A0;
        Fri, 22 Apr 2022 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650667811;
        bh=AMqODBHZdFoXf4eWceD1N5aUWAUWKcXJ4disJkehAdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TvyaLHOKZAjiE9Q7lOAeZU7mpn8YqGIGcNewo3RoTsDMAf0TusraeoYn3kF/GsesL
         jylCX3nAMEzOJA5wY61s47iLHJy4N2KUcxbI1vyzaR7M+AeCi3M6eojduchBD1rI9F
         pbt6iEFQZJSUn5qmxdqzC5QLjx8qVYIFongAMxLuN++xhtJ0jGzroIJVp92Z6CzBMS
         BT4JWGxqN7u77s8XoqEM0R4JdJCWv7zmE6XqVNaCpWlCXpBZWnr8dya/L6lEMgoVlF
         m708G5HCO00igeDDT2beT/HdTmFx77iVb/PjGGpyZPrqosU2xYjXG6fubgUeJrZ8Op
         hUoH3A5OE7N4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EDCFE6D402;
        Fri, 22 Apr 2022 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: core_linecards: Fix size of array element
 during ini_files allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165066781105.1898.16601124860557760677.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 22:50:11 +0000
References: <20220420142007.3041173-1-idosch@nvidia.com>
In-Reply-To: <20220420142007.3041173-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 20 Apr 2022 17:20:07 +0300 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> types_info->ini_files is an array of pointers
> to struct mlxsw_linecard_ini_file.
> 
> Fix the kmalloc_array() argument to be of a size of a pointer.
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: core_linecards: Fix size of array element during ini_files allocation
    https://git.kernel.org/netdev/net-next/c/869376d0859a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


