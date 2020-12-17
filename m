Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428322DD819
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbgLQSP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:15:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgLQSPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:15:23 -0500
Date:   Thu, 17 Dec 2020 10:14:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608228883;
        bh=F2kRqFoveZqLim73gyQlY/IVH+R3xawt0mEKQXT0R9o=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=SPedM0U9zkFeTHRf7UfTt+3J/eE0mx0Hywd3mxj2xfpuD02Naw3sTM3aQJE8vqOaF
         49ad044EzwspdsF1lw14AXUUa01LcODGu45mkWVuolfCgWR0YIYsDRGMRq5MFsErue
         AZFMp2L5lqR50ofnKKUXNeZBvxo80PdbLJo//elL+bvIK9p8KAEr8PA4fYBxoi3Irq
         TuiJMEPgmIkEdDOOc4AsyAGjGvzIDFlpXrwdQiVASTWjziaVUzTlUgUXWcTDnYLmpD
         nxn8FqrIjRBMbvJa4To+vVAj1vIFAxWieLe4ubkLLslzDkDmt2SHqd6q9XY5XATLBP
         3pkTPNLcIru5A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
Message-ID: <20201217101441.3d5085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215012907.3062-1-ivan@cloudflare.com>
References: <20201215012907.3062-1-ivan@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 17:29:06 -0800 Ivan Babrou wrote:
> Without this change the driver tries to allocate too many queues,
> breaching the number of available msi-x interrupts on machines
> with many logical cpus and default adapter settings:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> sfc 0000:86:00.0 ext0: XDP TX failed (-22)
> 
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>

Looks like the discussion may have concluded, but we don't take -next
patches during the merge window, so please repost when net-next reopens.

Thanks!
--
# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
