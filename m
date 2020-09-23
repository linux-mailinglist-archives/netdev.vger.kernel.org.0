Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D3275383
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgIWInI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:43:08 -0400
Received: from verein.lst.de ([213.95.11.211]:47725 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgIWInH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 04:43:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 813D367357; Wed, 23 Sep 2020 10:43:03 +0200 (CEST)
Date:   Wed, 23 Sep 2020 10:43:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7 1/6] net: introduce helper sendpage_ok() in
 include/linux/net.h
Message-ID: <20200923084303.GA21657@lst.de>
References: <20200818131227.37020-1-colyli@suse.de> <20200818131227.37020-2-colyli@suse.de> <20200818162404.GA27196@lst.de> <217ec0ec-3c5a-a8ed-27d9-c634f0b9a045@suse.de> <20200818194930.GA31966@lst.de> <04408ff6-f765-8f3e-ead9-aec55043e469@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04408ff6-f765-8f3e-ead9-aec55043e469@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 12:22:05PM +0800, Coly Li wrote:
> On 2020/8/19 03:49, Christoph Hellwig wrote:
> > On Wed, Aug 19, 2020 at 12:33:37AM +0800, Coly Li wrote:
> >> On 2020/8/19 00:24, Christoph Hellwig wrote:
> >>> I think we should go for something simple like this instead:
> >>
> >> This idea is fine to me. Should a warning message be through here? IMHO
> >> the driver still sends an improper page in, fix it in silence is too
> >> kind or over nice to the buggy driver(s).
> > 
> > I don't think a warning is a good idea.  An API that does the right
> > thing underneath and doesn't require boiler plate code in most callers
> > is the right API.
> > 
> 
> Then I don't have more comment.

So given the feedback from Dave I suspect we should actually resurrect
this series, sorry for the noise.  And in this case I think we do need
the warning in kernel_sendpage.
