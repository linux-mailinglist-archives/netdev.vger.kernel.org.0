Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328302A9E0A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgKFTak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:30:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727982AbgKFTak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 14:30:40 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6J1vNb122917;
        Fri, 6 Nov 2020 14:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=jt6X2RJVnP0o8hPUGlEpvQo516h720Q+2neYw5Cy7TY=;
 b=UHzl82VgzamNPgv4qiYhqk+bLTtEmKD7OGidVJpu5/MI5oxor75aRIoCb3+xqnfcaxWO
 mZyuvT2Qf8pdNZPxSvL9cyoCrCpapO0FsSXkGSSwz9Jp/vRLxlgBNdotGwmGB9P9wZBr
 4HcRF6Xl0OdQRLR9z0jGdBFx49tWivpceXWuR1JudFxXsx1Mso4DJmRJsBAae3gesMT3
 fXQYIZPPniA4rgyEL27a2WVzPGf4P4bBKVanDimiuymp+bBFiSCXRH2adtlaGdX+qKIF
 hAZSIy/WMmL3DjkPHw5oCgZV0314WFLfaOSkqy1UTiP2jdEmOq45vMODgvEXl4rWxZqa ww== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34mnucqu23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 14:30:28 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6JBuID003580;
        Fri, 6 Nov 2020 19:30:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 34h02ms2rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 19:30:27 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6JUKnG54002080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 19:30:20 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19BE7BE053;
        Fri,  6 Nov 2020 19:30:26 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5325BE051;
        Fri,  6 Nov 2020 19:30:25 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 19:30:25 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 06 Nov 2020 13:30:25 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>, wvoigt@us.ibm.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+ljp=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH net-next] Revert ibmvnic merge do_change_param_reset into
 do_reset
In-Reply-To: <20201106191745.1679846-1-drt@linux.ibm.com>
References: <20201106191745.1679846-1-drt@linux.ibm.com>
Message-ID: <0ff353cbada91b031d1bbae250a975d5@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011060132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-06 13:17, Dany Madden wrote:
> This reverts commit 16b5f5ce351f8709a6b518cc3cbf240c378305bf
> where it restructures do_reset. There are patches being tested that
> would require major rework if this is committed first.
> 
> We will resend this after the other patches have been applied.

I discussed with my manager, and he has agreed not revert this one
since it is in the net-next tree and will not affect net tree for
current bug fix patches.

Sorry for the confusion.

Thanks,
Lijun

> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 147 ++++++++++++++++++++---------
>  1 file changed, 104 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index f4167de30461..af4dfbe28d56 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1826,6 +1826,86 @@ static int ibmvnic_set_mac(struct net_device
> *netdev, void *p)
>  	return rc;
>  }
> 
> +/**
> + * do_change_param_reset returns zero if we are able to keep 
> processing reset
> + * events, or non-zero if we hit a fatal error and must halt.
> + */
> +static int do_change_param_reset(struct ibmvnic_adapter *adapter,
> +				 struct ibmvnic_rwi *rwi,
> +				 u32 reset_state)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +	int i, rc;
> +
> +	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
> +		   rwi->reset_reason);
> +
> +	netif_carrier_off(netdev);
> +	adapter->reset_reason = rwi->reset_reason;
> +
> +	ibmvnic_cleanup(netdev);
> +
> +	if (reset_state == VNIC_OPEN) {
> +		rc = __ibmvnic_close(netdev);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	release_resources(adapter);
> +	release_sub_crqs(adapter, 1);
> +	release_crq_queue(adapter);
> +
> +	adapter->state = VNIC_PROBED;
> +
> +	rc = init_crq_queue(adapter);
> +
> +	if (rc) {
> +		netdev_err(adapter->netdev,
> +			   "Couldn't initialize crq. rc=%d\n", rc);
> +		return rc;
> +	}
> +
> +	rc = ibmvnic_reset_init(adapter, true);
> +	if (rc)
> +		return IBMVNIC_INIT_FAILED;
> +
> +	/* If the adapter was in PROBE state prior to the reset,
> +	 * exit here.
> +	 */
> +	if (reset_state == VNIC_PROBED)
> +		return 0;
> +
> +	rc = ibmvnic_login(netdev);
> +	if (rc) {
> +		adapter->state = reset_state;
> +		return rc;
> +	}
> +
> +	rc = init_resources(adapter);
> +	if (rc)
> +		return rc;
> +
> +	ibmvnic_disable_irqs(adapter);
> +
> +	adapter->state = VNIC_CLOSED;
> +
> +	if (reset_state == VNIC_CLOSED)
> +		return 0;
> +
> +	rc = __ibmvnic_open(netdev);
> +	if (rc)
> +		return IBMVNIC_OPEN_FAILED;
> +
> +	/* refresh device's multicast list */
> +	ibmvnic_set_multi(netdev);
> +
> +	/* kick napi */
> +	for (i = 0; i < adapter->req_rx_queues; i++)
> +		napi_schedule(&adapter->napi[i]);
> +
> +	return 0;
> +}
> +
>  /**
>   * do_reset returns zero if we are able to keep processing reset 
> events, or
>   * non-zero if we hit a fatal error and must halt.
> @@ -1841,12 +1921,10 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
>  		   rwi->reset_reason);
> 
> -	adapter->reset_reason = rwi->reset_reason;
> -	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
> -	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
> -		rtnl_lock();
> +	rtnl_lock();
> 
>  	netif_carrier_off(netdev);
> +	adapter->reset_reason = rwi->reset_reason;
> 
>  	old_num_rx_queues = adapter->req_rx_queues;
>  	old_num_tx_queues = adapter->req_tx_queues;
> @@ -1858,37 +1936,25 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  	if (reset_state == VNIC_OPEN &&
>  	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
>  	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
> -		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
> -			rc = __ibmvnic_close(netdev);
> -			if (rc)
> -				goto out;
> -		} else {
> -			adapter->state = VNIC_CLOSING;
> -
> -			/* Release the RTNL lock before link state change and
> -			 * re-acquire after the link state change to allow
> -			 * linkwatch_event to grab the RTNL lock and run during
> -			 * a reset.
> -			 */
> -			rtnl_unlock();
> -			rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
> -			rtnl_lock();
> -			if (rc)
> -				goto out;
> +		adapter->state = VNIC_CLOSING;
> 
> -			if (adapter->state != VNIC_CLOSING) {
> -				rc = -1;
> -				goto out;
> -			}
> +		/* Release the RTNL lock before link state change and
> +		 * re-acquire after the link state change to allow
> +		 * linkwatch_event to grab the RTNL lock and run during
> +		 * a reset.
> +		 */
> +		rtnl_unlock();
> +		rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
> +		rtnl_lock();
> +		if (rc)
> +			goto out;
> 
> -			adapter->state = VNIC_CLOSED;
> +		if (adapter->state != VNIC_CLOSING) {
> +			rc = -1;
> +			goto out;
>  		}
> -	}
> 
> -	if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
> -		release_resources(adapter);
> -		release_sub_crqs(adapter, 1);
> -		release_crq_queue(adapter);
> +		adapter->state = VNIC_CLOSED;
>  	}
> 
>  	if (adapter->reset_reason != VNIC_RESET_NON_FATAL) {
> @@ -1897,9 +1963,7 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  		 */
>  		adapter->state = VNIC_PROBED;
> 
> -		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
> -			rc = init_crq_queue(adapter);
> -		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
> +		if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
>  			rc = ibmvnic_reenable_crq_queue(adapter);
>  			release_sub_crqs(adapter, 1);
>  		} else {
> @@ -1939,11 +2003,7 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  			goto out;
>  		}
> 
> -		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
> -			rc = init_resources(adapter);
> -			if (rc)
> -				goto out;
> -		} else if (adapter->req_rx_queues != old_num_rx_queues ||
> +		if (adapter->req_rx_queues != old_num_rx_queues ||
>  		    adapter->req_tx_queues != old_num_tx_queues ||
>  		    adapter->req_rx_add_entries_per_subcrq !=
>  		    old_num_rx_slots ||
> @@ -2004,9 +2064,7 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  	rc = 0;
> 
>  out:
> -	/* requestor of VNIC_RESET_CHANGE_PARAM should still hold the rtnl 
> lock */
> -	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
> -		rtnl_unlock();
> +	rtnl_unlock();
> 
>  	return rc;
>  }
> @@ -2140,7 +2198,10 @@ static void __ibmvnic_reset(struct work_struct 
> *work)
>  		}
>  		spin_unlock_irqrestore(&adapter->state_lock, flags);
> 
> -		if (adapter->force_reset_recovery) {
> +		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
> +			/* CHANGE_PARAM requestor holds rtnl_lock */
> +			rc = do_change_param_reset(adapter, rwi, reset_state);
> +		} else if (adapter->force_reset_recovery) {
>  			/* Transport event occurred during previous reset */
>  			if (adapter->wait_for_reset) {
>  				/* Previous was CHANGE_PARAM; caller locked */
