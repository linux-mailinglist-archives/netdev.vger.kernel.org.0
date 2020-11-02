Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD72A351E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgKBUaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgKBUaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 15:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604349005;
        bh=HZnbHJR1h6GJ0Gcauc4KFGKuAHIgmjm2fkD8O/LDu8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NRItzGPKWIwaBa34+Egk7lPzzpSZRtCNtHkeYzo6nYJ8YqT9h9Gqwsz7Q4CLLhA30
         PjoF4hJEphYFNFXbYsG3JWrZX1pjC0yDqfkJJC3pI+RZ7ytpKHLxjPFFWc5g7Gma+n
         qu5qzVObCkW2MDcZiSfEBVLrHgURG/9q/Oq5gqLU=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: 9p: Fix kerneldoc warnings of missing
 parameters etc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160434900508.15792.6186344267999954521.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Nov 2020 20:30:05 +0000
References: <20201031182655.1082065-1-andrew@lunn.ch>
In-Reply-To: <20201031182655.1082065-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     asmadeus@codewreck.org, netdev@vger.kernel.org, ericvh@gmail.com,
        lucho@ionkov.net, v9fs-developer@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 31 Oct 2020 19:26:55 +0100 you wrote:
> net/9p/client.c:420: warning: Function parameter or member 'c' not described in 'p9_client_cb'
> net/9p/client.c:420: warning: Function parameter or member 'req' not described in 'p9_client_cb'
> net/9p/client.c:420: warning: Function parameter or member 'status' not described in 'p9_client_cb'
> net/9p/client.c:568: warning: Function parameter or member 'uidata' not described in 'p9_check_zc_errors'
> net/9p/trans_common.c:23: warning: Function parameter or member 'nr_pages' not described in 'p9_release_pages'
> net/9p/trans_common.c:23: warning: Function parameter or member 'pages' not described in 'p9_release_pages'
> net/9p/trans_fd.c:132: warning: Function parameter or member 'rreq' not described in 'p9_conn'
> net/9p/trans_fd.c:132: warning: Function parameter or member 'wreq' not described in 'p9_conn'
> net/9p/trans_fd.c:56: warning: Function parameter or member 'privport' not described in 'p9_fd_opts'
> net/9p/trans_rdma.c:113: warning: Function parameter or member 'cqe' not described in 'p9_rdma_context'
> net/9p/trans_rdma.c:129: warning: Function parameter or member 'privport' not described in 'p9_rdma_opts'
> net/9p/trans_virtio.c:215: warning: Function parameter or member 'limit' not described in 'pack_sg_list_p'
> net/9p/trans_virtio.c:83: warning: Function parameter or member 'chan_list' not described in 'virtio_chan'
> net/9p/trans_virtio.c:83: warning: Function parameter or member 'p9_max_pages' not described in 'virtio_chan'
> net/9p/trans_virtio.c:83: warning: Function parameter or member 'ring_bufs_avail' not described in 'virtio_chan'
> net/9p/trans_virtio.c:83: warning: Function parameter or member 'tag' not described in 'virtio_chan'
> net/9p/trans_virtio.c:83: warning: Function parameter or member 'vc_wq' not described in 'virtio_chan'
> 
> [...]

Here is the summary with links:
  - [net-next] net: 9p: Fix kerneldoc warnings of missing parameters etc
    https://git.kernel.org/netdev/net-next/c/760b3d61fb4e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


