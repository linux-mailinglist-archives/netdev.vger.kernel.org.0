Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F985513BE
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbiFTJKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240228AbiFTJKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E686373
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35F67613F8
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 09:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F33FC341C5;
        Mon, 20 Jun 2022 09:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655716214;
        bh=jbDUcaYi2MV6+nB5uweJFFohttqQxmUjDB+3uEYG2wk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bk3ktuL7r5clF2kEoxvT6L32trFYqvb80gRuMyC7P2rf9sIdJ6mnBgyDAFtrckvph
         Px1ZnJlhNekRR75BRqjdctASRqduT7EAcKL0nZILk8hM66hHyy8PzCiskPnC9rJT0D
         oSgGdlhtm5LKtXWw8fxibObKmznaA55vmcYerCFvRbZGvHL5KQcUrrNs4upMFUUN9w
         zx5GX+1JselhiQmsN5HcT4Z0nrWum3NMNA1ksLQsdy2njDRVsQBs+AwqOsY5uYCMvI
         sq3/+AH+GiXExCBZqE0/mXRIxFy/tsH9QS1DvFk27g7Goa3+x6e15zkn66I18GVcop
         pk3dRQkLYSoJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72E60E737E8;
        Mon, 20 Jun 2022 09:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] mlxsw: Unified bridge conversion - part 1/6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165571621446.5300.5325520409391040404.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 09:10:14 +0000
References: <20220619102921.33158-1-idosch@nvidia.com>
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Sun, 19 Jun 2022 13:29:08 +0300 you wrote:
> This set starts converting mlxsw to the unified bridge model and mainly
> adds new device registers and extends existing ones that will be used in
> follow-up patchsets.
> 
> High-level summary
> ==================
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] mlxsw: reg: Add 'flood_rsp' field to SFMR register
    https://git.kernel.org/netdev/net-next/c/02d23c9544ea
  - [net-next,02/13] mlxsw: reg: Add ingress RIF related fields to SFMR register
    https://git.kernel.org/netdev/net-next/c/e459466a26bb
  - [net-next,03/13] mlxsw: reg: Add ingress RIF related fields to SVFA register
    https://git.kernel.org/netdev/net-next/c/dd326565c59e
  - [net-next,04/13] mlxsw: reg: Add Switch Multicast Port to Egress VID Register
    https://git.kernel.org/netdev/net-next/c/e0f071c5b8e1
  - [net-next,05/13] mlxsw: Add SMPE related fields to SMID2 register
    https://git.kernel.org/netdev/net-next/c/894b98d50b64
  - [net-next,06/13] mlxsw: reg: Add SMPE related fields to SFMR register
    https://git.kernel.org/netdev/net-next/c/92e4e543b128
  - [net-next,07/13] mlxsw: reg: Add VID related fields to SFD register
    https://git.kernel.org/netdev/net-next/c/485c281cadf7
  - [net-next,08/13] mlxsw: reg: Add flood related field to SFMR register
    https://git.kernel.org/netdev/net-next/c/94536249b8d8
  - [net-next,09/13] mlxsw: reg: Replace MID related fields in SFGC register
    https://git.kernel.org/netdev/net-next/c/48bca94fff12
  - [net-next,10/13] mlxsw: reg: Add Router Egress Interface to VID Register
    https://git.kernel.org/netdev/net-next/c/27f0b6ce06d7
  - [net-next,11/13] mlxsw: reg: Add egress FID field to RITR register
    https://git.kernel.org/netdev/net-next/c/ad9592c061e3
  - [net-next,12/13] mlxsw: Add support for egress FID classification after decapsulation
    https://git.kernel.org/netdev/net-next/c/1b1c198c306c
  - [net-next,13/13] mlxsw: reg: Add support for VLAN RIF as part of RITR register
    https://git.kernel.org/netdev/net-next/c/b3820922651a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


