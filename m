Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03466E05EC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjDMEUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDMEUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CC57ECF
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 421E563B58
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A3B7C433EF;
        Thu, 13 Apr 2023 04:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681359618;
        bh=ETdYY8yCtfsqNjJZPQqZYp3KfqgPC9QitpzB6fHVRVc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fjyQmqESQJHt2eDBR/V6NDG4YWtb/DCPOSSNvy51iKkqbKrsFRPJU0ObzSgHfxzH2
         /0c7wTb8/cn8RaS0NXLu44TROaLQuazmLMKIHlO8MM8yMNq6LKiagpYonr4PiIWixm
         F4w/NChsi8OiIHD4PCZy5act5Y+qQTq0BjlgMMNDig2r38Ymo26tmIQfOcRceXn/Ru
         IJFAXEd6peUK3V+yzpaA3kvGQzmFqhA15fq0abcqTuk2GS8KaY/i/g63Fc3thL8tBj
         VqNCoB3SwU2LKv6g4OWtU+e231zwbojrbQsSP5uMxACbc1F05XRPXmP+0hmikteqpg
         Zo9HXpmElJtzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A189E21ED9;
        Thu, 13 Apr 2023 04:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] tools: ynl: Remove absolute paths to yaml files
 from ethtool testing tool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168135961849.12762.11668973666026729971.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 04:20:18 +0000
References: <20230413012252.184434-1-rrameshbabu@nvidia.com>
In-Reply-To: <20230413012252.184434-1-rrameshbabu@nvidia.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, sdf@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Apr 2023 18:22:51 -0700 you wrote:
> Absolute paths for the spec and schema files make the ethtool testing tool
> unusable with freshly checked-out source trees. Replace absolute paths with
> relative paths for both files in the Documentation/ directory.
> 
> Issue seen before the change
> 
>   Traceback (most recent call last):
>     File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/./ethtool", line 424, in <module>
>       main()
>     File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/./ethtool", line 158, in main
>       ynl = YnlFamily(spec, schema)
>     File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/lib/ynl.py", line 342, in __init__
>       super().__init__(def_path, schema)
>     File "/home/binary-eater/Documents/mlx/linux/tools/net/ynl/lib/nlspec.py", line 333, in __init__
>       with open(spec_path, "r") as stream:
>   FileNotFoundError: [Errno 2] No such file or directory: '/usr/local/google/home/sdf/src/linux/Documentation/netlink/specs/ethtool.yaml'
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] tools: ynl: Remove absolute paths to yaml files from ethtool testing tool
    (no matching commit)
  - [net-next,2/2] tools: ynl: Rename ethtool to ethtool.py
    https://git.kernel.org/netdev/net-next/c/f2b3b6a22df7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


