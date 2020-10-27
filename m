Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578BB29A631
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 09:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508692AbgJ0IG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 04:06:56 -0400
Received: from verein.lst.de ([213.95.11.211]:37735 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508718AbgJ0IEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 04:04:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A078268AFE; Tue, 27 Oct 2020 09:04:29 +0100 (CET)
Date:   Tue, 27 Oct 2020 09:04:29 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH] RDMA: Add rdma_connect_locked()
Message-ID: <20201027080429.GA22725@lst.de>
References: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int rdma_connect_locked(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)

This adds an overly long line.

> +int rdma_connect_locked(struct rdma_cm_id *id, struct rdma_conn_param *conn_param);

Same here.

Otherwise looks good except for the nvme merge error pointed out by
Chao Leng.

Reviewed-by: Christoph Hellwig <hch@lst.de>
