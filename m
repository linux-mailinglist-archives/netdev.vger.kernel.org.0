Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176C92A1F4E
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 16:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgKAPyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 10:54:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57240 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgKAPyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 10:54:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZFgD-004enM-Tk; Sun, 01 Nov 2020 16:54:05 +0100
Date:   Sun, 1 Nov 2020 16:54:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: 9p: Fix kerneldoc warnings of missing
 parameters etc
Message-ID: <20201101155405.GA1109407@lunn.ch>
References: <20201031182655.1082065-1-andrew@lunn.ch>
 <20201031205813.GA624@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031205813.GA624@nautica>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 09:58:13PM +0100, Dominique Martinet wrote:
> Andrew Lunn wrote on Sat, Oct 31, 2020:
> > net/9p/client.c:420: warning: Function parameter or member 'c' not described in 'p9_client_cb'
> > net/9p/client.c:420: warning: Function parameter or member 'req' not described in 'p9_client_cb'
> > net/9p/client.c:420: warning: Function parameter or member 'status' not described in 'p9_client_cb'
> > net/9p/client.c:568: warning: Function parameter or member 'uidata' not described in 'p9_check_zc_errors'
> > net/9p/trans_common.c:23: warning: Function parameter or member 'nr_pages' not described in 'p9_release_pages'
> > net/9p/trans_common.c:23: warning: Function parameter or member 'pages' not described in 'p9_release_pages'
> > net/9p/trans_fd.c:132: warning: Function parameter or member 'rreq' not described in 'p9_conn'
> > net/9p/trans_fd.c:132: warning: Function parameter or member 'wreq' not described in 'p9_conn'
> > net/9p/trans_fd.c:56: warning: Function parameter or member 'privport' not described in 'p9_fd_opts'
> > net/9p/trans_rdma.c:113: warning: Function parameter or member 'cqe' not described in 'p9_rdma_context'
> > net/9p/trans_rdma.c:129: warning: Function parameter or member 'privport' not described in 'p9_rdma_opts'
> > net/9p/trans_virtio.c:215: warning: Function parameter or member 'limit' not described in 'pack_sg_list_p'
> > net/9p/trans_virtio.c:83: warning: Function parameter or member 'chan_list' not described in 'virtio_chan'
> > net/9p/trans_virtio.c:83: warning: Function parameter or member 'p9_max_pages' not described in 'virtio_chan'
> > net/9p/trans_virtio.c:83: warning: Function parameter or member 'ring_bufs_avail' not described in 'virtio_chan'
> > net/9p/trans_virtio.c:83: warning: Function parameter or member 'tag' not described in 'virtio_chan'
> > net/9p/trans_virtio.c:83: warning: Function parameter or member 'vc_wq' not described in 'virtio_chan'
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Thanks, LGTM I'll take this for next cycle unless someone is grabbing
> these

Hi Dominique

I hope to turn on W=1 by default soon in most of /net. That patch is
likely to go to net-next.

What route do your patches normally take to Linus? Do you send a pull
request to net-next? Or straight to Linus?

If this patch is not in net-next, i cannot enable it for 9p. So
either:

1) I leave 9p without W=1, and there is a risk it gains new warnings
   which nobody notices

2) I send the W=1 enablement for 9p to you, but it does nothing in
   your tree because you don't have the rest of the patches. Any new
   warnings will appear in next, assuming 9p is merged into next, i've
   not checked that.

3) I expect there to be a stable branch with the base patches needed
   for W=1 by default. You can pull that into your tree, along with a
   patch to actually enable it in 9p. You then get to know about new
   warnings.

4) Jakub takes this patch into net-next, and i can then enable W=1 in
   9p along with all the other sub-directories. We will get to know
   about new warnings in net-next, and next, but not in your tree.

   Andrew
