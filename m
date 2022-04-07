Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A69E4F89E8
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiDGVMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 17:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiDGVMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 17:12:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787661820C2;
        Thu,  7 Apr 2022 14:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E59CE61FA2;
        Thu,  7 Apr 2022 21:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D4C0C385A8;
        Thu,  7 Apr 2022 21:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649365812;
        bh=tqL0W9qksOVz0PZK0b/p4/Ep31RJjoJJUHx+UtERg10=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fNXarDi2Nt8Y+fHznBn4TTvkYONzN9aiSLpL1I0S6ih4ZsI8DUEOROA3TAEF642JC
         tGR1vUGl5UHBJ3x+gSb0He7Z7o93F88SJSB672tqA35f2UBl64zjHkBgHSo+FYzX/z
         frri6G2X8K/u9ODb+/S626LM5a3BFNr5CfGawTax1v9CofHpdqA2BtN9Ka6i+YCy4I
         mjh7J1VeaGhV0TUVB+x4/NpvmkERqGMifAK35KCCkZlGuSZerg8E+A1FrqmarKhvSV
         OD0+Ln4H4RlQbsjfFq/K+Rw2nXgNhG3QhygIqZ6QYtasKk2Cty/oe7yXY6gjQuTPHP
         EdeL2IpkQdPyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1AB1FE85B8C;
        Thu,  7 Apr 2022 21:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix l2fwd for copy mode + busy poll combo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164936581210.6878.17567459374327495155.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Apr 2022 21:10:12 +0000
References: <20220406155804.434493-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220406155804.434493-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, brouer@redhat.com, alexandr.lobakin@intel.com
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

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed,  6 Apr 2022 17:58:04 +0200 you wrote:
> While checking AF_XDP copy mode combined with busy poll, strange
> results were observed. rxdrop and txonly scenarios worked fine, but
> l2fwd broke immediately.
> 
> After a deeper look, it turned out that for l2fwd, Tx side was exiting
> early due to xsk_no_wakeup() returning true and in the end
> xsk_generic_xmit() was never called. Note that AF_XDP Tx in copy mode is
> syscall steered, so the current behavior is broken.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix l2fwd for copy mode + busy poll combo
    https://git.kernel.org/bpf/bpf/c/8de8b71b787f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


