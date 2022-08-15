Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D0C59320B
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiHOPgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiHOPgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:36:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81ED13D15;
        Mon, 15 Aug 2022 08:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D481B80F9A;
        Mon, 15 Aug 2022 15:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35EB8C43141;
        Mon, 15 Aug 2022 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660577768;
        bh=BvsXrlD8cqSnCiqqDisl1fNM3OI/UKJOP2OGD7T4SdU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bXs0EQ8lJIETG4mBw7A4skLUSXaqZR199ZQ66f6krLqSHLqiJ+JNenBTncuRrVVFz
         Kh9KXasPpgFVA+jkFm75PvtcBbDe3NqNo944uY7QpPBiTATOCtUSl4N1dlSlzCXgW8
         YTHDu+l3FyhsVB11KKbUh/1x1odE9J2VybLMOTQu0p0aeSWyAqyokw1DbhnKNEdTFq
         xxXm89cZEAyscE2VZk39A/3aJiACyfK0qp5tCfkArkvu5A5LaafByjZNvjgEWVQ575
         hPCgfScXzowxF+2qcGsutMjvVHxAcRNaZZ4aSO0cpumRcV0Kd+xsR7HwvMYyQFmmOM
         /HxWI1z7V9YbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C18BE2A050;
        Mon, 15 Aug 2022 15:36:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix corrupted packets for XDP_SHARED_UMEM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166057776811.2541.7242231014016155643.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 15:36:08 +0000
References: <20220812113259.531-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220812113259.531-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, alasdair.mcwilliam@outlook.com,
        dnevil@intrusion.com
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

On Fri, 12 Aug 2022 13:32:59 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix an issue in XDP_SHARED_UMEM mode together with aligned mode were
> packets are corrupted for the second and any further sockets bound to
> the same umem. In other words, this does not affect the first socket
> bound to the umem. The culprit for this bug is that the initialization
> of the DMA addresses for the pre-populated xsk buffer pool entries was
> not performed for any socket but the first one bound to the umem. Only
> the linear array of DMA addresses was populated. Fix this by
> populating the DMA addresses in the xsk buffer pool for every socket
> bound to the same umem.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix corrupted packets for XDP_SHARED_UMEM
    https://git.kernel.org/bpf/bpf/c/58ca14ed98c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


