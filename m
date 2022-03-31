Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4454ED1A0
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 04:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiCaCWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 22:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244768AbiCaCV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 22:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955F466AE6
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 19:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ADCC61876
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 02:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F9A0C3410F;
        Thu, 31 Mar 2022 02:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648693211;
        bh=Y0DbV97ismISiex2NIHJwHZ+gDuyyCQ2IiM8JW5VD3E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W0Um8Dpjvl7MPlcT+XY5+LLiW2AxcQfbsw26ZBvk334WjM7/TxBX2rzwl7QalcOEE
         qxFVFTgHPcUm4h3xz/lxIO5pN0YjjdL6mUJs3AQIfZtPa5madEksFagXf6+IrsyWmd
         259Vns43vr7k7ygBPrl52M21Gm2s8+qU/+g8L3V0CsjspqWKH8pEZIlN3YjuxvrFNP
         1cqqx8kJgN5dhBert3xNqIM3ytAsYyp9OyL1XSREuVhy3o/4Q5ZoKvsNpR5oHwSCON
         dESQPwIczp4smeS0sQoyAJKWQmTlHFujKm3FIqLlbvWuR2hW2dc/SsZ7Ze94uAx9cH
         PhC+Xb3RwRGmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66994F0384B;
        Thu, 31 Mar 2022 02:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: uses, depends on BRIDGE or !BRIDGE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164869321141.20858.12911759079102218270.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 02:20:11 +0000
References: <20220330012025.29560-1-rdunlap@infradead.org>
In-Reply-To: <20220330012025.29560-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev, lkp@intel.com,
        horatiu.vultur@microchip.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Mar 2022 18:20:25 -0700 you wrote:
> Fix build errors when BRIDGE=m and SPARX5_SWITCH=y:
> 
> riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L305':
> sparx5_switchdev.c:(.text+0xdb0): undefined reference to `br_vlan_enabled'
> riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L283':
> sparx5_switchdev.c:(.text+0xee0): undefined reference to `br_vlan_enabled'
> 
> [...]

Here is the summary with links:
  - net: sparx5: uses, depends on BRIDGE or !BRIDGE
    https://git.kernel.org/netdev/net/c/f9512d654f62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


