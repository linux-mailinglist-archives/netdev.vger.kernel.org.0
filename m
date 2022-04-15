Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF76D502F35
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349163AbiDOTW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347427AbiDOTWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:22:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924DC46B06;
        Fri, 15 Apr 2022 12:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48DA6B82EEF;
        Fri, 15 Apr 2022 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7378C385A8;
        Fri, 15 Apr 2022 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650050413;
        bh=NNY0wYxE8F+6dtOfG1tS2dQ7TE7a5cryF2rfy9yenc0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XxunAenPVLR4Vjy3Xeioc0EEa/YtFSk4G9oOd1ldrIRTVrzNivIcjTt2p97FE6myr
         Td3cdGDyv5RQf9T6V6P8QBKJokUVKyZX0S7qzMHGmX235XqcvBwh0+zIxJBHm8Sn78
         bJfK70Czdxug5rWEN9LfmBaBszv+JvB19bTOiN5/V2J3Kx/Rk3gBFJsuCsqCVux8Wi
         VpMX5VbquhFX75b/jkIrmM+A19SPqsihVNHBIEmYvn+veNpziIwdbdtx45FKfNH8c3
         wtyG/fspvLttMhLO+CVqHVarsaFj8tfaMe1RWjj20hL949wc+Bv1jzlYeWvpjULjt8
         Ke4ncu6kfdUtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B02B9E8DD67;
        Fri, 15 Apr 2022 19:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full XSK RQ
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005041371.20714.5228687866085513373.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 19:20:13 +0000
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org
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

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 13 Apr 2022 17:30:01 +0200 you wrote:
> v2:
> - add likely for internal redirect return codes in ice and ixgbe
>   (Jesper)
> - do not drop the buffer that head pointed to at full XSK RQ (Maxim)
> - terminate Rx loop only when need_wakeup feature is enabled (Maxim)
> - reword from 'stop softirq processing' to 'stop NAPI Rx processing'
> - s/ENXIO/EINVAL in mlx5 and stmmac's ndo_xsk_wakeup to keep it
>   consitent with Intel's drivers (Maxim)
> - include Jesper's Acks
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,01/14] xsk: improve xdp_do_redirect() error codes
    https://git.kernel.org/bpf/bpf-next/c/c6c1f11b691e
  - [v2,bpf-next,02/14] xsk: diversify return codes in xsk_rcv_check()
    https://git.kernel.org/bpf/bpf-next/c/2be4a677ccb2
  - [v2,bpf-next,03/14] ice: xsk: decorate ICE_XDP_REDIR with likely()
    https://git.kernel.org/bpf/bpf-next/c/0bd5ab511e30
  - [v2,bpf-next,04/14] ixgbe: xsk: decorate IXGBE_XDP_REDIR with likely()
    https://git.kernel.org/bpf/bpf-next/c/d090c885860f
  - [v2,bpf-next,05/14] ice: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
    https://git.kernel.org/bpf/bpf-next/c/50ae06648073
  - [v2,bpf-next,06/14] i40e: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
    https://git.kernel.org/bpf/bpf-next/c/b8aef650e549
  - [v2,bpf-next,07/14] ixgbe: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
    https://git.kernel.org/bpf/bpf-next/c/c7dd09fd4628
  - [v2,bpf-next,08/14] ice: xsk: diversify return values from xsk_wakeup call paths
    https://git.kernel.org/bpf/bpf-next/c/ed8a6bc60f9e
  - [v2,bpf-next,09/14] i40e: xsk: diversify return values from xsk_wakeup call paths
    https://git.kernel.org/bpf/bpf-next/c/ed7ae2d62217
  - [v2,bpf-next,10/14] ixgbe: xsk: diversify return values from xsk_wakeup call paths
    https://git.kernel.org/bpf/bpf-next/c/0f8bf018899e
  - [v2,bpf-next,11/14] mlx5: xsk: diversify return values from xsk_wakeup call paths
    https://git.kernel.org/bpf/bpf-next/c/7b7f2f273d87
  - [v2,bpf-next,12/14] stmmac: xsk: diversify return values from xsk_wakeup call paths
    https://git.kernel.org/bpf/bpf-next/c/a817ead4154d
  - [v2,bpf-next,13/14] ice: xsk: avoid refilling single Rx descriptors
    https://git.kernel.org/bpf/bpf-next/c/4efad196163f
  - [v2,bpf-next,14/14] xsk: drop ternary operator from xskq_cons_has_entries
    https://git.kernel.org/bpf/bpf-next/c/0fb53aabc5fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


