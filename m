Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C17496F41
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiAWAdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:33:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56148 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbiAWAdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:33:13 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20MNNwtY005397
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=ghnFrU5y2K7vlxGoiEIT27EEpgROEKWHShT/ryrAcpw=;
 b=iTeE4aKMnwBupwo+Zxv4YUcy5+pipHYNMhsA+lz0lxE0zLM6F95q+SpIg+Oxloo1s5S2
 5DTSgpigoVJfW6qBtJdrSqs3g9NFY2/kUv6ttkkJdwDJwQa/ggGprxWj2I5NKCpegWJQ
 P05E06Jn8fOu9mwiosG4r/6AC9w8ljNJ4R8hjMTbINIrfBl3rVduA8MpC1kq+DXaw5cb
 Ft6c0WV/JgHbhItbQI667WdMF9rDPRn0LjBphvXSOcQd1jolCLqXVqzbtQfqUUZTDZvo
 9X7eN17/cEr/3y3fbZiZiZkhUN4WFHrfwwaiEnDII5rOkWSRHKwqKctUb3i5jDl7gXwu aQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3drujh8mpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:33:12 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20N0WO6O010229
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:33:11 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3dr9j946g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:33:11 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20N0X9pE33882596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jan 2022 00:33:09 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC57B2065;
        Sun, 23 Jan 2022 00:33:09 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E52AB2066;
        Sun, 23 Jan 2022 00:33:09 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 23 Jan 2022 00:33:08 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 22 Jan 2022 16:33:08 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net 4/4] ibmvnic: remove unused ->wait_capability
In-Reply-To: <20220122025921.199446-4-sukadev@linux.ibm.com>
References: <20220122025921.199446-1-sukadev@linux.ibm.com>
 <20220122025921.199446-4-sukadev@linux.ibm.com>
Message-ID: <384d39bb4ca9a2a785ee83de94f0ccde@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eLbcLv2OnFMorusLFCwqotr_r71Ody3B
X-Proofpoint-ORIG-GUID: eLbcLv2OnFMorusLFCwqotr_r71Ody3B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201230001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-21 18:59, Sukadev Bhattiprolu wrote:
> With previous bug fix, ->wait_capability flag is no longer needed and 
> can
> be removed.
> 
> Fixes: 249168ad07cd ("ibmvnic: Make CRQ interrupt tasklet wait for all
> capabilities crqs")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 38 +++++++++++-------------------
>  drivers/net/ethernet/ibm/ibmvnic.h |  1 -
>  2 files changed, 14 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 682a440151a8..8ed0b95147db 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -4876,10 +4876,8 @@ static void handle_request_cap_rsp(union
> ibmvnic_crq *crq,
>  	}
> 
>  	/* Done receiving requested capabilities, query IP offload support */
> -	if (atomic_read(&adapter->running_cap_crqs) == 0) {
> -		adapter->wait_capability = false;
> +	if (atomic_read(&adapter->running_cap_crqs) == 0)
>  		send_query_ip_offload(adapter);
> -	}
>  }
> 
>  static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
> @@ -5177,10 +5175,8 @@ static void handle_query_cap_rsp(union 
> ibmvnic_crq *crq,
>  	}
> 
>  out:
> -	if (atomic_read(&adapter->running_cap_crqs) == 0) {
> -		adapter->wait_capability = false;
> +	if (atomic_read(&adapter->running_cap_crqs) == 0)
>  		send_request_cap(adapter, 0);
> -	}
>  }
> 
>  static int send_query_phys_parms(struct ibmvnic_adapter *adapter)
> @@ -5476,27 +5472,21 @@ static void ibmvnic_tasklet(struct 
> tasklet_struct *t)
>  	struct ibmvnic_crq_queue *queue = &adapter->crq;
>  	union ibmvnic_crq *crq;
>  	unsigned long flags;
> -	bool done = false;
> 
>  	spin_lock_irqsave(&queue->lock, flags);
> -	while (!done) {
> -		/* Pull all the valid messages off the CRQ */
> -		while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
> -			/* This barrier makes sure ibmvnic_next_crq()'s
> -			 * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
> -			 * before ibmvnic_handle_crq()'s
> -			 * switch(gen_crq->first) and switch(gen_crq->cmd).
> -			 */
> -			dma_rmb();
> -			ibmvnic_handle_crq(crq, adapter);
> -			crq->generic.first = 0;
> -		}
> +
> +	/* Pull all the valid messages off the CRQ */
> +	while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
> +		/* This barrier makes sure ibmvnic_next_crq()'s
> +		 * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
> +		 * before ibmvnic_handle_crq()'s
> +		 * switch(gen_crq->first) and switch(gen_crq->cmd).
> +		 */
> +		dma_rmb();
> +		ibmvnic_handle_crq(crq, adapter);
> +		crq->generic.first = 0;
>  	}
> -	/* if capabilities CRQ's were sent in this tasklet, the following
> -	 * tasklet must wait until all responses are received
> -	 */
> -	if (atomic_read(&adapter->running_cap_crqs) != 0)
> -		adapter->wait_capability = true;
> +
>  	spin_unlock_irqrestore(&queue->lock, flags);
>  }
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h
> b/drivers/net/ethernet/ibm/ibmvnic.h
> index b8e42f67d897..a80f94e161ad 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -921,7 +921,6 @@ struct ibmvnic_adapter {
>  	int login_rsp_buf_sz;
> 
>  	atomic_t running_cap_crqs;
> -	bool wait_capability;
> 
>  	struct ibmvnic_sub_crq_queue **tx_scrq ____cacheline_aligned;
>  	struct ibmvnic_sub_crq_queue **rx_scrq ____cacheline_aligned;
