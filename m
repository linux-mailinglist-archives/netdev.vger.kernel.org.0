Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023ED2969F0
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 08:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375439AbgJWGtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 02:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJWGtu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 02:49:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAD92192A;
        Fri, 23 Oct 2020 06:49:49 +0000 (UTC)
Date:   Fri, 23 Oct 2020 09:49:46 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Dave Ertman <david.m.ertman@intel.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Auxiliary bus implementation and SOF
 multi-client support
Message-ID: <20201023064946.GP2611066@unreal>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023003338.1285642-1-david.m.ertman@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 05:33:28PM -0700, Dave Ertman wrote:

<...>

> Dave Ertman (1):
>   Add auxiliary bus support

We are in merge window now and both netdev and RDMA are closed for
submissions. So I'll send my mlx5 conversion patches once -rc1 will
be tagged.

However, It is important that this "auxiliary bus" patch will be applied
to some topic branch based on Linus's -rcX. It will give us an ability
to pull this patch to RDMA, VDPA and netdev subsystems at the same time.

Thanks
