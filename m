Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1807B9C445
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 16:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfHYOId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 10:08:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfHYOId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 10:08:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7PE3lRG067198;
        Sun, 25 Aug 2019 14:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PvhRdo7N/zTKpxLlKU0DBJOPSW502ClruZlBheiTva0=;
 b=M8jTXlFRJZk4oGxvGffyEKQJcpe1WP2n4lm8ecMOE8iKS3UHKlhB636lD1qOdDpe7yuQ
 Z7qnbP/0utoRz6rIXBabdu5Tjzg3Hzmc2N3eHq8e6D8mkuZJBfc8bsefc8KSd9Q5wVVS
 p/ysxtcJwUxxztmx0+5cZr67TnYdS6qcVLS1hXx5AKtzlpTttk544VJNIuBBdRtvcmMe
 GgJ5pbA0/m6aW4samyj0s2VNhA7KKsYotPxj8v0wC5gKE+3HEw66fI4tEMM1z+v5D5zq
 4EJkp78h338SOLnD1+v+E0s3AIgOirayUho6fRiDH69leQLUkau0r4inyk7arVQDcvi9 YQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ujwvq42xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Aug 2019 14:08:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7PE3weZ143904;
        Sun, 25 Aug 2019 14:08:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ujw6ty7dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Aug 2019 14:08:24 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7PE8OZI153277;
        Sun, 25 Aug 2019 14:08:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ujw6ty7dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Aug 2019 14:08:24 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7PE8NmJ017774;
        Sun, 25 Aug 2019 14:08:23 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Aug 2019 07:08:23 -0700
Subject: Re: [PATCHv2 1/1] net: rds: add service level support in rds-info
To:     David Miller <davem@davemloft.net>
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        gerd.rausch@oracle.com
References: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
 <20190824.165851.1817456673626840850.davem@davemloft.net>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <23ca3876-ee47-6ee9-8d03-9ceada3eca98@oracle.com>
Date:   Sun, 25 Aug 2019 22:11:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190824.165851.1817456673626840850.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9359 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908250160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/25 7:58, David Miller wrote:
> From: Zhu Yanjun <yanjun.zhu@oracle.com>
> Date: Fri, 23 Aug 2019 21:04:16 -0400
>
>> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
>> index fd6b5f6..cba368e 100644
>> --- a/include/uapi/linux/rds.h
>> +++ b/include/uapi/linux/rds.h
>> @@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
>>   	__u32		rdma_mr_max;
>>   	__u32		rdma_mr_size;
>>   	__u8		tos;
>> +	__u8		sl;
>>   	__u32		cache_allocs;
>>   };
> I'm applying this, but I am once again severely disappointed in how
> RDS development is being handled.
>
> >From the Fixes: commit:
>
> 	Since rds.h in rds-tools is not related with the kernel rds.h,
> 	the change in kernel rds.h does not affect rds-tools.
>
> This is the height of arrogance and shows a lack of understanding of
> what user ABI requirements are all about.
>
> It is possible for other userland components to be built by other
> people, outside of your controlled eco-system and tools, that use
> these interfaces.
>
> And you cannot control that.
>
> Therefore you cannot make arbitrary changes to UABI data strucures
> just because the tool you use and maintain is not effected by it.
>
> Please stop making these incredibly incompatible user interface
> changes in the RDS stack.
>
> I am, from this point forward, going to be extra strict on RDS stack
> changes especially in this area.

OK. It is up to you to decide to merge this commit or not.

Zhu Yanjun

>
>
