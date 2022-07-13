Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A868F572A53
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 02:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiGMAkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 20:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGMAkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 20:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC036EEB9;
        Tue, 12 Jul 2022 17:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37FD16186A;
        Wed, 13 Jul 2022 00:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DED9C341C0;
        Wed, 13 Jul 2022 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657672815;
        bh=DNcEjjLhY52AkLRFOWe0WujsTbwK6KG4udGVRUUCRCI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gHSyJh+6KneImGIGuMdSsx7Fnvkkyqh5WFllLd239J5QE7/n9DRWqohZVlVp0ExHA
         PHIz59OqeT6lmSAWhVjpqceq0cSxVUgBPdQTUo3xnSVbrgmEbK7IlnAHSxnGhtEgBL
         M8f6BBjec06zfpIuPm2Bs1xVcvuIQXC3lV3+wM6gPrnNseIEmyiDxP23mVu3IxTr3o
         g2ecc4toBFG0PPKvkj01IS5/usa22Gp2iFoPS8CTlRf4LQ3p+IvfVQgSorl1sIgbBy
         ycmZ3r3MJVh95OncO/w79D0ZS9Kp0BxFu0EQVPVx7rU7hK61Hm4gxQiEt/SQExDChi
         GY/LOlpYPcodw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76E22E45227;
        Wed, 13 Jul 2022 00:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] dt-bindings: net: convert sff,sfp to dtschema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165767281548.22277.15340195175706215150.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 00:40:15 +0000
References: <20220707091437.446458-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220707091437.446458-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        linux@armlinux.org.uk, devicetree@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  7 Jul 2022 12:14:33 +0300 you wrote:
> This patch set converts the sff,sfp to dtschema.
> 
> The first patch does a somewhat mechanical conversion without changing
> anything else beside the format in which the dt binding is presented.
> 
> In the second patch we rename some dt nodes to be generic. The last two
> patches change the GPIO related properties so that they uses the -gpios
> preferred suffix. This way, all the DTBs are passing the validation
> against the sff,sfp.yaml binding.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] dt-bindings: net: convert sff,sfp to dtschema
    https://git.kernel.org/netdev/net-next/c/70991f1e6858
  - [net-next,v3,2/4] dt-bindings: net: sff,sfp: rename example dt nodes to be more generic
    https://git.kernel.org/netdev/net-next/c/7ff7c9922859
  - [net-next,v3,3/4] arch: arm64: dts: lx2160a-clearfog-itx: rename the sfp GPIO properties
    https://git.kernel.org/netdev/net-next/c/dfa2854cbf92
  - [net-next,v3,4/4] arch: arm64: dts: marvell: rename the sfp GPIO properties
    https://git.kernel.org/netdev/net-next/c/4ce223e5ef70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


