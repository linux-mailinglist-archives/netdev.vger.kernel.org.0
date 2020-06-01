Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A3C1EA80F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgFAQ7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 12:59:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50022 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAQ7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 12:59:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051GvqAh186931;
        Mon, 1 Jun 2020 16:59:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Co6TBpPBWOOIua0C6lZXDzHL7YHL+4VljOm7wRvuiLg=;
 b=kga5LbBEWrNccNtyM17rbBxrbjpe+8Tm+f3KCySn/nrzpvuSU6l3HNgmsfcyCPnAtUgn
 9rHTGEIBvkEDYwnqp+dHe4AFXS2oVj2yYDPIwub7Ko8Q8UqEFtww0zt+hYANubXySdYW
 vOD0iGs2MJSjQm3F1i5PJEW4aiBWg5Pzm9DXpZmJqCBuZ1ZNVjmL3vZ3MtWwSCwmCV+Q
 cOLfzHajLEuP4oYSDkbzeHFK8uY8zag2/GWsdKmDGgCMjft9n890WSRAbRbFWCffxrsJ
 KNuoVNSEXbkyCVlK8cGMXk5fd3zW0up1UNkLpkOaBsMDkQrILKXb66fwJvqVavcWHrxK /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31bewqqv48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 01 Jun 2020 16:59:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051GrLti068866;
        Mon, 1 Jun 2020 16:59:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31c12msumk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jun 2020 16:59:32 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 051GxVhT006744;
        Mon, 1 Jun 2020 16:59:32 GMT
Received: from [10.159.235.19] (/10.159.235.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 09:59:31 -0700
Subject: Re: [PATCH net-next] rds: transport module should be auto loaded when
 transport is set
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        somasundaram.krishnasamy@oracle.com
References: <20200527081742.25718-1-rao.shoaib@oracle.com>
 <20200529.164107.1817677145426311890.davem@davemloft.net>
From:   Rao Shoaib <rao.shoaib@oracle.com>
Message-ID: <4f86d778-1f6b-d533-c062-c78daa257829@oracle.com>
Date:   Mon, 1 Jun 2020 09:59:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200529.164107.1817677145426311890.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006010125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006010125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/29/20 4:41 PM, David Miller wrote:
> From: rao.shoaib@oracle.com
> Date: Wed, 27 May 2020 01:17:42 -0700
>
>> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
>> index cba368e55863..7273c681e6c1 100644
>> --- a/include/uapi/linux/rds.h
>> +++ b/include/uapi/linux/rds.h
>> @@ -64,7 +64,7 @@
>>   
>>   /* supported values for SO_RDS_TRANSPORT */
>>   #define	RDS_TRANS_IB	0
>> -#define	RDS_TRANS_IWARP	1
>> +#define	RDS_TRANS_GAP	1
>>   #define	RDS_TRANS_TCP	2
>>   #define RDS_TRANS_COUNT	3
>>   #define	RDS_TRANS_NONE	(~0)
> You can't break user facing UAPI like this, sorry.

I was hoping that this could be considered an exception as IWARP has 
been deprecated for almost a decade and there is no current product 
using it. With the change any old binary will continue to work, a new 
compilation fill fail so that the code can be examined, otherwise we 
will never be able to reuse this number.

If the above is not acceptable I can revert this part of the change.

Shoaib

