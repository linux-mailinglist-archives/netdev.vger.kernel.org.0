Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221E842600
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407855AbfFLMg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:36:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:49876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728606AbfFLMg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:36:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99743AF10;
        Wed, 12 Jun 2019 12:36:25 +0000 (UTC)
Date:   Wed, 12 Jun 2019 14:36:24 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
 encap mode
Message-ID: <20190612123624.GA25535@x230>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612122014.22359-2-leon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

> From: Leon Romanovsky <leonro@mellanox.com>

> Devlink has UAPI declaration for encap mode, so there is no
> need to be loose on the data get/set by drivers.

> Update call sites to use enum devlink_eswitch_encap_mode
> instead of plain u8.

> Suggested-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
