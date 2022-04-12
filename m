Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE1B4FE66F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbiDLRCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357940AbiDLRCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:02:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0F44EA2D
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C389B6193E
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 17:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2652BC385A8;
        Tue, 12 Apr 2022 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649782817;
        bh=cZV+Qba2S1WUBCE3kPnZl9+NTq5JmMlCeaD2G70qI3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jK30fN4tfChHh++M85PFg8GG1jxYwc7wuMDbwZFx0FGY2bRdk3Ldkv3s3U1RACp72
         i4Hg8OQI5kDFOXPeauGK/3P/ClUiEvOLf1f6mE/9+0/LJUuLyiKQvKUakZ7lh5htM1
         mDGhQDE//mQ2h257Pm7eS3J5+fCPEmNtmyIsWKdryscLHXGqyZJGsPXGWZ+3ll+qbG
         BQCqPlp5fXwOWVcVG9i7OoXOmHZtENo1neBfaM26M8hZ8V35UhM7P/b+WE5cVCMmW0
         uhQ004pxlvEcjSOkfDi7Bh6/f357UzIROEu4VEqBT+K+njO+LgbtOyqG/Iv1OLcT+2
         CA1Lvy13pOngQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3D53E8DD64;
        Tue, 12 Apr 2022 17:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Extend device registers for line cards
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164978281699.11565.1801320900438934274.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 17:00:16 +0000
References: <20220411144657.2655752-1-idosch@nvidia.com>
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com
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

On Mon, 11 Apr 2022 17:46:49 +0300 you wrote:
> This patch set prepares mlxsw for line cards support by extending device
> registers with a slot index, which allows accessing components found on
> a line card at a given slot. Currently, only slot index 0 (main board)
> is used.
> 
> No user visible changes that I am aware of.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: reg: Extend MTMP register with new slot number field
    https://git.kernel.org/netdev/net-next/c/d30bed29a718
  - [net-next,2/8] mlxsw: reg: Extend MTBR register with new slot number field
    https://git.kernel.org/netdev/net-next/c/c6e6ad703ed2
  - [net-next,3/8] mlxsw: reg: Extend MCIA register with new slot number field
    https://git.kernel.org/netdev/net-next/c/89dd6fcd07f9
  - [net-next,4/8] mlxsw: reg: Extend MCION register with new slot number field
    https://git.kernel.org/netdev/net-next/c/655cbb1d7530
  - [net-next,5/8] mlxsw: reg: Extend PMMP register with new slot number field
    https://git.kernel.org/netdev/net-next/c/7cb85d3c696e
  - [net-next,6/8] mlxsw: reg: Extend MGPIR register with new slot fields
    https://git.kernel.org/netdev/net-next/c/b691602c6f96
  - [net-next,7/8] mlxsw: core_env: Pass slot index during PMAOS register write call
    https://git.kernel.org/netdev/net-next/c/64e65a540e6d
  - [net-next,8/8] mlxsw: reg: Add new field to Management General Peripheral Information Register
    https://git.kernel.org/netdev/net-next/c/e94295e0ed27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


