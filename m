Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD9F1AE5DA
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgDQTe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728826AbgDQTe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 15:34:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47803206B9;
        Fri, 17 Apr 2020 19:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587152066;
        bh=cgTuU2wq4VHHMob0ArleEq1p95SpnlUXFK7duK8u4Hs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zqVxr4ILCmq1pKp/UpPNhgwbYVAPoEpxsmbVcRTYk/Hl+5lWEBWcQHdDlnFwyWZE6
         zDz2yZ9knh0CRBlxgJ1N4T7bkwypzAHLo9DwTT2ja4CY1OPElA4g7H7DXF8mkPm1k0
         rLzih/cyKZr67zoOV826m1xwqqrxIOAmysu+rfJQ=
Date:   Fri, 17 Apr 2020 22:34:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     gregkh@linuxfoundation.org, jgg@ziepe.ca,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200417193421.GB3083@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Register irdma as a virtbus driver capable of supporting virtbus
> devices from multi-generation RDMA capable Intel HW. Establish the
> interface with all supported netdev peer drivers and initialize HW.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
>  drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
>  drivers/infiniband/hw/irdma/main.c     | 573 +++++++++++++++++++++++
>  drivers/infiniband/hw/irdma/main.h     | 599 +++++++++++++++++++++++++
>  4 files changed, 1849 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
>  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
>  create mode 100644 drivers/infiniband/hw/irdma/main.c
>  create mode 100644 drivers/infiniband/hw/irdma/main.h
>

I didn't look in too much details, but three things caught my
attention immediately:
1. Existence of ARP cache management logic in RDMA driver.
2. Extensive use of dev_*() prints while we have ibdev_*() prints
3. Extra includes (moduleparam.h ???).

Thanks
