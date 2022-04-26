Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC10D510079
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351648AbiDZOd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347725AbiDZOdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:33:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B445B1FB;
        Tue, 26 Apr 2022 07:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA8D3617DC;
        Tue, 26 Apr 2022 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13099C385A0;
        Tue, 26 Apr 2022 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650983411;
        bh=GNcN/jyeE9NiTFS1SUEN8XeFzc9vMkpHhCJF0pyir+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b3vpnfpnxat9CLKjCCv814f8wRcWNX4k9H1ZQVHtsnXJ53+K+TyvSKZd+hsPEPE3Z
         F70TKFfrj/hLrwszLCjfpkdDs+9KM4OPGB1hwB5Z9srplgVr0YgeRYXIXXVQ1xVZYA
         BXzmQ0d0CbapT8vlw19sMyjaLKb6MdAhpJ4VqW1TcnxVcjioJqyQvKWCrMGJ/XfTcJ
         BQq63fGNFMBF/+5WM8rtB17zohdLwuoirdFnKNrvfRyxbSr22JFzAyXygztjHBOpf+
         brewBjiZM9BCiEc6voKMreZe9ftvs2RTQjji/pnJNCMl3Papp64x8RZTsVxfhHMMPc
         B0JtcqhiwSnyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAB52EAC09C;
        Tue, 26 Apr 2022 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix possible crash when multiple sockets are created
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165098341095.2656.1366801711625380296.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 14:30:10 +0000
References: <20220425153745.481322-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220425153745.481322-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andriin@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 25 Apr 2022 17:37:45 +0200 you wrote:
> Fix a crash that happens if an Rx only socket is created first, then a
> second socket is created that is Tx only and bound to the same umem as
> the first socket and also the same netdev and queue_id together with the
> XDP_SHARED_UMEM flag. In this specific case, the tx_descs array page
> pool was not created by the first socket as it was an Rx only socket.
> When the second socket is bound it needs this tx_descs array of this
> shared page pool as it has a Tx component, but unfortunately it was
> never allocated, leading to a crash. Note that this array is only used
> for zero-copy drivers using the batched Tx APIs, currently only ice and
> i40e.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix possible crash when multiple sockets are created
    https://git.kernel.org/bpf/bpf/c/ba3beec2ec1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


