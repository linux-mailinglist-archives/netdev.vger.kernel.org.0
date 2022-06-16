Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C0154D6F1
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 03:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348454AbiFPBUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 21:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244771AbiFPBUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 21:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE9C5712A;
        Wed, 15 Jun 2022 18:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81114B8226D;
        Thu, 16 Jun 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D76FC3411A;
        Thu, 16 Jun 2022 01:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655342413;
        bh=SdVecEtOD6facjq6QjGenYkU51hZeeV8mVhwtshg23c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DIf9XCULPnL8DQQrmovHTec4TpfZIblMvSvfwO8mwHz+qZvNODplSEf2MMlQ1mBC4
         HneMbsfI6WCO+zhEClFoWoPcuNPH5btEaCVyZFwEYCqZn0AaeIaxuCgkb2cDlyURCn
         EQpbMvcQK74yqLQJk3mDj46iPs4FTMS+zH5TQE1COH3hZeMijoZBD1iAq1eeHEzdDm
         OnELooZO6+vtO3WL0CfDhBFMXwo+kyO/8Z2gG8gRfoS96T3XTOpX5ukI7p58oFSwaG
         INmIomAG+PEHNyQRCgct/5gQK/lPkQhXMD4bkdaEJQD0BSXbpKF0bpDeeXeJSR0Lq4
         v84vXBlj19RyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5C69E7385E;
        Thu, 16 Jun 2022 01:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6,bpf-next] samples/bpf: check detach prog exist or not in
 xdp_fwd
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165534241293.492.17334475395893203264.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Jun 2022 01:20:12 +0000
References: <20220606005425.261967-1-shaozhengchao@huawei.com>
In-Reply-To: <20220606005425.261967-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        toke@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 6 Jun 2022 08:54:25 +0800 you wrote:
> Before detach the prog, we should check detach prog exist or not.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  samples/bpf/xdp_fwd_user.c | 55 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 49 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [v6,bpf-next] samples/bpf: check detach prog exist or not in xdp_fwd
    https://git.kernel.org/bpf/bpf-next/c/de5bb43826dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


