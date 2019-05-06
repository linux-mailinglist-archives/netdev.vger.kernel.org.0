Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5976F151C2
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfEFQgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:36:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEFQgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:36:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GYTO5170811;
        Mon, 6 May 2019 16:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=EWR9mAE9WuLs5jQqRv0gbOHqwgMH2bW0jfcNDeCIAy8=;
 b=He52GcukaOwbM7uUF1FzEMNCiLHY2UbgdjNnm5o/mIqHgaWYvNx9xiWIDmFqfzeI1bSl
 psgwi+KUqvBDto+Dz/PW2YW95XL8b4BNAdiKc/mvNTDe4+kLTWhk5QcnkNOHBe8dTu4R
 7uis80Tk1Ljsj8n/vkIkb+2VK7YVV2oIq0SX8vVxY0Gz6hIc+FCGAEhzBPIvOM1J3TEF
 MOXaODIJ8o2AzkSWooJt0kaQAdqZZFVjupW0EE2ROa5Bf34aoIsw3oPcBxpsgZBzF2Sz
 82iMLw0zpTSZyNqFvGt3ZGicAmVVywFtv6XzDWqh5CmASE+cvr1sSqj+UTPJH4SaIA9x GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2s94bfqskm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 May 2019 16:36:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GZG3d048270;
        Mon, 6 May 2019 16:36:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2s94af0ecf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 May 2019 16:36:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x46GaUB0010380;
        Mon, 6 May 2019 16:36:30 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 09:36:30 -0700
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Moni Shoua <monis@mellanox.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074415.GB7676@mtr-leonro.mtl.com>
 <2829f9d8-0383-d141-46c3-f2a09cd542b2@oracle.com>
 <20190502062120.GM7676@mtr-leonro.mtl.com>
 <b7781380-e85b-78b4-f89e-1e627e213896@oracle.com>
 <20190505062844.GB6938@mtr-leonro.mtl.com>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <485d248b-13e9-5a70-6bd4-95911c28c861@oracle.com>
Date:   Mon, 6 May 2019 09:39:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505062844.GB6938@mtr-leonro.mtl.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905060141
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905060141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2019 11:28 PM, Leon Romanovsky wrote:
> On Thu, May 02, 2019 at 10:52:23AM -0700, Santosh Shilimkar wrote:
>> On 5/1/2019 11:21 PM, Leon Romanovsky wrote:
>>> On Wed, May 01, 2019 at 10:54:00AM -0700, Santosh Shilimkar wrote:
>>>> On 5/1/2019 12:44 AM, Leon Romanovsky wrote:
>>>>> On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
>>>>>> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>>>>>
>>>>>> RDS doesn't support RDMA on memory apertures that require On Demand
>>>>>> Paging (ODP), such as FS DAX memory. User applications can try to use
>>>>>> RDS to perform RDMA over such memories and since it doesn't report any
>>>>>> failure, it can lead to unexpected issues like memory corruption when
>>>>>> a couple of out of sync file system operations like ftruncate etc. are
>>>>>> performed.
>>>>>>
>>>>>> The patch adds a check so that such an attempt to RDMA to/from memory
>>>>>> apertures requiring ODP will fail.
>>>>>>
>>>>>> Reviewed-by: H??kon Bugge <haakon.bugge@oracle.com>
>>>>>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>>>>>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>>>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>>>>>> ---
>>>>>>     net/rds/rdma.c | 5 +++--
>>>>>>     1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
>>>>>> index 182ab84..e0a6b72 100644
>>>>>> --- a/net/rds/rdma.c
>>>>>> +++ b/net/rds/rdma.c
>>>>>> @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
>>>>>>     {
>>>>>>     	int ret;
>>>>>>
>>>>>> -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
>>>>>> -
>>>>>> +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
>>>>>> +	ret = get_user_pages_longterm(user_addr, nr_pages,
>>>>>> +				      write, pages, NULL);
>>>>>
>>>>> I'm not RDS expert, but from what I see in net/rds/rdma.c and this code,
>>>>> you tried to mimic ib_umem_get() without protection, checks and native
>>>>> ODP, FS and DAX supports.
>>>>>
>>>>> The real way to solve your ODP problem will require to extend
>>>>> ib_umem_get() to work for kernel ULPs too and use it instead of
>>>>> get_user_pages(). We are working on that and it is in internal review now.
>>>>>
>>>> Yes am aware of it. For FS_DAX like memory,  get_user_pages_longterm()
>>>> fails and then using ib_reg_user_mr() the memory is registered as
>>>> ODP regsion. This work is not ready yet and without above check,
>>>> one can do RDMA on FS DAX memory with Fast Reg or FMR memory
>>>> registration which is not safe and hence need to fail the operation.
>>>>
>>>> Once the support is added to RDS, this code path will make that
>>>> registration go through.
>>>>
>>>> Hope it clarifies.
>>>
>>> Only partial, why don't you check if user asked ODP through verbs
>>> interface and return EOPNOTSUPP in such case?
>>>
>> I think you are mixing two separate things. ODP is just one way of
>> supporting RDMA on FS DAX memory. Tomorrow, some other mechanism
>> can be used as well. RDS is just using inbuilt kernel mm API
>> to find out if its FS DAX memory(get_user_pages_longterm).
>> Current code will make RDS get_mr fail if RDS application issues
>> memory registration request on FS DAX memory and in future when
>> support gets added, it will do the ODP registration and return
>> the key.
> 
> But we are talking about kernel code only, right?
> Future support will be added if it exists.
> 
yes kernel code only.

>>
>>> It will ensure that once your code will support ODP properly written
>>> applications will work with/without ODP natively.
>>>
>> Application shouldn't care if RDS ULP internally uses ODP
>> or some other mechanism to support RDMA on FS DAX memory.
>> This makes it transparent it to RDS application.
> 
> ODP checks need to be internal to kernel, user won't see those ODP
> checks.
> 
Correct. The check is within RDS kernel module.
