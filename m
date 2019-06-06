Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767E7373A0
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfFFL5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:57:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:44822 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727290AbfFFL5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 07:57:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 62886AF3E;
        Thu,  6 Jun 2019 11:57:15 +0000 (UTC)
Date:   Thu, 6 Jun 2019 13:57:15 +0200
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
Subject: Re: [PATCH rdma-next 3/3] RDMA/mlx5: Enable decap and packet
 reformat on FDB
Message-ID: <20190606115714.GC30976@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-4-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606110609.11588-4-leon@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> From: Maor Gottlieb <maorg@mellanox.com>

> If FDB flow tables support decap operation, enable it on creation,
> This allows to perform decapsulation of tunnelled packets by steering
> rules. If FDB flow tables support reformat operation, enable it on
> creation as well.

> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
