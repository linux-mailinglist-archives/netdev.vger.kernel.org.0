Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CB063717E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKXEaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiKXEaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:30:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F318FC5B49;
        Wed, 23 Nov 2022 20:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9D97B826C4;
        Thu, 24 Nov 2022 04:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66F6FC433D7;
        Thu, 24 Nov 2022 04:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669264215;
        bh=XUXiYeP4N9pnP2cqE1lGv8knsNbWK1QXgjYRJ0XSCaA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jYjaSJG63SKboMsrjgVy/Fypfcur69MxZeJdTNNUxRFdloiO2JD8fS12iuAyGph8j
         ujK3MH35WB5iqGLuzfactdZt+vq6vjOevxHd+MhhbrFM/OCKLyEo7sZzdvbWKgVtbx
         4soP92CD9S/ukpQerYVLuHU4DktINhr7JuOjukNl2WjiOriXUs1kchS4xX0UvhRJ8t
         XiEICG16mXvCQ2rAKiZWt8w62Z7z3GxtrOAqyS0jqwsKVrHT7X1cLMIU9jzGi2uTdZ
         kL2yMRBDSDmbxSZUKMSz3TAv/GBTdePxe6/2qB2r/rpJH5CTP6YbdVCfRGYaf21RbV
         upQ21/615IQtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CBF2C395EE;
        Thu, 24 Nov 2022 04:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: preserve TX ring priority across
 reconfiguration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166926421531.27044.935878443390847890.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 04:30:15 +0000
References: <20221122130936.1704151-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221122130936.1704151-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Nov 2022 15:09:36 +0200 you wrote:
> In the blamed commit, a rudimentary reallocation procedure for RX buffer
> descriptors was implemented, for the situation when their format changes
> between normal (no PTP) and extended (PTP).
> 
> enetc_hwtstamp_set() calls enetc_close() and enetc_open() in a sequence,
> and this sequence loses information which was previously configured in
> the TX BDR Mode Register, specifically via the enetc_set_bdr_prio() call.
> The TX ring priority is configured by tc-mqprio and tc-taprio, and
> affects important things for TSN such as the TX time of packets. The
> issue manifests itself most visibly by the fact that isochron --txtime
> reports premature packet transmissions when PTP is first enabled on an
> enetc interface.
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: preserve TX ring priority across reconfiguration
    https://git.kernel.org/netdev/net/c/290b5fe096e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


