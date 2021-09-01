Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87573FD0B6
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbhIAB3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:29:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241584AbhIAB3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:29:53 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18114Poe157974
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=OnLp87O15u5QT1RW5Y4b624VJ90ISTrVR36Ls/z6p6M=;
 b=ibTGAV+cqCSBrZ0RqOL5a79F+H95ULmegQtOYmnnQkPIuDMD6Kr+OeQ79n0zOSQWEwFl
 bcY5yhUInmgXwpjJAWjhuvxw8QxS9HMSGxTp0v6B9WgBR/r2ZO2Ees3gp5uZVNEeY9RD
 SqOAqkG2cG8HPziRJhr9ysgYoicZEuZmpAV3EQAVQ73bNXtfrvhJLJz6SDhXdlXTvTSH
 115NkCnJtS/Ql5QI/BMbeG+qjjloOuoMYtfCvMJO+RrVIl09sJC4Pcsw2vvQn1ntTVBX
 vwJTXTs2hgd33ICKkbzNpqPPT6GJDF/pPwNDn3+R0pck4VJz/hZIRldvN5AzHXULT8/R iw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asy3t8ws6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:28:56 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811Sho3019772
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:28:56 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 3aqcsd3g4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:28:56 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811SsFL32899530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:28:54 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53D5C6A04F;
        Wed,  1 Sep 2021 01:28:54 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEAAD6A058;
        Wed,  1 Sep 2021 01:28:53 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:28:53 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:28:53 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 3/9] ibmvnic: Use/rename local vars in
 init_rx_pools
In-Reply-To: <20210901000812.120968-4-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-4-sukadev@linux.ibm.com>
Message-ID: <14ea9cf78d64c41df252425ff04a947b@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wkQaKzsAont8zrqiFd0naO1RR6aYVLcX
X-Proofpoint-ORIG-GUID: wkQaKzsAont8zrqiFd0naO1RR6aYVLcX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> To make the code more readable, use/rename some local variables.
> Basically we have a set of pools, num_pools. Each pool has a set of
> buffers, pool_size and each buffer is of size buff_size.
> 
> pool_size is a bit ambiguous (whether size in bytes or buffers). Add
> a comment in the header file to make it explicit.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++--------
>  drivers/net/ethernet/ibm/ibmvnic.h |  2 +-
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 911315b10731..a611bd3f2539 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -618,14 +618,16 @@ static int init_rx_pools(struct net_device 
> *netdev)
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>  	struct device *dev = &adapter->vdev->dev;
>  	struct ibmvnic_rx_pool *rx_pool;
> -	int rxadd_subcrqs;
> +	u64 num_pools;
> +	u64 pool_size;		/* # of buffers in one pool */
>  	u64 buff_size;
>  	int i, j;
> 
> -	rxadd_subcrqs = adapter->num_active_rx_scrqs;
> +	num_pools = adapter->num_active_rx_scrqs;
> +	pool_size = adapter->req_rx_add_entries_per_subcrq;
>  	buff_size = adapter->cur_rx_buf_sz;
> 
> -	adapter->rx_pool = kcalloc(rxadd_subcrqs,
> +	adapter->rx_pool = kcalloc(num_pools,
>  				   sizeof(struct ibmvnic_rx_pool),
>  				   GFP_KERNEL);
>  	if (!adapter->rx_pool) {
> @@ -636,17 +638,16 @@ static int init_rx_pools(struct net_device 
> *netdev)
>  	/* Set num_active_rx_pools early. If we fail below after partial
>  	 * allocation, release_rx_pools() will know how many to look for.
>  	 */
> -	adapter->num_active_rx_pools = rxadd_subcrqs;
> +	adapter->num_active_rx_pools = num_pools;
> 
> -	for (i = 0; i < rxadd_subcrqs; i++) {
> +	for (i = 0; i < num_pools; i++) {
>  		rx_pool = &adapter->rx_pool[i];
> 
>  		netdev_dbg(adapter->netdev,
>  			   "Initializing rx_pool[%d], %lld buffs, %lld bytes each\n",
> -			   i, adapter->req_rx_add_entries_per_subcrq,
> -			   buff_size);
> +			   i, pool_size, buff_size);
> 
> -		rx_pool->size = adapter->req_rx_add_entries_per_subcrq;
> +		rx_pool->size = pool_size;
>  		rx_pool->index = i;
>  		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
>  		rx_pool->active = 1;
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h
> b/drivers/net/ethernet/ibm/ibmvnic.h
> index 22df602323bc..5652566818fb 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -827,7 +827,7 @@ struct ibmvnic_rx_buff {
> 
>  struct ibmvnic_rx_pool {
>  	struct ibmvnic_rx_buff *rx_buff;
> -	int size;
> +	int size;			/* # of buffers in the pool */
>  	int index;
>  	int buff_size;
>  	atomic_t available;
