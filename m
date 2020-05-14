Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497DE1D27BB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgENG1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:27:12 -0400
Received: from verein.lst.de ([213.95.11.211]:50219 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgENG1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 02:27:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 22C9868BEB; Thu, 14 May 2020 08:27:07 +0200 (CEST)
Date:   Thu, 14 May 2020 08:27:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Joe Perches <joe@perches.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: Re: remove kernel_setsockopt and kernel_getsockopt
Message-ID: <20200514062706.GB8564@lst.de>
References: <20200513062649.2100053-1-hch@lst.de> <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 10:38:59AM -0700, Joe Perches wrote:
> It might be useful to show overall object size change.
> 
> More EXPORT_SYMBOL uses increase object size a little.
> 
> And not sure it matters much except it reduces overall object
> size, but these patches remove (unnecessary) logging on error
> and that could be mentioned in the cover letter too.

The intent here is not to reduce code size.  The intent is to kill of
set_fs users so that we can eventually remove set_fs entirely.
