Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09FB67C757
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 10:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbjAZJag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 04:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbjAZJad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 04:30:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8DA2A9A3;
        Thu, 26 Jan 2023 01:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83C7861768;
        Thu, 26 Jan 2023 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4F23C433EF;
        Thu, 26 Jan 2023 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674725418;
        bh=Ruqnhc+7PYTr7z3FYV5CHCd1hZO25Q6axJqbLEz/kNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePWixslcsb/cBxF+1tgycmty6s7EKk0Y2V8hPrMDCYteyhmRHgfA12lyUangY2do0
         eWdIBogVmEW0d+1fOZo2kwwQzfIYRWs6jSd6cKm3gN7p/jbjBnMurbTs6Wo0Uhm5PZ
         9M8Ajj04KCT4A64taXieaVXrJ2KRcHVjs6SHUApxsw1GpG029DeL6O7WOWTOjOx5vj
         KAu7N1wIn2FPV2CujzjPEPqbE9+tguhdfvdyTz3+ybAWNSAdNvYeWLIMmJ2MHU44ix
         4dhwpReREt1BFyZQA5EFUnCO1pZi8MXg+IWSfhM/GdnaaQcdtMDHluMtDcVknXRcX2
         hZtGNEMpbBRpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDF67E21EE1;
        Thu, 26 Jan 2023 09:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/8] Adding Sparx5 IS0 VCAP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167472541783.8706.4708423989079576378.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 09:30:17 +0000
References: <20230124104511.293938-1-steen.hegelund@microchip.com>
In-Reply-To: <20230124104511.293938-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, error27@gmail.com, michael@walle.cc
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 24 Jan 2023 11:45:03 +0100 you wrote:
> This provides the Ingress Stage 0 (IS0) VCAP (Versatile Content-Aware
> Processor) support for the Sparx5 platform.
> 
> The IS0 VCAP (also known in the datasheet as CLM) is a classifier VCAP that
> mainly extracts frame information to metadata that follows the frame in the
> Sparx5 processing flow all the way to the egress port.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] net: microchip: sparx5: Add IS0 VCAP model and updated KUNIT VCAP model
    https://git.kernel.org/netdev/net-next/c/f274a659fb08
  - [net-next,v2,2/8] net: microchip: sparx5: Add IS0 VCAP keyset configuration for Sparx5
    https://git.kernel.org/netdev/net-next/c/545609fd4e7f
  - [net-next,v2,3/8] net: microchip: sparx5: Add actionset type id information to rule
    https://git.kernel.org/netdev/net-next/c/7306fcd17c0c
  - [net-next,v2,4/8] net: microchip: sparx5: Add TC support for IS0 VCAP
    https://git.kernel.org/netdev/net-next/c/542e6e2c20e5
  - [net-next,v2,5/8] net: microchip: sparx5: Add TC filter chaining support for IS0 and IS2 VCAPs
    https://git.kernel.org/netdev/net-next/c/88bd9ea70b2e
  - [net-next,v2,6/8] net: microchip: sparx5: Add automatic selection of VCAP rule actionset
    https://git.kernel.org/netdev/net-next/c/81e164c4aec5
  - [net-next,v2,7/8] net: microchip: sparx5: Add support for IS0 VCAP ethernet protocol types
    https://git.kernel.org/netdev/net-next/c/63e3564507ea
  - [net-next,v2,8/8] net: microchip: sparx5: Add support for IS0 VCAP CVLAN TC keys
    https://git.kernel.org/netdev/net-next/c/52df82cc9199

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


