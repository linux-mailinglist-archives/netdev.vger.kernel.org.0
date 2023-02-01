Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D210F687117
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjBAWkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBAWkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:40:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD26B9AA;
        Wed,  1 Feb 2023 14:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C6703CE2588;
        Wed,  1 Feb 2023 22:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7316C433D2;
        Wed,  1 Feb 2023 22:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675291219;
        bh=thR4MM+QmMHTRDBkyAUIHEjRBHS0bX0AjuWuC2nnyl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jKIbZb4skxraDD/NnYFRLFU/+BIZJuXZ6wtTTEvnUONG/gNRmSKEOM7ekn+rjTVsD
         PBeZZ19Jefw7iqt8paI2JLJX4sY51J0KyZwTAxHeRq2QWHP4NgEuJ2ECNHhFuXvnLn
         /C0YzVBnjseksMqwQRKnD8rThz5mysp/ScEe+WGDYjM6y/NziXHpF9RuheysaKND1x
         LoDe68pm5qwbVj2FlrL111f4rNNlBhDbNdkFX9zNsQ9NStXIF4kUhyBZEiEUb6s9hz
         V0B5vKpDfBZd/ptGrNKAdBiahw894kmukRhBCd96v5YX4IwSpTlbx1Mwv9v+Ma85Jh
         +KWRSJXrfYFjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C339E21EEC;
        Wed,  1 Feb 2023 22:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 00/13] ice: add XDP mbuf support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167529121963.1862.10552462490697454435.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 22:40:19 +0000
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, tirthendu.sarkar@intel.com,
        alexandr.lobakin@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 31 Jan 2023 21:44:53 +0100 you wrote:
> Hi there,
> 
> although this work started as an effort to add multi-buffer XDP support
> to ice driver, as usual it turned out that some other side stuff needed
> to be addressed, so let me give you an overview.
> 
> First patch adjusts legacy-rx in a way that it will be possible to refer
> to skb_shared_info being at the end of the buffer when gathering up
> frame fragments within xdp_buff.
> 
> [...]

Here is the summary with links:
  - [bpf-next,01/13] ice: prepare legacy-rx for upcoming XDP multi-buffer support
    https://git.kernel.org/bpf/bpf-next/c/c61bcebde72d
  - [bpf-next,02/13] ice: add xdp_buff to ice_rx_ring struct
    https://git.kernel.org/bpf/bpf-next/c/cb0473e0e9dc
  - [bpf-next,03/13] ice: store page count inside ice_rx_buf
    https://git.kernel.org/bpf/bpf-next/c/ac0753391195
  - [bpf-next,04/13] ice: pull out next_to_clean bump out of ice_put_rx_buf()
    https://git.kernel.org/bpf/bpf-next/c/d7956d81f150
  - [bpf-next,05/13] ice: inline eop check
    https://git.kernel.org/bpf/bpf-next/c/e44f4790a2ba
  - [bpf-next,06/13] ice: centrallize Rx buffer recycling
    https://git.kernel.org/bpf/bpf-next/c/1dc1a7e7f410
  - [bpf-next,07/13] ice: use ice_max_xdp_frame_size() in ice_xdp_setup_prog()
    https://git.kernel.org/bpf/bpf-next/c/60bc72b3c4e9
  - [bpf-next,08/13] ice: do not call ice_finalize_xdp_rx() unnecessarily
    https://git.kernel.org/bpf/bpf-next/c/9070fe3da0b1
  - [bpf-next,09/13] ice: use xdp->frame_sz instead of recalculating truesize
    https://git.kernel.org/bpf/bpf-next/c/8a11b334ec9b
  - [bpf-next,10/13] ice: add support for XDP multi-buffer on Rx side
    https://git.kernel.org/bpf/bpf-next/c/2fba7dc5157b
  - [bpf-next,11/13] ice: add support for XDP multi-buffer on Tx side
    https://git.kernel.org/bpf/bpf-next/c/3246a10752a7
  - [bpf-next,12/13] ice: remove next_{dd,rs} fields from ice_tx_ring
    https://git.kernel.org/bpf/bpf-next/c/f4db7b314dd5
  - [bpf-next,13/13] ice: xsk: do not convert to buff to frame for XDP_TX
    https://git.kernel.org/bpf/bpf-next/c/a24b4c6e9aab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


