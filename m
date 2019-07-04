Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922325F3F9
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGDHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfGDHkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 03:40:25 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D91A2133F;
        Thu,  4 Jul 2019 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562226024;
        bh=cpEKmomI1qco2Y1+UNn5Q5duVRzevtRlz/bSZ6oJVWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pP8hR1LapyiJvVnAHqMn1tozUemvOAzKh0mJWYzZ5lZQnSP+vksyuKQlutYX5QgZy
         +Tu6xCVxnSs+UHhHu2oC9S82KqoSC9kcgYf8iT1+T94UWA0Zq6l0Qirk1TZzVtkNBg
         WMg2sDsRQt6Ac5FV+EKr9ErXYfq9cJrBBGAK7zOs=
Date:   Thu, 4 Jul 2019 10:40:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, jgg@mellanox.com, davem@davemloft.net,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        david.m.ertman@intel.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
Message-ID: <20190704074021.GH4727@mtr-leonro.mtl.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 07:12:57PM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Add ABI definitions for irdma.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  include/uapi/rdma/irdma-abi.h | 130 ++++++++++++++++++++++++++++++++++
>  1 file changed, 130 insertions(+)
>  create mode 100644 include/uapi/rdma/irdma-abi.h
>
> diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
> new file mode 100644
> index 000000000000..bdfbda4c829e
> --- /dev/null
> +++ b/include/uapi/rdma/irdma-abi.h
> @@ -0,0 +1,130 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> +/* Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
> + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> + */
> +
> +#ifndef IRDMA_ABI_H
> +#define IRDMA_ABI_H
> +
> +#include <linux/types.h>
> +
> +/* irdma must support legacy GEN_1 i40iw kernel
> + * and user-space whose last ABI ver is 5
> + */
> +#define IRDMA_ABI_VER 6

Can you please elaborate about it more?
There is no irdma code in RDMA yet, so it makes me wonder why new define
shouldn't start from 1.

Thanks
