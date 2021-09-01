Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF563FD0B1
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241262AbhIAB3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:29:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234036AbhIAB3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:29:10 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18114ONl157942
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=38BN2w0e9C4a+4gjjarfj1ijMsXUVzlkglMpXXv8J/Y=;
 b=A+tHHlKnSHtDnxNJ0+qhUlqiWIOdhQIj8XZ/d3EdaEpeurgPxH9YaYAgRcU5KRrXJ7VG
 smYIh/1i1S/M0B4WSZeSdfznf1yiyEpCH4eE0vfix+yWWR+upbGIcR+eLgJKsIPrYmhV
 EkcFFpkvxS+rot+t//P04kQS+U3QQuM2Q8xGecAS3mirtZr/jKiYsr2W5hjJHb425L7p
 Pphg/m2RD+xrNw1ZDM8GObX5r5oQyF7eCAgu5EpSC6Jjze++dGOmrAt33QA/bscmGFHr
 XSJYE+RHgloOL2789c6FsHJUnl3RDSoauhQaNzkcqY7KnP//Gt7fD0LDP4aM3q1SU95t lQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asy3t8wck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:28:14 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811Reau009831
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:28:13 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 3aqcscbd0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:28:13 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811SCE934079000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:28:12 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 376FC136088;
        Wed,  1 Sep 2021 01:28:12 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFED413608A;
        Wed,  1 Sep 2021 01:28:11 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:28:11 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:28:11 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 2/9] ibmvnic: Fix up some comments and messages
In-Reply-To: <20210901000812.120968-3-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-3-sukadev@linux.ibm.com>
Message-ID: <ef067dcb0cf71def84658c3e405c7fb2@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XV7kbgyndI_jGojyjeOVplOG4mCJoEQZ
X-Proofpoint-ORIG-GUID: XV7kbgyndI_jGojyjeOVplOG4mCJoEQZ
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
> Add/update some comments/function headers and fix up some messages.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 40 +++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index e8b1231be485..911315b10731 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -243,14 +243,13 @@ static int alloc_long_term_buff(struct
> ibmvnic_adapter *adapter,
> 
>  	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
>  	if (rc) {
> -		dev_err(dev,
> -			"Long term map request aborted or timed out,rc = %d\n",
> +		dev_err(dev, "LTB map request aborted or timed out, rc = %d\n",
>  			rc);
>  		goto out;
>  	}
> 
>  	if (adapter->fw_done_rc) {
> -		dev_err(dev, "Couldn't map long term buffer,rc = %d\n",
> +		dev_err(dev, "Couldn't map LTB, rc = %d\n",
>  			adapter->fw_done_rc);
>  		rc = -1;
>  		goto out;
> @@ -281,7 +280,9 @@ static void free_long_term_buff(struct
> ibmvnic_adapter *adapter,
>  	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
>  	    adapter->reset_reason != VNIC_RESET_TIMEOUT)
>  		send_request_unmap(adapter, ltb->map_id);
> +
>  	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
> +
>  	ltb->buff = NULL;
>  	ltb->map_id = 0;
>  }
> @@ -574,6 +575,10 @@ static int reset_rx_pools(struct ibmvnic_adapter 
> *adapter)
>  	return 0;
>  }
> 
> +/**
> + * Release any rx_pools attached to @adapter.
> + * Safe to call this multiple times - even if no pools are attached.
> + */
>  static void release_rx_pools(struct ibmvnic_adapter *adapter)
>  {
>  	struct ibmvnic_rx_pool *rx_pool;
> @@ -628,6 +633,9 @@ static int init_rx_pools(struct net_device *netdev)
>  		return -1;
>  	}
> 
> +	/* Set num_active_rx_pools early. If we fail below after partial
> +	 * allocation, release_rx_pools() will know how many to look for.
> +	 */
>  	adapter->num_active_rx_pools = rxadd_subcrqs;
> 
>  	for (i = 0; i < rxadd_subcrqs; i++) {
> @@ -646,6 +654,7 @@ static int init_rx_pools(struct net_device *netdev)
>  		rx_pool->free_map = kcalloc(rx_pool->size, sizeof(int),
>  					    GFP_KERNEL);
>  		if (!rx_pool->free_map) {
> +			dev_err(dev, "Couldn't alloc free_map %d\n", i);
>  			release_rx_pools(adapter);
>  			return -1;
>  		}
> @@ -739,10 +748,17 @@ static void release_one_tx_pool(struct
> ibmvnic_adapter *adapter,
>  	free_long_term_buff(adapter, &tx_pool->long_term_buff);
>  }
> 
> +/**
> + * Release any tx and tso pools attached to @adapter.
> + * Safe to call this multiple times - even if no pools are attached.
> + */
>  static void release_tx_pools(struct ibmvnic_adapter *adapter)
>  {
>  	int i;
> 
> +	/* init_tx_pools() ensures that ->tx_pool and ->tso_pool are
> +	 * both NULL or both non-NULL. So we only need to check one.
> +	 */
>  	if (!adapter->tx_pool)
>  		return;
> 
> @@ -793,6 +809,7 @@ static int init_one_tx_pool(struct net_device 
> *netdev,
>  static int init_tx_pools(struct net_device *netdev)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
> +	struct device *dev = &adapter->vdev->dev;
>  	int tx_subcrqs;
>  	u64 buff_size;
>  	int i, rc;
> @@ -805,17 +822,27 @@ static int init_tx_pools(struct net_device 
> *netdev)
> 
>  	adapter->tso_pool = kcalloc(tx_subcrqs,
>  				    sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
> +	/* To simplify release_tx_pools() ensure that ->tx_pool and
> +	 * ->tso_pool are either both NULL or both non-NULL.
> +	 */
>  	if (!adapter->tso_pool) {
>  		kfree(adapter->tx_pool);
>  		adapter->tx_pool = NULL;
>  		return -1;
>  	}
> 
> +	/* Set num_active_tx_pools early. If we fail below after partial
> +	 * allocation, release_tx_pools() will know how many to look for.
> +	 */
>  	adapter->num_active_tx_pools = tx_subcrqs;
> 
>  	for (i = 0; i < tx_subcrqs; i++) {
>  		buff_size = adapter->req_mtu + VLAN_HLEN;
>  		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> +
> +		dev_dbg(dev, "Init tx pool %d [%llu, %llu]\n",
> +			i, adapter->req_tx_entries_per_subcrq, buff_size);
> +
>  		rc = init_one_tx_pool(netdev, &adapter->tx_pool[i],
>  				      adapter->req_tx_entries_per_subcrq,
>  				      buff_size);
> @@ -4774,9 +4801,10 @@ static void handle_query_map_rsp(union 
> ibmvnic_crq *crq,
>  		dev_err(dev, "Error %ld in QUERY_MAP_RSP\n", rc);
>  		return;
>  	}
> -	netdev_dbg(netdev, "page_size = %d\ntot_pages = %d\nfree_pages = 
> %d\n",
> -		   crq->query_map_rsp.page_size, crq->query_map_rsp.tot_pages,
> -		   crq->query_map_rsp.free_pages);
> +	netdev_dbg(netdev, "page_size = %d\ntot_pages = %u\nfree_pages = 
> %u\n",
> +		   crq->query_map_rsp.page_size,
> +		   __be32_to_cpu(crq->query_map_rsp.tot_pages),
> +		   __be32_to_cpu(crq->query_map_rsp.free_pages));
>  }
> 
>  static void handle_query_cap_rsp(union ibmvnic_crq *crq,
