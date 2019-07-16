Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306366A890
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 14:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbfGPMTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 08:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGPMTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 08:19:19 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C047C2173B;
        Tue, 16 Jul 2019 12:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563279558;
        bh=lrWk+JZhasTAk5BmCfEGcdc4Dspc4aW5y4VZiVwlzUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vl+yfag3DrI+u15Rab7NBOnvuqb0wquz/VuNzqDDKSGhy5R4ey0+50KGAx1WYQA+P
         ZX9C1M9jr5El6dg+GiKm8Z7wV6s7ThvByOUmbWTUZmFV6EEO07a1z8el3paTNK85e5
         nHbFk8uQTw0xoGAAlOhko250KmrkxXdTQFwf5p74=
Date:   Tue, 16 Jul 2019 15:19:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc 8/8] rdma: Document counter statistic
Message-ID: <20190716121915.GM10130@mtr-leonro.mtl.com>
References: <20190710072455.9125-1-leon@kernel.org>
 <20190710072455.9125-9-leon@kernel.org>
 <92db561d-e89c-0e09-ef2e-9eb9535d504f@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92db561d-e89c-0e09-ef2e-9eb9535d504f@amazon.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:19:26AM +0300, Gal Pressman wrote:
> On 10/07/2019 10:24, Leon Romanovsky wrote:
> > +.SH "EXAMPLES"
> > +.PP
> > +rdma statistic show
> > +.RS 4
> > +Shows the state of the default counter of all RDMA devices on the system.
> > +.RE
> > +.PP
> > +rdma statistic show link mlx5_2/1
> > +.RS 4
> > +Shows the state of the default counter of specified RDMA port
> > +.RE
> > +.PP
> > +rdma statistic qp show
> > +.RS 4
> > +Shows the state of all qp counters of all RDMA devices on the system.
> > +.RE
> > +.PP
> > +rdma statistic qp show link mlx5_2/1
> > +.RS 4
> > +Shows the state of all qp counters of specified RDMA port.
> > +.RE
> > +.PP
> > +rdma statistic qp show link mlx5_2 pid 30489
> > +.RS 4
> > +Shows the state of all qp counters of specified RDMA port and belonging to pid 30489
> > +.RE
> > +.PP
> > +rdma statistic qp mode
> > +.RS 4
> > +List current counter mode on all deivces
>
> "deivces" -> "devices".

Thanks,

Stephen,

Can you please fix this typo while you are applying the series?

Thanks
