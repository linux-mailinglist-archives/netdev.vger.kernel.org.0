Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546D42C6CD5
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgK0VLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729845AbgK0VKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 16:10:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606511405;
        bh=YkYz8HQ2tvvTCXYwt+RjoeyZGuvezlwD1uZUuHlU4bw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=axwcVW14fz89dbnZI0dPPS+mbx1Q1rs5kmdWJ2/++w0DqQqJ6EKDPHECqIVh3ZZD2
         ngEhpnvn6bz1ClRouHYTqtiDsv1oL6Y9dHMfWxRGX1UVm/0LzBvIKi1rwJA3Ls/npR
         o6NCS0ubLlD37fFsEsF5hGOpP96VkDySYXDpC3ik=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: replace size_t with __u32 in xsk interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160651140575.29562.16768492884588898558.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Nov 2020 21:10:05 +0000
References: <1606383455-8243-1-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1606383455-8243-1-git-send-email-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 26 Nov 2020 10:37:35 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Replace size_t with __u32 in the xsk interfaces that contain
> this. There is no reason to have size_t since the internal variable
> that is manipulated is a __u32. The following APIs are affected:
> 
> __u32 xsk_ring_prod__reserve(struct xsk_ring_prod *prod, __u32 nb,
>                              __u32 *idx)
> void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
> __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
> void xsk_ring_cons__cancel(struct xsk_ring_cons *cons, __u32 nb)
> void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
> 
> [...]

Here is the summary with links:
  - [bpf-next] libbpf: replace size_t with __u32 in xsk interfaces
    https://git.kernel.org/bpf/bpf-next/c/105c4e75feb4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


