Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87921D2CDD
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgENKab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:30:31 -0400
Received: from verein.lst.de ([213.95.11.211]:51189 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgENKaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:30:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5131B68BEB; Thu, 14 May 2020 12:30:26 +0200 (CEST)
Date:   Thu, 14 May 2020 12:30:25 +0200
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
Subject: Re: [PATCH 20/33] ipv4: add ip_sock_set_recverr
Message-ID: <20200514103025.GB12680@lst.de>
References: <20200513062649.2100053-1-hch@lst.de> <20200513062649.2100053-21-hch@lst.de> <0ee5acfaca4cf32d4efad162046b858981a4dae3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ee5acfaca4cf32d4efad162046b858981a4dae3.camel@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 02:00:43PM -0700, Joe Perches wrote:
> On Wed, 2020-05-13 at 08:26 +0200, Christoph Hellwig wrote:
> > Add a helper to directly set the IP_RECVERR sockopt from kernel space
> > without going through a fake uaccess.
> 
> This seems used only with true as the second arg.
> Is there reason to have that argument at all?

Mostly to keep it symmetric with the sockopt.  I could probably remove
a few arguments in the series if we want to be strict.
