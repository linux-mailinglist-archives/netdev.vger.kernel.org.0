Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3CF1DAC8D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgETHtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:49:23 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:41284 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETHtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589960963; x=1621496963;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=rTYTPJVkVmrz3UNzCa73++gwpoLBVccJrDkW+WcLEaI=;
  b=a1Xu2MFv1D0x3yRg0cQrE+g8eWoCjowMbATUNtjbc8VEPOuhj3k2akYI
   X6BnFSbv0deKiqjXRN81ws391+xnQkE61Q6pmqCvoUcf0Tr2Tt+zdX0n9
   ZcyR4C+6lHiTGiUpb46lf0+4k1YUdstGuAYxzE+y95q8gwcOlkAeqTsms
   w=;
IronPort-SDR: 6LnKk3NjUM1ekH881SPxcvPgnhf5/G6vLhn4YWpJmxetWRe595OAIxwhwBWU85Vx7wWXjP2J2k
 MU3RkWplf/Gg==
X-IronPort-AV: E=Sophos;i="5.73,413,1583193600"; 
   d="scan'208";a="46037374"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 20 May 2020 07:49:20 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 323F5A20C3;
        Wed, 20 May 2020 07:49:19 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 20 May 2020 07:49:18 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.175) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 20 May 2020 07:49:12 +0000
Subject: Re: [RDMA RFC v6 16/16] RDMA/irdma: Update MAINTAINERS file
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, <dledford@redhat.com>,
        <jgg@mellanox.com>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>
CC:     Shiraz Saleem <shiraz.saleem@intel.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <nhorman@redhat.com>, <sassmann@redhat.com>, <poswald@suse.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-17-jeffrey.t.kirsher@intel.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <7a82fb8b-b16e-3b40-1d30-d9f52d0ff496@amazon.com>
Date:   Wed, 20 May 2020 10:49:07 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520070415.3392210-17-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2020 10:04, Jeff Kirsher wrote:
> From: Shiraz Saleem <shiraz.saleem@intel.com>
> 
> Add maintainer entry for irdma driver.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 598d0e1b3501..8b8e3e0064cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8745,6 +8745,14 @@ L:	linux-pm@vger.kernel.org
>  S:	Supported
>  F:	drivers/cpufreq/intel_pstate.c
>  
> +INTEL ETHERNET PROTOCL DRIVER FOR RDMA
> +M:	Mustafa Ismail <mustafa.ismail@intel.com>
> +M:	Shiraz Saleem <shiraz.saleem@intel.com>
> +L:	linux-rdma@vger.kernel.org
> +S:	Supported
> +F:	drivers/infiniband/hw/irdma/
> +F:	include/uapi/rdma/irdma-abi.h

This list should be sorted alphabetically.

>  INTEL SPEED SELECT TECHNOLOGY
>  M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>  L:	platform-driver-x86@vger.kernel.org
> 

