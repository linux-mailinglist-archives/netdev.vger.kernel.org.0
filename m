Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3755A48E98D
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbiANL6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:58:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240915AbiANL6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:58:49 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EBqmls006270;
        Fri, 14 Jan 2022 11:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7a5Rr5NSCIa/jUx6lPSwalDwDCLvamBMnf9cJzqBIvY=;
 b=iyFJXLcT9BEibaB22vd5+dinmtzBaxNbaVXe6iBPWhMilXDlbe9PSb4CdzUiaz+/evER
 wXBr/WdBVduV46VV7Bk01Fy0piuaqAJiY13v0WyDFN4RKwfAoAVKqdW5+a3+Rzybic25
 2pkWc/uaVP+I1rMPlyCQTwJjWc9LZEmK4oDkhifQmMFPIeSSnQj5e/b3aJVin/q1ym1m
 /MtCs5RLB+e61OXIZnmHkdCJEYcwzvVxOa2+IO5FZT3P84NhhKKo4AvZl1T3SuUs2qFX
 RujBVUTB7d2hGDFBnSvZimLPyj+zREdFmCzEoQqWk2/hCdBybK1Qxnvi2bUcodoiokoQ Qw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8pgr399-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:58:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EBut8q027120;
        Fri, 14 Jan 2022 11:58:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhjx89f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:58:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EBwds542402244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 11:58:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18F40A4051;
        Fri, 14 Jan 2022 11:58:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4EDDA4040;
        Fri, 14 Jan 2022 11:58:38 +0000 (GMT)
Received: from [9.145.186.190] (unknown [9.145.186.190])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 11:58:38 +0000 (GMT)
Message-ID: <45b2b8d0-b913-20cd-62ca-e6014505632c@linux.ibm.com>
Date:   Fri, 14 Jan 2022 12:58:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] s390/qeth: Remove redundant 'flush_workqueue()' calls
Content-Language: en-US
To:     Xu Wang <vulab@iscas.ac.cn>, wenjia@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114084218.42586-1-vulab@iscas.ac.cn>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220114084218.42586-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NzWqRMjSy_WK9YdUYjrMAbT4yXh1RsUd
X-Proofpoint-ORIG-GUID: NzWqRMjSy_WK9YdUYjrMAbT4yXh1RsUd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0
 clxscore=1011 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201140077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.01.22 09:42, Xu Wang wrote:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/s390/net/qeth_l3_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
> index 9251ad276ee8..d2f422a9a4f7 100644
> --- a/drivers/s390/net/qeth_l3_main.c
> +++ b/drivers/s390/net/qeth_l3_main.c
> @@ -1961,7 +1961,6 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
>  	if (card->dev->reg_state == NETREG_REGISTERED)
>  		unregister_netdev(card->dev);
>  
> -	flush_workqueue(card->cmd_wq);
>  	destroy_workqueue(card->cmd_wq);
>  	qeth_l3_clear_ip_htable(card, 0);
>  	qeth_l3_clear_ipato_list(card);

Thanks for pointing this out!

IMO, this can go to net-next as it is not a fix, but removes redundancy.

Acked-by: Alexandra Winter <wintera@linux.ibm.com>
