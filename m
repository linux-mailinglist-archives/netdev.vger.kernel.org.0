Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AEAA7A8D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 07:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbfIDFFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 01:05:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfIDFFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 01:05:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x845402G060270;
        Wed, 4 Sep 2019 05:04:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oi/ab2uw6R0FfymF44zNtlUTpBXlBjgUdhtyJfnaM/E=;
 b=WFh3ouU4a7jWuVeopL+C8ZUE1R+qm12fjKZUyBs/OvfLgNElqaDWBhUTwr84Z0eMhbqE
 Kwcw8m24O6jxSNbVQg41L7uNc6t6Dg+NLlD76vvjMOAGSWLbA1BvDttbaHe1jG1RH8c3
 jJT/46vcLBpzuHPnBepcFBjRbIfGzfUMJLqCnhAMVcE7y+QeI4ZwSm49+aRdCsR5TVco
 Cn2z3we/uePW7plV5xls3ickQyxz82/wuUEHSkOjAJlg/vB+8n38qxChpxriLCWFNzCm
 DREszKE0sI1epF+TI8c+fOuU1obT4bxYI6Z6w+1XgjPneMk/9ELDJckSU/C4rRyPexwd hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ut6rx00df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 05:04:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8453MYM100461;
        Wed, 4 Sep 2019 05:04:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ut1hmurtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Sep 2019 05:04:48 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8454msh104844;
        Wed, 4 Sep 2019 05:04:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ut1hmursx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 05:04:48 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8454l1k016346;
        Wed, 4 Sep 2019 05:04:47 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 22:04:46 -0700
Subject: Re: [PATCHv2 1/1] net: rds: add service level support in rds-info
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, gerd.rausch@oracle.com
References: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
 <4422c894-4182-18ba-efa2-f86a1f14a3a6@embeddedor.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <568fde9c-8838-330b-1b41-f61c14edac90@oracle.com>
Date:   Wed, 4 Sep 2019 13:08:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4422c894-4182-18ba-efa2-f86a1f14a3a6@embeddedor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040053
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/3 9:58, Gustavo A. R. Silva wrote:
> Hi,
>
> On 8/23/19 8:04 PM, Zhu Yanjun wrote:
>
> [..]
>
>> diff --git a/net/rds/ib.c b/net/rds/ib.c
>> index ec05d91..45acab2 100644
>> --- a/net/rds/ib.c
>> +++ b/net/rds/ib.c
>> @@ -291,7 +291,7 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
>>   				    void *buffer)
>>   {
>>   	struct rds_info_rdma_connection *iinfo = buffer;
>> -	struct rds_ib_connection *ic;
>> +	struct rds_ib_connection *ic = conn->c_transport_data;
>>   
>>   	/* We will only ever look at IB transports */
>>   	if (conn->c_trans != &rds_ib_transport)
>> @@ -301,15 +301,16 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
>>   
>>   	iinfo->src_addr = conn->c_laddr.s6_addr32[3];
>>   	iinfo->dst_addr = conn->c_faddr.s6_addr32[3];
>> -	iinfo->tos = conn->c_tos;
>> +	if (ic) {
> Is this null-check actually necessary? (see related comments below...)
>
>> +		iinfo->tos = conn->c_tos;
>> +		iinfo->sl = ic->i_sl;
>> +	}
>>   
>>   	memset(&iinfo->src_gid, 0, sizeof(iinfo->src_gid));
>>   	memset(&iinfo->dst_gid, 0, sizeof(iinfo->dst_gid));
>>   	if (rds_conn_state(conn) == RDS_CONN_UP) {
>>   		struct rds_ib_device *rds_ibdev;
>>   
>> -		ic = conn->c_transport_data;
>> -
>>   		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo->src_gid,
> Notice that *ic* is dereferenced here without null-checking it. More
> comments below...
>
>>   			       (union ib_gid *)&iinfo->dst_gid);
>>   
>> @@ -329,7 +330,7 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
>>   				     void *buffer)
>>   {
>>   	struct rds6_info_rdma_connection *iinfo6 = buffer;
>> -	struct rds_ib_connection *ic;
>> +	struct rds_ib_connection *ic = conn->c_transport_data;
>>   
>>   	/* We will only ever look at IB transports */
>>   	if (conn->c_trans != &rds_ib_transport)
>> @@ -337,6 +338,10 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
>>   
>>   	iinfo6->src_addr = conn->c_laddr;
>>   	iinfo6->dst_addr = conn->c_faddr;
>> +	if (ic) {
>> +		iinfo6->tos = conn->c_tos;
>> +		iinfo6->sl = ic->i_sl;
>> +	}
>>   
>>   	memset(&iinfo6->src_gid, 0, sizeof(iinfo6->src_gid));
>>   	memset(&iinfo6->dst_gid, 0, sizeof(iinfo6->dst_gid));
>> @@ -344,7 +349,6 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
>>   	if (rds_conn_state(conn) == RDS_CONN_UP) {
>>   		struct rds_ib_device *rds_ibdev;
>>   
>> -		ic = conn->c_transport_data;
>>   		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo6->src_gid,
> Again, *ic* is being dereferenced here without a previous null-check.

Please  check when this "rds_conn_state(conn) = RDS_CONN_UP".

Thanks a lot.

Zhu Yanjun

>
>>   			       (union ib_gid *)&iinfo6->dst_gid);
>>   		rds_ibdev = ic->rds_ibdev;
>
> --
> Gustavo
>
