Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB66651A7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjAKCUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbjAKCUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3298C05;
        Tue, 10 Jan 2023 18:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DB49B81AB1;
        Wed, 11 Jan 2023 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 157C5C433D2;
        Wed, 11 Jan 2023 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673403616;
        bh=G3X9KR9XcUtuo40UIMjSYPmMKjBh9PsVlFE84QeF+ow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dj8ZJjq8iWxU6qXxeVP5K6hVrLmimpT1mgTz+X5BdWm4cKxwle28R8309G/rCTytE
         3IPnRzQtrRI9MGSlzJayrZRj6MNr0gsjMEAmgNRWxeXCKHerSDJxtcgMLeNn22U/3X
         9GFDFKp67K0DisweKp8XW2MdlEMP+snEP7vhYw7Rd2LPeqmaKIIoVivQc6P6FxHJpS
         2gn0Kb9MrMWHundskL7DBPEjkiFI/c+vDxCLCVXXXRQfz9I09oiip4Porl2TxSVnVy
         USlpenaBrInz6lneBliDBzk0injx+TUp+Bz+jbSZYxdgyEQDL1X/oy61SgGkM+1E8b
         ZJ6zkiFeOK8lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBE45E21EE8;
        Wed, 11 Jan 2023 02:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: =?utf-8?q?=5BPATCH_net-next=5D_qed=3A_fix_a_typo_in_comment?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167340361596.6139.6625577007589986294.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 02:20:15 +0000
References: <202301091935262709751@zte.com.cn>
In-Reply-To: <202301091935262709751@zte.com.cn>
To:     Yang Yang <yang.yang29@zte.com.cn>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dai.shixin@zte.com.cn
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 9 Jan 2023 19:35:26 +0800 (CST) you wrote:
> From: Dai Shixin <dai.shixin@zte.com.cn>
> 
> Fix a typo of "permision" which should be "permission".
> 
> Signed-off-by: Dai Shixin <dai.shixin@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [net-next] qed: fix a typo in comment
    https://git.kernel.org/netdev/net-next/c/a6f536063b69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


