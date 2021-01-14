Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA362F597C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbhANDku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbhANDks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3DD7523787;
        Thu, 14 Jan 2021 03:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610595608;
        bh=I9HtrzT8yUsJb3Vgg5/bbWYCYVGGCNfQYle9YqMNl9U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gZlISI04gYvjaWyQ3Y0NdHPir0rdMJIiRk1BHGkLcg+C+m5UDZy7Wk/7sCdHxyp7u
         WJCIC/ZcAkBgcJ4ZDpBlGpE4MHIoLVUmnOX4Ue7qv58E8/GXMfe4Tw1nJ5o3B1ZRzD
         fxYSciXPXrYlyM93Md2JnyKVThDcu0CHa3jzRK2sE5VBH/bIB1QQWMF/JwAD90zgYr
         sFmZVlkw6PL8N04WF1PKDKigsDdwL8rOUoKEUZvU/rdxNH+9oCRA8Mp2S+rAab4xqR
         gY1cXxBA+2HmP7DjwXViM6HrneW7puGICNHufc8pZe/gsMHXaknttpQkukKgw054Lq
         OGUaeycAvTM6g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2DE3F60105;
        Thu, 14 Jan 2021 03:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] i40e: fix potential NULL pointer dereferencing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059560818.8885.13113581154759603172.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:40:08 +0000
References: <20210111181138.49757-1-cristian.dumitrescu@intel.com>
In-Reply-To: <20210111181138.49757-1-cristian.dumitrescu@intel.com>
To:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 11 Jan 2021 18:11:38 +0000 you wrote:
> Currently, the function i40e_construct_skb_zc only frees the input xdp
> buffer when the output skb is successfully built. On error, the
> function i40e_clean_rx_irq_zc does not commit anything for the current
> packet descriptor and simply exits the packet descriptor processing
> loop, with the plan to restart the processing of this descriptor on
> the next invocation. Therefore, on error the ring next-to-clean
> pointer should not advance, the xdp i.e. *bi buffer should not be
> freed and the current buffer info should not be invalidated by setting
> *bi to NULL. Therefore, the *bi should only be set to NULL when the
> function i40e_construct_skb_zc is successful, otherwise a NULL *bi
> will be dereferenced when the work for the current descriptor is
> eventually restarted.
> 
> [...]

Here is the summary with links:
  - [net] i40e: fix potential NULL pointer dereferencing
    https://git.kernel.org/netdev/net/c/7128c834d30e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


