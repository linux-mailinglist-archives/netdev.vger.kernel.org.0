Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CCD1D2CC3
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgENK30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:29:26 -0400
Received: from verein.lst.de ([213.95.11.211]:51170 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgENK3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:29:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 03CE368BEB; Thu, 14 May 2020 12:29:20 +0200 (CEST)
Date:   Thu, 14 May 2020 12:29:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Howells <dhowells@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 29/33] rxrpc_sock_set_min_security_level
Message-ID: <20200514102919.GA12680@lst.de>
References: <20200513062649.2100053-30-hch@lst.de> <20200513062649.2100053-1-hch@lst.de> <3123534.1589375587@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3123534.1589375587@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 02:13:07PM +0100, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > +int rxrpc_sock_set_min_security_level(struct sock *sk, unsigned int val);
> > +
> 
> Looks good - but you do need to add this to Documentation/networking/rxrpc.txt
> also, thanks.

That file doesn't exist, instead we now have a
cumentation/networking/rxrpc.rst in weird markup.  Where do you want this
to be added, and with what text?  Remember I don't really know what this
thing does, I just provide a shortcut.
