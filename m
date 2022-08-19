Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F2959A9A0
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243607AbiHSXuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243493AbiHSXuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1515E108F17;
        Fri, 19 Aug 2022 16:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A57F616D5;
        Fri, 19 Aug 2022 23:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED0A4C433B5;
        Fri, 19 Aug 2022 23:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660953019;
        bh=CuQ5Q9EewpvW9DDE3E3uqhT70iZXoQdmu06/1ktmPDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U6GGTPHDLBiPb6MzRyp9FD9HLvdHJrDRAg5X6mhXZAklnI+bG32ezr0sXqJqavBci
         ww6FIALOoXsGymiY1anis2yA91KWRNY0k8QOiZKCqbfg5C6fqUqsSlWp2MWkc+RwGH
         ARJHFbtLS1Cbz0SHzAiAPIpb8w1Cjgf6x4ITmJhm3EYASqnZ+fczLJfaaT4X5Yd8cA
         OsSZKyhLHSFqB3mycA21dkHMnG0I+GOmxJg6M5oh60bXL05wUMjoTGxum4M1ejfxII
         u5YLBHCk7y8gkIRO/4nRi9cFltqV2W2G1CzGIwMI+2fYZD9aksbS4zig6NUibhgs/M
         GkL1PWICRzHEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C389DE2A05E;
        Fri, 19 Aug 2022 23:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next v4 00/25] net: dpaa: Cleanups in preparation
 for phylink conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166095301878.11596.4206338454317459884.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Aug 2022 23:50:18 +0000
References: <20220818161649.2058728-1-sean.anderson@seco.com>
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, camelia.groza@nxp.com,
        linux-kernel@vger.kernel.org, madalin.bucur@nxp.com,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, leoyang.li@nxp.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Aug 2022 12:16:24 -0400 you wrote:
> This series contains several cleanup patches for dpaa/fman. While they
> are intended to prepare for a phylink conversion, they stand on their
> own. This series was originally submitted as part of [1].
> 
> [1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com
> 
> Changes in v4:
> - Clarify commit message
> - weer -> were
> - tricy -> tricky
> - Use mac_dev for calling change_addr
> - qman_cgr_create -> qman_create_cgr
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,v4,01/25] dt-bindings: net: Convert FMan MAC bindings to yaml
    https://git.kernel.org/netdev/net-next/c/ee8433da085e
  - [RESEND,net-next,v4,02/25] net: fman: Convert to SPDX identifiers
    https://git.kernel.org/netdev/net-next/c/8585bdadc247
  - [RESEND,net-next,v4,03/25] net: fman: Don't pass comm_mode to enable/disable
    https://git.kernel.org/netdev/net-next/c/b7d852566a52
  - [RESEND,net-next,v4,04/25] net: fman: Store en/disable in mac_device instead of mac_priv_s
    https://git.kernel.org/netdev/net-next/c/e61406a1955e
  - [RESEND,net-next,v4,05/25] net: fman: dtsec: Always gracefully stop/start
    https://git.kernel.org/netdev/net-next/c/aae73fde7eb3
  - [RESEND,net-next,v4,06/25] net: fman: Get PCS node in per-mac init
    https://git.kernel.org/netdev/net-next/c/478eb957ced6
  - [RESEND,net-next,v4,07/25] net: fman: Store initialization function in match data
    https://git.kernel.org/netdev/net-next/c/28c3948a018d
  - [RESEND,net-next,v4,08/25] net: fman: Move struct dev to mac_device
    https://git.kernel.org/netdev/net-next/c/7bd63966f0cc
  - [RESEND,net-next,v4,09/25] net: fman: Configure fixed link in memac_initialization
    https://git.kernel.org/netdev/net-next/c/9ea4742a55ca
  - [RESEND,net-next,v4,10/25] net: fman: Export/rename some common functions
    https://git.kernel.org/netdev/net-next/c/c496e4d686aa
  - [RESEND,net-next,v4,11/25] net: fman: memac: Use params instead of priv for max_speed
    https://git.kernel.org/netdev/net-next/c/c0e36be156c2
  - [RESEND,net-next,v4,12/25] net: fman: Move initialization to mac-specific files
    (no matching commit)
  - [RESEND,net-next,v4,13/25] net: fman: Mark mac methods static
    (no matching commit)
  - [RESEND,net-next,v4,14/25] net: fman: Inline several functions into initialization
    (no matching commit)
  - [RESEND,net-next,v4,15/25] net: fman: Remove internal_phy_node from params
    (no matching commit)
  - [RESEND,net-next,v4,16/25] net: fman: Map the base address once
    (no matching commit)
  - [RESEND,net-next,v4,17/25] net: fman: Pass params directly to mac init
    (no matching commit)
  - [RESEND,net-next,v4,18/25] net: fman: Use mac_dev for some params
    (no matching commit)
  - [RESEND,net-next,v4,19/25] net: fman: Specify type of mac_dev for exception_cb
    (no matching commit)
  - [RESEND,net-next,v4,20/25] net: fman: Clean up error handling
    (no matching commit)
  - [RESEND,net-next,v4,21/25] net: fman: Change return type of disable to void
    (no matching commit)
  - [RESEND,net-next,v4,22/25] net: dpaa: Use mac_dev variable in dpaa_netdev_init
    (no matching commit)
  - [RESEND,net-next,v4,23/25] soc: fsl: qbman: Add helper for sanity checking cgr ops
    (no matching commit)
  - [RESEND,net-next,v4,24/25] soc: fsl: qbman: Add CGR update function
    (no matching commit)
  - [RESEND,net-next,v4,25/25] net: dpaa: Adjust queue depth on rate change
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


