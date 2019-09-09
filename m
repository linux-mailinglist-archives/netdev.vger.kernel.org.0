Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A3AE040
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 23:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391744AbfIIVVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 17:21:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726930AbfIIVVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 17:21:36 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x89LHMWW084360;
        Mon, 9 Sep 2019 17:21:10 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uwx5srscx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 17:21:10 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x89LKCWU022942;
        Mon, 9 Sep 2019 21:21:09 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 2uv466twy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 21:21:09 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x89LL7KI57672074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Sep 2019 21:21:07 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B78C4C605A;
        Mon,  9 Sep 2019 21:21:07 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 189C6C6059;
        Mon,  9 Sep 2019 21:21:06 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.80.200.46])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  9 Sep 2019 21:21:05 +0000 (GMT)
Subject: Re: [PATCH] net/ibmvnic: Fix missing { in __ibmvnic_reset
To:     Michal Suchanek <msuchanek@suse.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Juliet Kim <julietk@linux.vnet.ibm.com>
Cc:     linux-kernel@vger.kernel.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        John Allen <jallen@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20190909204451.7929-1-msuchanek@suse.de>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <060cae7c-48bf-bddd-5086-a2a0d8f02c1a@linux.ibm.com>
Date:   Mon, 9 Sep 2019 14:21:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190909204451.7929-1-msuchanek@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-09_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909090206
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/19 1:44 PM, Michal Suchanek wrote:
> Commit 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
> adds a } without corresponding { causing build break.
> 
> Fixes: 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 6644cabc8e75..5cb55ea671e3 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1984,7 +1984,7 @@ static void __ibmvnic_reset(struct work_struct *work)
>  	rwi = get_next_rwi(adapter);
>  	while (rwi) {
>  		if (adapter->state == VNIC_REMOVING ||
> -		    adapter->state == VNIC_REMOVED)
> +		    adapter->state == VNIC_REMOVED) {
>  			kfree(rwi);
>  			rc = EBUSY;
>  			break;
> 

