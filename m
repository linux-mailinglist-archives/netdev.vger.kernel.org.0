Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4E11EC1B6
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgFBSTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:19:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBSTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 14:19:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IIjFK004155;
        Tue, 2 Jun 2020 18:19:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hF0mObcKC8h/H6oayYNtykI3tyzQC1i6+1e5jPnZVGI=;
 b=vgGbsJR8kBPoY7pxdUrWwekDDQjOtq9qR2z+pycVaNZMrKsJBwnwhXXifROaBBh0eHAi
 lh9qL08fL9nIJAj/VquZNsUa19xaPp53IWKn90j7D6rI+41nN9B9jwf2EyGE+lggf9Tx
 Qg3yw8Bw+4uFfcblxIh8FYvONFFvUAmTqI6+vvwx3qa9wmM9miw1/YvFxPmtH9WZpKcQ
 lkIw5Ruxn3PARSCaH6ibFw02nox5hjUsBsv2fcQYTOFHnqOR3UZBVdpfwF5HPmwQLHuE
 zptX/asHmz7Z9+liAoQWkJl0bcW4iV5/xvud7THtY9hj9fhgBQHmZ0WwYLKqjhWfVFjV 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqwhqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 18:19:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IJHAa105411;
        Tue, 2 Jun 2020 18:19:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31c1dxppdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 18:19:41 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052IJeS7027641;
        Tue, 2 Jun 2020 18:19:40 GMT
Received: from [10.159.248.29] (/10.159.248.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 11:19:40 -0700
Subject: Re: [PATCH net-next] rds: transport module should be auto loaded when
 transport is set
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, somasundaram.krishnasamy@oracle.com
References: <20200527081742.25718-1-rao.shoaib@oracle.com>
 <20200529.164107.1817677145426311890.davem@davemloft.net>
 <4f86d778-1f6b-d533-c062-c78daa257829@oracle.com>
 <20200602061715.GA56352@unreal>
From:   Rao Shoaib <rao.shoaib@oracle.com>
Message-ID: <0237090f-ba68-f689-782f-3993b89fae15@oracle.com>
Date:   Tue, 2 Jun 2020 11:19:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200602061715.GA56352@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020133
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/1/20 11:17 PM, Leon Romanovsky wrote:
> On Mon, Jun 01, 2020 at 09:59:30AM -0700, Rao Shoaib wrote:
>> On 5/29/20 4:41 PM, David Miller wrote:
>>> From: rao.shoaib@oracle.com
>>> Date: Wed, 27 May 2020 01:17:42 -0700
>>>
>>>> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
>>>> index cba368e55863..7273c681e6c1 100644
>>>> --- a/include/uapi/linux/rds.h
>>>> +++ b/include/uapi/linux/rds.h
>>>> @@ -64,7 +64,7 @@
>>>>    /* supported values for SO_RDS_TRANSPORT */
>>>>    #define	RDS_TRANS_IB	0
>>>> -#define	RDS_TRANS_IWARP	1
>>>> +#define	RDS_TRANS_GAP	1
>>>>    #define	RDS_TRANS_TCP	2
>>>>    #define RDS_TRANS_COUNT	3
>>>>    #define	RDS_TRANS_NONE	(~0)
>>> You can't break user facing UAPI like this, sorry.
>> I was hoping that this could be considered an exception as IWARP has been
>> deprecated for almost a decade and there is no current product using it.
>> With the change any old binary will continue to work, a new compilation fill
>> fail so that the code can be examined, otherwise we will never be able to
>> reuse this number.
>>
>> If the above is not acceptable I can revert this part of the change.
> Nothing prohibits you from adding the following lines:
>
> + /* don't use RDS_TRANS_IWARP - it is deprecated */
> + #define  RDS_TRANS_GAP RDS_TRANS_IWARP

Correct. That is what I was planning on doing in case I could not get 
rid of RDS_TRANS_IWARP. I will resubmit the patch.

Shoaib

>
>> Shoaib
>>
