Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C9237398
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfFFL4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:56:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:44682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727290AbfFFL4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 07:56:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AEF96AF55;
        Thu,  6 Jun 2019 11:56:36 +0000 (UTC)
Date:   Thu, 6 Jun 2019 13:56:36 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Message-ID: <20190606115635.GA30976@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606110609.11588-2-leon@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> From: Maor Gottlieb <maorg@mellanox.com>

> Add API to get the current Eswitch encap mode.
> It will be used in downstream patches to check if
> flow table can be created with encap support or not.

> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
