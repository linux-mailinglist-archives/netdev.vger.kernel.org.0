Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293762A1A9B
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 21:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgJaU6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 16:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgJaU6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 16:58:35 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3863AC0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 13:58:35 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id EE882C01B; Sat, 31 Oct 2020 21:58:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1604177908; bh=vj2X1YbCj1Q36UAWFOYJ2Kq980yJo+mtwsittCILE1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c41OV1LgaEtFHLqZcCI2xyzpMJ1NA4GsQOoNgZ0fuVEhyDaIKA3mvzzMp5DuOnJKY
         Y0+HWTT5kM9qUyYuRI/9yN+pAc4piKv/BCYmWdxt0gduKuQf/tYt52IevQBZOU9WRC
         xzpWw4LTkVsqQy4k/4ie/xDu1B/Lkz4phYyFMLOi3dRoW6ahFHwwnPvjZHvAWjJw7t
         16cUF8XWm7vSHspLJ1aMIM6ZOZx9ix+pNHU2Ec9doqen/e35348BDvoByAlckZAsk+
         V0zs23N4bI3sa/ED3pGuQQfS4jmaD4pMXlF9EMLTpNKXxOWP5GkuOwyNIBZk3igUKn
         2Sqtxyxs+mrtA==
Date:   Sat, 31 Oct 2020 21:58:13 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: 9p: Fix kerneldoc warnings of missing
 parameters etc
Message-ID: <20201031205813.GA624@nautica>
References: <20201031182655.1082065-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201031182655.1082065-1-andrew@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn wrote on Sat, Oct 31, 2020:
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
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Thanks, LGTM I'll take this for next cycle unless someone is grabbing
these
-- 
Dominique
