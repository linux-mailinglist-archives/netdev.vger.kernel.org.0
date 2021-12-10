Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E251F470675
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244256AbhLJQ50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:57:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55456 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233575AbhLJQ50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:57:26 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAGUGXt008382;
        Fri, 10 Dec 2021 16:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FDRe8FJTYvM+5uNdcLG67TE8gGkOVc0R0sMppHY3UJg=;
 b=g/TS9pUnfmlZ8QAgcn86airj7GK0ZW5vq7s8h1SXRsTyMZuwDMVzMSvVHPXUScSjnrMN
 DSq2c07BV+lA5fKH0PpPzvNpcsxXh2ssAmNAqOVnDVo1dXcRDkbdDXz2d6kOABgGvjMZ
 bxUr9AxU/k3041iul0DFVmLfHGFnRZbNBfiS3sokIag5tZVvDAM2O2JTaJnlD29Kscfo
 TD2Xxb6hpdl7z6q+Z3gInyN5ds95704oygbfdo3sfo66iVUnTWcFvtlBXNrqxKzcspey
 234LTLqXaD9JqEE5qosLf2pa0yQPK1qgJwYeighuhcb7x6yOgGojoP/NzEyfk4SrydsX 4w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv886kk6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 16:53:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BAGhclm017631;
        Fri, 10 Dec 2021 16:53:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyybmxhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 16:53:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BAGrIJe25952708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 16:53:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 631B44204D;
        Fri, 10 Dec 2021 16:53:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C6F142041;
        Fri, 10 Dec 2021 16:53:18 +0000 (GMT)
Received: from [9.145.92.178] (unknown [9.145.92.178])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 16:53:18 +0000 (GMT)
Message-ID: <2556a385-425c-0f25-2be5-efcfdc77aeaa@linux.ibm.com>
Date:   Fri, 10 Dec 2021 17:53:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Content-Language: en-US
To:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20211209121432.473979-1-equinox@diac24.net>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20211209121432.473979-1-equinox@diac24.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _iY7d-ymYKyWDW1WINSxJhUSsL0G3dDi
X-Proofpoint-ORIG-GUID: _iY7d-ymYKyWDW1WINSxJhUSsL0G3dDi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_06,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 phishscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112100094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.12.21 13:14, David Lamparter wrote:
> Split-horizon essentially just means being able to create multiple
> groups of isolated ports that are isolated within the group, but not
> with respect to each other.
> 
> The intent is very different, while isolation is a policy feature,
> split-horizon is intended to provide functional "multiple member ports
> are treated as one for loop avoidance."  But it boils down to the same
> thing in the end.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: Alexandra Winter <wintera@linux.ibm.com>
> ---
> 
> Alexandra, could you double check my change to the qeth_l2 driver?  I
> can't really test it...
> 
> Cheers,
> 
> David
> ---
Reviewed and tested for s390/qeth. Looks good to me, see 2 comments below.
Kind regards 
Alexandra


>  drivers/s390/net/qeth_l2_main.c | 10 ++++++----
>  include/linux/if_bridge.h       |  9 ++++++++-
>  include/uapi/linux/if_link.h    |  1 +
>  net/bridge/br_if.c              | 12 ++++++++++++
>  net/bridge/br_input.c           |  2 +-
>  net/bridge/br_netlink.c         | 33 +++++++++++++++++++++++++++++++--
>  net/bridge/br_private.h         | 13 ++++++++++---
>  net/bridge/br_sysfs_if.c        | 33 ++++++++++++++++++++++++++++++++-
>  8 files changed, 101 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
> index 303461d70af3..405d36757c22 100644
> --- a/drivers/s390/net/qeth_l2_main.c
> +++ b/drivers/s390/net/qeth_l2_main.c
> @@ -729,8 +729,8 @@ static bool qeth_l2_must_learn(struct net_device *netdev,
>  	priv = netdev_priv(netdev);
>  	return (netdev != dstdev &&
>  		(priv->brport_features & BR_LEARNING_SYNC) &&
> -		!(br_port_flag_is_set(netdev, BR_ISOLATED) &&
> -		  br_port_flag_is_set(dstdev, BR_ISOLATED)) &&
> +		!(br_port_horizon_group(netdev) != 0 &&
> +		  br_port_horizon_group(netdev) == br_port_horizon_group(dstdev)) &&
WARNING: line length of 84 exceeds 80 columns

>  		(netdev->netdev_ops == &qeth_l2_iqd_netdev_ops ||
>  		 netdev->netdev_ops == &qeth_l2_osa_netdev_ops));
>  }
> @@ -757,6 +757,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
>  	struct net_device *lowerdev;
>  	struct list_head *iter;
>  	int err = 0;
> +	u32 horizon_group;
reverse Christmas tree!
>  
>  	kfree(br2dev_event_work);
>  	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
> @@ -770,12 +771,13 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
>  	if (!qeth_l2_must_learn(lsyncdev, dstdev))
>  		goto unlock;
>  
> -	if (br_port_flag_is_set(lsyncdev, BR_ISOLATED)) {
> +	horizon_group = br_port_horizon_group(lsyncdev);
> +	if (horizon_group) {
>  		/* Update lsyncdev and its isolated sibling(s): */
>  		iter = &brdev->adj_list.lower;
>  		lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
>  		while (lowerdev) {
> -			if (br_port_flag_is_set(lowerdev, BR_ISOLATED)) {
> +			if (br_port_horizon_group(lowerdev) == horizon_group) {
>  				switch (event) {
>  				case SWITCHDEV_FDB_ADD_TO_DEVICE:
>  					err = dev_uc_add(lowerdev, addr);

---snip---
