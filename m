Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B93354C4F
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243828AbhDFF1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:27:38 -0400
Received: from verein.lst.de ([213.95.11.211]:52963 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232874AbhDFF1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 01:27:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A35D168BEB; Tue,  6 Apr 2021 07:27:17 +0200 (CEST)
Date:   Tue, 6 Apr 2021 07:27:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 01/10] RDMA: Add access flags to
 ib_alloc_mr() and ib_mr_pool_init()
Message-ID: <20210406052717.GA4835@lst.de>
References: <20210405052404.213889-1-leon@kernel.org> <20210405052404.213889-2-leon@kernel.org> <c21edd64-396c-4c7c-86f8-79045321a528@acm.org> <YGvwUI022t/rJy5U@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGvwUI022t/rJy5U@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 08:23:28AM +0300, Leon Romanovsky wrote:
> The same proposal (enable unconditionally) was raised during
> submission preparations and we decided to follow same pattern
> as other verbs objects which receive flag parameter.

A flags argument can be added when it actually is needed.  Using it
to pass an argument enabled by all ULPs just gets us back to the bad
old days of complete crap APIs someone drew up on a whiteboard.

I think we need to:

 a) document the semantics
 b) sort out any technical concerns
 c) just enable the damn thing

instead of requiring some form of cargo culting.
