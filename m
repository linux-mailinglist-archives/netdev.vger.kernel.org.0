Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116841DB613
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgETOSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:18:36 -0400
Received: from verein.lst.de ([213.95.11.211]:50062 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETOSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 10:18:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9508368C4E; Wed, 20 May 2020 16:18:30 +0200 (CEST)
Date:   Wed, 20 May 2020 16:18:30 +0200
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
Message-ID: <20200520141830.GA28867@lst.de>
References: <20200513062649.2100053-1-hch@lst.de> <20200513062649.2100053-21-hch@lst.de> <0ee5acfaca4cf32d4efad162046b858981a4dae3.camel@perches.com> <20200514103025.GB12680@lst.de> <9992a1fe768a0b1e9bb9470d2728ba25dbe042db.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9992a1fe768a0b1e9bb9470d2728ba25dbe042db.camel@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 04:51:26AM -0700, Joe Perches wrote:
> > Mostly to keep it symmetric with the sockopt.  I could probably remove
> > a few arguments in the series if we want to be strict.
> 
> My preference would use strict and add
> arguments only when necessary.

In a few cases that would create confusion as the arguments are rather
overloaded.  But for a lot of the cases where it doesn't and there isn't
really much use for other arguments I've done that now.
