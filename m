Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588E3CE878
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfJGP5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbfJGP5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 11:57:18 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B2142067B;
        Mon,  7 Oct 2019 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570463838;
        bh=0BpLEdWJdcI8c4BrPNiOWB3KtNgijzyJF8MPFyT7NBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ivvbeu5rWN6RD0z0thho71E9UQELpg0FVV5u54/qwN+kaVI3iTrkWz0LVn0hNjylm
         ETIMkPxb9XVqZlXZgwTa6w7lU+k1ycFuJgL6I6Y0KeMMMTbNTMckB6Q0ScTZPnmhEK
         5EBbsTK0GOqtf8INx84t+EwwW3izh7GczVsv2/SQ=
Date:   Mon, 7 Oct 2019 18:57:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007155714.GZ5855@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
 <20191007150041.GA3702@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007150041.GA3702@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 08:00:41AM -0700, Christoph Hellwig wrote:
> >   */
> > +
> >  static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
>
> Same like an empty line sneaked in here.  Except for that the whole
> series looks fine:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks
