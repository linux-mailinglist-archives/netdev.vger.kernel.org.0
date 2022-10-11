Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468CF5FA9E9
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJKBU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJKBUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D907D82616
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6675C6106F
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADE2FC43143;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665451215;
        bh=8/lUeQjjaCMONKMG3l2ItYHWgZtyM1rw6alDKIgaCK4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EH0E9++iknE21Dt1tbkY3dCOuDXoEVZgj+DufvSZRTJdvkx4SziwBwsyAJZUozPGd
         MmTXEOAPyZ5EJAJ+qPHDSJ8IagYOczt+tnn+Z/OcOcOEJgDykJly/MW0+vi7qEoOm6
         7Oi1+XguI7s4+OTibtH88y809SRAavXvmw2GiiPY0CTIypcFfzZM73JY1f3uebQU/N
         sJwlGEAR+HZdmwsEpU5HfU7mVIJf22l2ZIU7ICnyHcsG9Kt47w+/5Xnrbr7Xu4J4dD
         AtcfmCS2f+4KFqDHWlid8e3y8AQ4U/RP6GeAbAnxMW218aSXcjggahsu7Z86aZlhxg
         zgPsOjlzBwLqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8FD4AE4D022;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: flower: fix incorrect struct type in GRE key_size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166545121558.22576.11444757861378993695.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Oct 2022 01:20:15 +0000
References: <20221007092132.218386-1-simon.horman@corigine.com>
In-Reply-To: <20221007092132.218386-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        louis.peens@corigine.com, chaoyong.he@corigine.com
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

On Fri,  7 Oct 2022 11:21:32 +0200 you wrote:
> From: Louis Peens <louis.peens@corigine.com>
> 
> Looks like a copy-paste error sneaked in here at some point,
> causing the key_size for these tunnels to be calculated
> incorrectly. This size ends up being send to the firmware,
> causing unexpected behaviour in some cases.
> 
> [...]

Here is the summary with links:
  - [net] nfp: flower: fix incorrect struct type in GRE key_size
    https://git.kernel.org/netdev/net/c/b15e2e49bfc4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


