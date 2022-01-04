Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E98483D51
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiADH5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:57:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233771AbiADH5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:57:09 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2044DWXC008837;
        Tue, 4 Jan 2022 07:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=E+3Lggbi73BJUF7sAts8cCdKAnFCwgo26V0dOyoHqr4=;
 b=o8ISA6tRe4M80xu7k8awnxCreULpZoQ6P27ch518Ldi742W7a5w00vsSkmT9KwvUSDgu
 6hBsGXsXyBDXJvbiARdILyD1v/ulipuJ6xFy7A6LKMyg+dx2tdShZcxQ0JEQKhzdt0Zm
 P2eMb0xr5DkdxU1J4MMGxh6qiRv+/4WkuXhekSgrqH5xMt27pAx2j3XSosblbsaD+tPM
 GefmlpeYUI5lhSBjWO+dZYrishomgykfFM/GbB/VAKypfJFNjH7ib5bNYpJfLnh4BPcM
 EGnLBrwZSBKj0aimziO2U0fxDNxPI1bCX4alg6fBDI02thhUmuDTZ14St4AzgvakaqPb LA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dcf1831vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 07:56:51 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2047sYJs021543;
        Tue, 4 Jan 2022 07:56:51 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 3daeka5xaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 07:56:50 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2047uoaX30998800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jan 2022 07:56:50 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20DEA6A05D;
        Tue,  4 Jan 2022 07:56:50 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDA436A04D;
        Tue,  4 Jan 2022 07:56:44 +0000 (GMT)
Received: from [9.43.78.252] (unknown [9.43.78.252])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jan 2022 07:56:44 +0000 (GMT)
Message-ID: <984e801f-494b-c84c-8efe-2d205af9bd7a@linux.vnet.ibm.com>
Date:   Tue, 4 Jan 2022 13:24:07 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] net: fixup build after bpf header changes
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, saeedm@nvidia.com, leon@kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, sachinp <sachinp@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
References: <20220104034827.1564167-1-kuba@kernel.org>
From:   Abdul Haleem <abdhalee@linux.vnet.ibm.com>
In-Reply-To: <20220104034827.1564167-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qK3BMOAQyXfi_WpBA8KFUOtwlAmpIBwJ
X-Proofpoint-ORIG-GUID: qK3BMOAQyXfi_WpBA8KFUOtwlAmpIBwJ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_04,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 clxscore=1011 spamscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201040049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Thank You Jakub for the patch.

Kernel builds fine with given patch fix

Tested-by : Abdul haleem <abdhalee@linux.vnet.ibm.com>

On 1/4/22 9:18 AM, Jakub Kicinski wrote:

> Recent bpf-next merge brought in header changes which uncovered
> includes missing in net-next which were not present in bpf-next.
> Build problems happen only on less-popular arches like hppa,
> sparc, alpha etc.
>
> I could repro the build problem with ice but not the mlx5 problem
> Abdul was reporting. mlx5 does look like it should include filter.h,
> anyway.
>
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Fixes: e63a02348958 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next")
> Link: https://lore.kernel.org/all/7c03768d-d948-c935-a7ab-b1f963ac7eed@linux.vnet.ibm.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: saeedm@nvidia.com
> CC: leon@kernel.org
> CC: intel-wired-lan@lists.osuosl.org
> CC: linux-rdma@vger.kernel.org
> CC: bpf@vger.kernel.org
> ---
>   drivers/net/ethernet/intel/ice/ice_nvm.c          | 2 ++
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
>   2 files changed, 3 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
> index cd739a2c64e8..4eb0599714f4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
> @@ -1,6 +1,8 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /* Copyright (c) 2018, Intel Corporation. */
>
> +#include <linux/vmalloc.h>
> +
>   #include "ice_common.h"
>
>   /**
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index efcf9d30b131..31c911182498 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -37,6 +37,7 @@
>   #include <net/geneve.h>
>   #include <linux/bpf.h>
>   #include <linux/if_bridge.h>
> +#include <linux/filter.h>
>   #include <net/page_pool.h>
>   #include <net/xdp_sock_drv.h>
>   #include "eswitch.h"

-- 
Regard's

Abdul Haleem
IBM Linux Technology Center

