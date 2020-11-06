Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12D12A9E89
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgKFUTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:19:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbgKFUTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:19:18 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6KDO5N027486;
        Fri, 6 Nov 2020 15:19:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=WwnHOnhR4BNXQcvGcBOUdFI8x/pDhmf+waIn+LTZu0k=;
 b=VhbgRF3B2tfvOSXrEsW90cN8W0NjdTUP7UdnSGzkfvN1iBYAjq1VLDJ18jJIjffuw2uK
 MfyTfHLAJFqxvvwXO1BdMdssYI3iuHUH5iZ7kOLzhjkmXiuzwzJ1VCd9/+3RKTCP235d
 Hw+Xz6vdFkPYBPRb87Ln+FYC9N/3ERfQN5LRLT75Yqrz0rFO6fB0FZWFZTt3+O9TkNjo
 v8H7t4Ir21YuWyDYwYOzkVSrFrDCd+dGfh8CcGR5QHeTdRv7RPK8wQgrq0Fv/LABSe8g
 CZkLfcTC66zLvtUy7uztaiXlO4ugOXaKwahDM8TqiTHQwOTi222MdQ9Qf1dNjsNpM+Cq Qw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34n6uanad2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 15:19:13 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6KHPFC007896;
        Fri, 6 Nov 2020 20:19:12 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 34h0fkjh8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 20:19:12 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6KJ5JM33620446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 20:19:05 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A26E86E04C;
        Fri,  6 Nov 2020 20:19:10 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 562406E050;
        Fri,  6 Nov 2020 20:19:10 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 20:19:10 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 06 Nov 2020 14:19:10 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Pan <ljp@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
In-Reply-To: <20201104114358.37e766a3@canb.auug.org.au>
References: <20201104114358.37e766a3@canb.auug.org.au>
Message-ID: <1a5f4fb788453dd8807bc5c225a9907f@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-03 18:43, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/net/ethernet/ibm/ibmvnic.c
> 
> between commit:
> 
>   1d8504937478 ("powerpc/vnic: Extend "failover pending" window")
> 
> from the net tree and commit:
> 
>   16b5f5ce351f ("ibmvnic: merge do_change_param_reset into do_reset")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your 
> tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any 
> particularly
> complex conflicts.
> 

Sorry I missed this email.
The fix is correct.
Thank you Stephen.

> --
> Cheers,
> Stephen Rothwell
> 
> diff --cc drivers/net/ethernet/ibm/ibmvnic.c
> index da15913879f8,f4167de30461..000000000000
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@@ -1930,17 -1841,12 +1850,20 @@@ static int do_reset(struct 
> ibmvnic_adap
>   	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
>   		   rwi->reset_reason);
> 
> - 	rtnl_lock();
> + 	adapter->reset_reason = rwi->reset_reason;
> + 	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
> + 	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
> + 		rtnl_lock();
> +
>  +	/*
>  +	 * Now that we have the rtnl lock, clear any pending failover.
>  +	 * This will ensure ibmvnic_open() has either completed or will
>  +	 * block until failover is complete.
>  +	 */
>  +	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
>  +		adapter->failover_pending = false;
>  +
>   	netif_carrier_off(netdev);
> - 	adapter->reset_reason = rwi->reset_reason;
> 
>   	old_num_rx_queues = adapter->req_rx_queues;
>   	old_num_tx_queues = adapter->req_tx_queues;
> @@@ -2214,17 -2140,7 +2157,14 @@@ static void __ibmvnic_reset(struct 
> work
>   		}
>   		spin_unlock_irqrestore(&adapter->state_lock, flags);
> 
> - 		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
> - 			/* CHANGE_PARAM requestor holds rtnl_lock */
> - 			rc = do_change_param_reset(adapter, rwi, reset_state);
> - 		} else if (adapter->force_reset_recovery) {
> + 		if (adapter->force_reset_recovery) {
>  +			/*
>  +			 * Since we are doing a hard reset now, clear the
>  +			 * failover_pending flag so we don't ignore any
>  +			 * future MOBILITY or other resets.
>  +			 */
>  +			adapter->failover_pending = false;
>  +
>   			/* Transport event occurred during previous reset */
>   			if (adapter->wait_for_reset) {
>   				/* Previous was CHANGE_PARAM; caller locked */
