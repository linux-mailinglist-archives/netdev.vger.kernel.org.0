Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6E7685E96
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 05:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjBAEkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 23:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBAEkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 23:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18304FAFD;
        Tue, 31 Jan 2023 20:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 275C560E74;
        Wed,  1 Feb 2023 04:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FFF7C433EF;
        Wed,  1 Feb 2023 04:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675226419;
        bh=UlwjBzoJAPWYMQ72VAdrat0KEYevosv0d+OwcKc0Q0U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bmg0aBg+kX8y9BPmS/Y3Ts9JlEpRhRkiSIJDD/XasvIQYGGfBd7/TCKqW1BfnMKqo
         LhsF72pd0mAvFJrgA8Uzp/l6ngVSGctK5U9SQouMxfMtOlrl8SAfpPGnfXug/W4Mgm
         bTi0JanzqhZ3cUxhvTGE6OTMQfd6qNTpJvm/amoOeZTmz3yVXIQBmiAJJ91p9QzANE
         bf/xhrcfFT68ebGkspV2qECD5fO1nWwMhQJyoNtvVZ4UutKRWbHTf2OYAYIMr3hxeD
         Z66/rj548PzeON/XuR1Qx/Pn2ZGPnFDsG/Qh6TE6zJx3LnZm7jz8OMOopxD0Tj2PY2
         VpurZp/9k5pNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60E07C04E36;
        Wed,  1 Feb 2023 04:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/14] tools: ynl: more docs and basic ethtool
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522641938.28256.15256621461698900503.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 04:40:19 +0000
References: <20230131023354.1732677-1-kuba@kernel.org>
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, linux-doc@vger.kernel.org
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

On Mon, 30 Jan 2023 18:33:40 -0800 you wrote:
> I got discouraged from supporting ethtool in specs, because
> generating the user space C code seems a little tricky.
> The messages are ID'ed in a "directional" way (to and from
> kernel are separate ID "spaces"). There is value, however,
> in having the spec and being able to for example use it
> in Python.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/14] tools: ynl-gen: prevent do / dump reordering
    https://git.kernel.org/netdev/net-next/c/eaf317e7d2bb
  - [net-next,v2,02/14] tools: ynl: move the cli and netlink code around
    https://git.kernel.org/netdev/net-next/c/4e4480e89c47
  - [net-next,v2,03/14] tools: ynl: add an object hierarchy to represent parsed spec
    https://git.kernel.org/netdev/net-next/c/3aacf8281336
  - [net-next,v2,04/14] tools: ynl: use the common YAML loading and validation code
    https://git.kernel.org/netdev/net-next/c/30a5c6c8104f
  - [net-next,v2,05/14] tools: ynl: add support for types needed by ethtool
    https://git.kernel.org/netdev/net-next/c/19b64b48a33e
  - [net-next,v2,06/14] tools: ynl: support directional enum-model in CLI
    https://git.kernel.org/netdev/net-next/c/fd0616d34274
  - [net-next,v2,07/14] tools: ynl: support multi-attr
    https://git.kernel.org/netdev/net-next/c/90256f3f8093
  - [net-next,v2,08/14] tools: ynl: support pretty printing bad attribute names
    https://git.kernel.org/netdev/net-next/c/4cd2796f3f8d
  - [net-next,v2,09/14] tools: ynl: use operation names from spec on the CLI
    https://git.kernel.org/netdev/net-next/c/8dfec0a88868
  - [net-next,v2,10/14] tools: ynl: load jsonschema on demand
    https://git.kernel.org/netdev/net-next/c/5c6674f6eb52
  - [net-next,v2,11/14] netlink: specs: finish up operation enum-models
    https://git.kernel.org/netdev/net-next/c/8403bf044530
  - [net-next,v2,12/14] netlink: specs: add partial specification for ethtool
    https://git.kernel.org/netdev/net-next/c/b784db7ae840
  - [net-next,v2,13/14] docs: netlink: add a starting guide for working with specs
    https://git.kernel.org/netdev/net-next/c/01e47a372268
  - [net-next,v2,14/14] tools: net: use python3 explicitly
    https://git.kernel.org/netdev/net-next/c/981cbcb030d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


