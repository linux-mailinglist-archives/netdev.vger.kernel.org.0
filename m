Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1BE6313D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfGIGw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:52:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:35916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbfGIGw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 02:52:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECAA5AC90;
        Tue,  9 Jul 2019 06:52:26 +0000 (UTC)
Date:   Tue, 9 Jul 2019 15:52:20 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 11/16] qlge: Remove qlge_bq.len & size
Message-ID: <20190709065220.GA990@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-11-bpoirier@suse.com>
 <DM6PR18MB2697E84A8DD54483832AD202ABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB2697E84A8DD54483832AD202ABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/27 10:47, Manish Chopra wrote:
> > 
> > -	for (i = 0; i < qdev->rx_ring_count; i++) {
> > +	for (i = 0; i < qdev->rss_ring_count; i++) {
> >  		struct rx_ring *rx_ring = &qdev->rx_ring[i];
> > 
> > -		if (rx_ring->lbq.queue)
> > -			ql_free_lbq_buffers(qdev, rx_ring);
> > -		if (rx_ring->sbq.queue)
> > -			ql_free_sbq_buffers(qdev, rx_ring);
> > +		ql_free_lbq_buffers(qdev, rx_ring);
> > +		ql_free_sbq_buffers(qdev, rx_ring);
> >  	}
> >  }
> > 
> 
> Seems irrelevant change as per what this patch is supposed to do exactly.

Sure, I've removed that hunk.
