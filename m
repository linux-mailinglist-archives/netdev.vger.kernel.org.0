Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309DC39BD0
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 10:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfFHIZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 04:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFHIZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 04:25:49 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D8502146E;
        Sat,  8 Jun 2019 08:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559982348;
        bh=39+t8TrAB2j97NunFDcrRtKj6FncPeaFxaXdBLTQKsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aBIqopL/4hjdL5pPEokcUxpvYSVL0XvGW8B5IlW8rTfOk0bxnaKirA6RxZnTKY0zl
         UfezSZiL6XzVAfLDrY3UDluCSXQVolYxEXafF0/wgXYbzIiAU6eIBSUtZ3VdNisKU3
         jTTctsKzZIG/YXm773uj+VLIjir9M6BE+udznvvo=
Date:   Sat, 8 Jun 2019 11:25:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Message-ID: <20190608082538.GR5261@mtr-leonro.mtl.com>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-2-leon@kernel.org>
 <20190606115635.GA30976@dell5510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606115635.GA30976@dell5510>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 01:56:36PM +0200, Petr Vorel wrote:
> Hi,
>
> > From: Maor Gottlieb <maorg@mellanox.com>
>
> > Add API to get the current Eswitch encap mode.
> > It will be used in downstream patches to check if
> > flow table can be created with encap support or not.
>
> > Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Petr Vorel <pvorel@suse.cz>

Thanks Petr for review, I'll add your tags and resend.

>
> Kind regards,
> Petr
