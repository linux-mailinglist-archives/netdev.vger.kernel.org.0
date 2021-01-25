Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F3C30316A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 02:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbhAZBZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 20:25:22 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18561 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731432AbhAYTiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:38:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f1e070000>; Mon, 25 Jan 2021 11:37:43 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:37:40 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 19:37:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMR8j3/H8ATPHgIJ/QQ1nSFTdqw53TXMmjb3I0AuE9oyXPPxzpJaauBHUHHv/UxyiPan7RBX8s1FhAnDmXZ6ZCNvuEhnoTtoHlJmcV6saEjK7MZpIl+kNKjBP9TAhaRnB/V505QZ5SRgJM1O+eJX7Ihwe96p888scokqbWC+t/DaQzCrVe8RAG/8m+wEhV1J1z4hy9YtH9lwu7MLaIEMdz7pXERKtfrVeOUe6mIC6RQPbUL3zojV9pPJx57xyJqXxH/d2RRwFXhTXYi9Hin1pLlZmtW7BXEk2tPc8vJ5mMceeOAN103V4c9hFar2M+nOx4PR7kboTBP8e9xzwZuSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WA25YnpRm7sKptpQ72fngj747FrQSSYwJREv921Pro=;
 b=oOpAl2nITW3jtK4f1G0AWE7WqHgcVjaSiXOSjATUuOPIRZUDw9GhtSj7EwfLb4r2613mIwLxMfvlkmuo5XLb2ZRGWEAC2s/fYzXp1czoBChLygNH5V/5TfHea8+tECwqd9Q+TLrqmdjrQd0C7VoMHBnC6mxWlavGZxNCiZyai2GmIy7E0ifej83UvSUf276+wiGg0xiOtihAAUIj2H+akfqAvspULVTy7RzQPgRbxw6KN7r8kOHrQrrPLuDDQvXGXKPQN6VG+DjgRcfDn0vH0hDziNvZTf2CyWO4rMoSUDAIOQPVi+TmbeSxxknc0REjdPqYCn9WqSs5fk2SiaDvvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Mon, 25 Jan
 2021 19:37:38 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:37:38 +0000
Date:   Mon, 25 Jan 2021 15:37:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 18/22] RDMA/irdma: Add miscellaneous utility definitions
Message-ID: <20210125193737.GX4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-19-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-19-shiraz.saleem@intel.com>
X-ClientProxiedBy: BL1PR13CA0456.namprd13.prod.outlook.com
 (2603:10b6:208:2c4::11) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0456.namprd13.prod.outlook.com (2603:10b6:208:2c4::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6 via Frontend Transport; Mon, 25 Jan 2021 19:37:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l47g9-006iYu-Jo; Mon, 25 Jan 2021 15:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611603463; bh=6WA25YnpRm7sKptpQ72fngj747FrQSSYwJREv921Pro=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=qyKEfuCD9SPrqWVVmjsGOM9ZEJtPVWLl3Ja7sj115vIqdjYdX4VXuwiLIuVkGphQH
         34Ea+WwqpmUX62sKSmF+x8NVUpmMwk6zUmT5LCyfBMApSfnQBDAPjF7Dnrdqvzb9KT
         sgTI94BJ/90CkYW1dqtchwrcHkf6WLmgVu+AkDaD3x2f1MHcUNC8bEOLgOkRUsQV26
         SuBTfKVjiYkaVRE5T4iRLY4cTrrZYG5DQFX4m3Qch5ZksRVuOTehFQVUfwPuSFSaSn
         zYZCW3jQM86H+OMLQwDOtDIiygEYPi/bPUSoYpRBb2OX+Y3TnlaffC3SHo11wZ55rP
         xRHyl/T2I69dw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:23PM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Add miscellaneous utility functions and headers.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
>  drivers/infiniband/hw/irdma/osdep.h  |   99 ++
>  drivers/infiniband/hw/irdma/protos.h |  118 ++
>  drivers/infiniband/hw/irdma/status.h |   70 +
>  drivers/infiniband/hw/irdma/utils.c  | 2680 ++++++++++++++++++++++++++++++++++
>  4 files changed, 2967 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
>  create mode 100644 drivers/infiniband/hw/irdma/protos.h
>  create mode 100644 drivers/infiniband/hw/irdma/status.h
>  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> 
> diff --git a/drivers/infiniband/hw/irdma/osdep.h b/drivers/infiniband/hw/irdma/osdep.h
> new file mode 100644
> index 0000000..10e2e02
> +++ b/drivers/infiniband/hw/irdma/osdep.h

> @@ -0,0 +1,99 @@
> +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> +/* Copyright (c) 2015 - 2021 Intel Corporation */
> +#ifndef IRDMA_OSDEP_H
> +#define IRDMA_OSDEP_H
> +
> +#include <linux/pci.h>
> +#include <crypto/hash.h>
> +#include <rdma/ib_verbs.h>
> +
> +#define STATS_TIMER_DELAY	60000
> +
> +#define idev_to_dev(ptr) (&((ptr)->hw->pcidev->dev))
> +#define ihw_to_dev(hw)   (&(hw)->pcidev->dev)

Try to avoid defines like this, it looses the typing information of
the arguments. These should be static inline functions

Jason
