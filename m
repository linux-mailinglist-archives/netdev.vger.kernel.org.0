Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684294E2508
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346688AbiCULLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346577AbiCULLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:11:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC60393CD;
        Mon, 21 Mar 2022 04:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E577060AD6;
        Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4664BC340F3;
        Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647861010;
        bh=Lr+4/BKBMCYUnCpDZoFsUsNMahesPV4BHyDtQEQpEMM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=spQDtEZDyjbhXtN8V/UJKEFis6TQiyUaMpqNIkSUqBMbvM5xHMk2ww4f/E1HRJfyy
         Vt5S4+v/KTuClgGqdgAEquZnOrU7FA4BBORumaNNxeTWYJeZD+YuFbHz2rFvJf2lX/
         qvbF5Cp7qX00twYveeQ3c/TWCvEzPRp/hBzEFp75mSorW5kwaC8bQC2cMBxaIzciTj
         lQK8K3LnrBVuYcoofauNSr9Ay3b5Dv6V6sDzncJz246MtMPMQAQPNMv1GQvTH3d3YX
         oO5N0XAIdo2fcjyLB4XwF0y2zpeNmkR5qeExmyWNrjh/0fv0K1DEAOedKRHf85ATET
         AXhlskd2Tq2fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27054E7BB0B;
        Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: remove unnecessary memset in qed_init_fw_funcs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164786101015.12168.12932590241083044976.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 11:10:10 +0000
References: <20220318093153.521634-1-wanjiabing@vivo.com>
In-Reply-To: <20220318093153.521634-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Mar 2022 17:31:53 +0800 you wrote:
> allocated_mem is allocated by kcalloc(). The memory is set to zero.
> It is unnecessary to call memset again.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - qed: remove unnecessary memset in qed_init_fw_funcs
    https://git.kernel.org/netdev/net-next/c/b8f7544a6cb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


