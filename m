Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DF996F35
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 04:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfHUCHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 22:07:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfHUCHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 22:07:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L24NkZ038648;
        Wed, 21 Aug 2019 02:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Jpt22Rz137CZfbO+YNmSg/zTZ/piPXKdBPp0iZlKO/0=;
 b=Cs+O3zZk1BepOggOr1uoFsihlwIt+PNNSRX3LY1YwXU78muD0maHLkZKM9Pj8oMJE4xQ
 0mJZYKLOiofftifO17pAedxAHBvzJ48NHXO32Z6WlRqq0QJlgpkO6jSMb6lBax7QedHj
 6STyGs3sPoDbvpeE13XtRq6DYbesl+BvQShNchSYFcGGzqDwPoktv9iQFA4bIEFoZepO
 prFyCpiy2IPWgUcWkvvgiFnAFWTFtHeZhHT4IwhlLtKGrSqLdsGUvBbkRsrxXszp4jjR
 TSoC53V0UBjhrVQjXHPQHB40PTMUNKkdJJRGNXJm9Mr8m5ywNdHUQETgmjnhmR8+iK3p tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ue9hpj5cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 02:07:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L23DDW088308;
        Wed, 21 Aug 2019 02:07:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ug1ga0dhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Aug 2019 02:07:18 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7L27I1A098271;
        Wed, 21 Aug 2019 02:07:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ug1ga0dhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 02:07:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7L27HLa032090;
        Wed, 21 Aug 2019 02:07:17 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 19:07:17 -0700
Subject: Re: [PATCH 1/1] net: rds: add service level support in rds-info
To:     Doug Ledford <dledford@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
References: <1566262341-18165-1-git-send-email-yanjun.zhu@oracle.com>
 <f3de2e40f1bc2eb219d3056ee954747db90dbbb4.camel@redhat.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <f3ff7a39-8b24-5398-26c9-8a07ac9863bc@oracle.com>
Date:   Wed, 21 Aug 2019 10:10:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f3de2e40f1bc2eb219d3056ee954747db90dbbb4.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210018
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi，Doug

My reply is in line.

On 2019/8/20 23:28, Doug Ledford wrote:
> On Mon, 2019-08-19 at 20:52 -0400, Zhu Yanjun wrote:
>> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
>> index fd6b5f6..cba368e 100644
>> --- a/include/uapi/linux/rds.h
>> +++ b/include/uapi/linux/rds.h
>> @@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
>>          __u32           rdma_mr_max;
>>          __u32           rdma_mr_size;
>>          __u8            tos;
>> +       __u8            sl;
>>          __u32           cache_allocs;
>>   };
>>   
>> @@ -265,6 +266,7 @@ struct rds6_info_rdma_connection {
>>          __u32           rdma_mr_max;
>>          __u32           rdma_mr_size;
>>          __u8            tos;
>> +       __u8            sl;
>>          __u32           cache_allocs;
>>   };
>>   
> This is a user space API break (as was the prior patch mentioned
> below)...
>
>> The commit fe3475af3bdf ("net: rds: add per rds connection cache
>> statistics") adds cache_allocs in struct rds_info_rdma_connection
>> as below:
>> struct rds_info_rdma_connection {
>> ...
>>          __u32           rdma_mr_max;
>>          __u32           rdma_mr_size;
>>          __u8            tos;
>>          __u32           cache_allocs;
>>   };
>> The peer struct in rds-tools of struct rds_info_rdma_connection is as
>> below:
>> struct rds_info_rdma_connection {
>> ...
>>          uint32_t        rdma_mr_max;
>>          uint32_t        rdma_mr_size;
>>          uint8_t         tos;
>>          uint8_t         sl;
>>          uint32_t        cache_allocs;
>> };
> Why are the user space rds tools not using the kernel provided abi
> files?
Perhaps it is a long story.
>
> In order to know if this ABI breakage is safe, we need to know what
> versions of rds-tools are out in the wild and have their own headers
> that we need to match up with.

 From my works in LAB and in the customer's host, rds-tools 2.0.7 is the 
popular

version. Other versions rds-tools are used less.

>    Are there any versions of rds-tools that
> actually use the kernel provided headers?

"the kernel provided headers", do you mean include/uapi/linux/rds.h?

I checked the rds-tools source code. I do not find any version of 
rds-tools us this header files.

> Are there any other users of
> uapi/linux/rds.h besides rds-tools?

Not sure. But in Oracle, there are some rds applications. I am not sure 
whether these rds applications

will use include/uapi/linux/rds.h file or not.

I will investigate it.

>
> Once the kernel and rds-tools package are in sync,

After this commit is merged into mailine, the kernel and rds-tools 
package are in sync.

I will make investigations about rds-tools using the kernel header 
include/uapi/linux/rds.h.

Thanks a lot for your comments.

Zhu Yanjun

>   rds-tools needs to be
> modified to use the kernel header and proper ABI maintenance needs to be
> started.
>
