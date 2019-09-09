Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADA9AE13D
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfIIWt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:49:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728945AbfIIWt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:49:56 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x89Mmn9I178443;
        Mon, 9 Sep 2019 18:49:21 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uwxaatkgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 18:49:21 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x89MjHil016031;
        Mon, 9 Sep 2019 22:49:21 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 2uv466x1k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 22:49:20 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x89MnJIl52691376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Sep 2019 22:49:19 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D0197805E;
        Mon,  9 Sep 2019 22:49:19 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7208E7805C;
        Mon,  9 Sep 2019 22:49:16 +0000 (GMT)
Received: from Juliets-MBP.attlocal.net (unknown [9.85.151.142])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Sep 2019 22:49:16 +0000 (GMT)
Subject: Re: [PATCH] net/ibmvnic: Fix missing { in __ibmvnic_reset
To:     Michal Suchanek <msuchanek@suse.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        John Allen <jallen@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20190909204451.7929-1-msuchanek@suse.de>
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
Message-ID: <953ee49d-5d2f-90d2-bc6f-b738c0718c6f@linux.vnet.ibm.com>
Date:   Mon, 9 Sep 2019 17:49:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190909204451.7929-1-msuchanek@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-09_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909090214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/19 3:44 PM, Michal Suchanek wrote:
> Commit 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
> adds a } without corresponding { causing build break.
>
> Fixes: 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Reviewed-by: Juliet Kim <julietk@linux.vnet.ibm.com>

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
