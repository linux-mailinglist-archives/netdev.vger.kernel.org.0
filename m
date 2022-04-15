Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53679502822
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244535AbiDOKWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352275AbiDOKWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69439B8980
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F442621DB
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 10:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66270C385AE;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650018014;
        bh=l6nJakrRsg7hkJxnptbN8hADIyXMi981CubcKKfgrHg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NNBifOGsW5tFvd7cgRtp7Tkcg9CuIHgTSN/S2BEd7xy1ieWR3sAK0bsd/Cwysebor
         AiWCg2tGNApnq2ZXZkZc6jby9zP6bP1+M+6hZ1ET0td3/d5k9x/lzyDTmSw4F0Ad4x
         OFISMIwtyHAV401mj6b2d7rGh4cI/jeHGKViKCGGIQY4xS7i0giVh56wqMC0hHHuck
         YWeAsawqdWcHjgOv2LWFMAghLuKjwaOOGOYTs8Xcvta1U9o5s5e7H59x7dASeDmNW1
         E5PzRmItvUeNvqmUJu0E4nf16/wi6KX6ZKPnLFhn7fU3AmqI2Wi82l/fMeVJMLbvRB
         11kxZBy+itssw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 46D01E8DD6A;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mlxsw: Preparations for line cards support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001801427.12692.16843453535568835169.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:20:14 +0000
References: <20220413151733.2738867-1-idosch@nvidia.com>
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, vadimp@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 18:17:24 +0300 you wrote:
> Currently, mlxsw registers thermal zones as well as hwmon entries for
> objects such as transceiver modules and gearboxes. In upcoming modular
> systems, these objects are no longer found on the main board (i.e., slot
> 0), but on plug-able line cards. This patchset prepares mlxsw for such
> systems in terms of hwmon, thermal and cable access support.
> 
> Patches #1-#3 gradually prepare mlxsw for transceiver modules access
> support for line cards by splitting some of the internal structures and
> some APIs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mlxsw: core: Extend interfaces for cable info access with slot argument
    https://git.kernel.org/netdev/net-next/c/349454526f5f
  - [net-next,2/9] mlxsw: core: Extend port module data structures for line cards
    https://git.kernel.org/netdev/net-next/c/e5b6a5bac8cc
  - [net-next,3/9] mlxsw: core: Move port module events enablement to a separate function
    https://git.kernel.org/netdev/net-next/c/b244143a085e
  - [net-next,4/9] mlxsw: core_hwmon: Extend internal structures to support multi hwmon objects
    https://git.kernel.org/netdev/net-next/c/b890ad418e1f
  - [net-next,5/9] mlxsw: core_hwmon: Introduce slot parameter in hwmon interfaces
    https://git.kernel.org/netdev/net-next/c/fd27849dd6fd
  - [net-next,6/9] mlxsw: core_thermal: Extend internal structures to support multi thermal areas
    https://git.kernel.org/netdev/net-next/c/ef0df4fa324a
  - [net-next,7/9] mlxsw: core_thermal: Add line card id prefix to line card thermal zone name
    https://git.kernel.org/netdev/net-next/c/6d94449a7d7d
  - [net-next,8/9] mlxsw: core_thermal: Use exact name of cooling devices for binding
    https://git.kernel.org/netdev/net-next/c/739d56bc635e
  - [net-next,9/9] mlxsw: core_thermal: Use common define for thermal zone name length
    https://git.kernel.org/netdev/net-next/c/03978fb88b06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


