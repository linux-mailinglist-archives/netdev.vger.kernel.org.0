Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFFD3D6975
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhGZVnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:43:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4902 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231990AbhGZVnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 17:43:49 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QMH7Td027592;
        Mon, 26 Jul 2021 22:23:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=V+YN/pr6U6avdjNltlEBndjqKop3RfqP+MM/c4xjz3Q=;
 b=ykyrjOASaSyQxZLjC+zRL9sgMHnUrMs7Y1Ey18KpMmTn0ZPiBHGAlrqRxie5cwt2OWBW
 EjQwBpxsWjZg9owvrqT1pI9dGfyD9zOgWydhZN6nly1R3oeutM3+gjQYg0Dz2tg1L9Jx
 cUXMgtRoeJtx5+49jNo8YqBF2598TOun6QNelJic5sBKBVWT1KItdPuO1cKfgZm3S8iT
 tfR6bjt/vQDfFctx/oGgDRcZRZF9+FJa/jQNyN8XoPtUHZCB3+jolTeIjoXTEslljC4v
 Rz/Z/ZCVQD1tt0Dxdh+q26RePspDiwqtXDfjkYDpSMekD/3QkPKXTUVonvahsIaReuNd jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=V+YN/pr6U6avdjNltlEBndjqKop3RfqP+MM/c4xjz3Q=;
 b=g6UPtY0owqQ5xa+glQgaCG90Pe7/LFWEB8bSu72eWxyg58ithH2M61IUXTtub14ZJspe
 P+0+t3yFRucRTUm2xY+UuqFOS3n6Byv7AnwBR8lfZClLsr1qhFVo6ZPnP1zUqsEfhHkt
 qqmR1V8zRwRwlQbq7iVWQKfm9TRDy6m2wJezSb1dLjyAlFUXBW5fc0D1rNawokDLhWJl
 KmiS6n0uMhFWO/hNVVvOtzYJNlM0SDybHDmNSav8t4rNHAT4v1jd2ikmdlQhubUdY8vi
 oXwYEfhC5RRZvFPapuwIK2eGLoDjEStHP3ADgUQ/GCZZ+qrlfhjNOCnH4PYy9yQ3Dq2U OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0aby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 22:23:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QLZcpk174200;
        Mon, 26 Jul 2021 22:23:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3a23498676-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 22:23:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 16QMNfgE032477;
        Mon, 26 Jul 2021 22:23:44 GMT
Received: from [192.168.0.104] (/49.207.206.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Jul 2021 15:23:41 -0700
Subject: Re: [External] : Re: [PATCH] 9p/xen: Fix end of loop tests for
 list_for_each_entry
To:     Stefano Stabellini <sstabellini@kernel.org>, asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210725175103.56731-1-harshvardhan.jha@oracle.com>
 <YP3NqQ5NGF7phCQh@codewreck.org>
 <alpine.DEB.2.21.2107261357210.10122@sstabellini-ThinkPad-T480s>
From:   Harshvardhan Jha <harshvardhan.jha@oracle.com>
Message-ID: <d956e0f2-546e-ddfd-86eb-9afb8549b40d@oracle.com>
Date:   Tue, 27 Jul 2021 03:53:37 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2107261357210.10122@sstabellini-ThinkPad-T480s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107260127
X-Proofpoint-ORIG-GUID: AZHCkNvR_tEGLvOZUSHajP9U0_PfZDat
X-Proofpoint-GUID: AZHCkNvR_tEGLvOZUSHajP9U0_PfZDat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/07/21 3:00 am, Stefano Stabellini wrote:
> On Mon, 26 Jul 2021, asmadeus@codewreck.org wrote:
>> Harshvardhan Jha wrote on Sun, Jul 25, 2021 at 11:21:03PM +0530:
>>> The list_for_each_entry() iterator, "priv" in this code, can never be
>>> NULL so the warning would never be printed.
>>
>> hm? priv won't be NULL but priv->client won't be client, so it will
>> return -EINVAL alright in practice?
>>
>> This does fix an invalid read after the list head, so there's a real
>> bug, but the commit message needs fixing.
> 
> Agreed
> 
> 
>>> Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
>>> ---
>>>  From static analysis.  Not tested.
>>
>> +Stefano in To - I also can't test xen right now :/
>> This looks functional to me but if you have a bit of time to spare just
>> a mount test can't hurt.
> 
> Yes, I did test it successfully. Aside from the commit messaged to be
> reworded:
How's this?
===========================BEGIN========================================
9p/xen: Fix end of loop tests for list_for_each_entry

This patch addresses the following problems:
  - priv can never be NULL, so this part of the check is useless
  - if the loop ran through the whole list, priv->client is invalid and
it is more appropriate and sufficient to check for the end of
list_for_each_entry loop condition.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
---
 From static analysis. Not tested.
===========================END==========================================
> 
> Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
> Tested-by: Stefano Stabellini <sstabellini@kernel.org>
> 
> 
>>> ---
>>>   net/9p/trans_xen.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
>>> index f4fea28e05da..3ec1a51a6944 100644
>>> --- a/net/9p/trans_xen.c
>>> +++ b/net/9p/trans_xen.c
>>> @@ -138,7 +138,7 @@ static bool p9_xen_write_todo(struct xen_9pfs_dataring *ring, RING_IDX size)
>>>   
>>>   static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
>>>   {
>>> -	struct xen_9pfs_front_priv *priv = NULL;
>>> +	struct xen_9pfs_front_priv *priv;
>>>   	RING_IDX cons, prod, masked_cons, masked_prod;
>>>   	unsigned long flags;
>>>   	u32 size = p9_req->tc.size;
>>> @@ -151,7 +151,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
>>>   			break;
>>>   	}
>>>   	read_unlock(&xen_9pfs_lock);
>>> -	if (!priv || priv->client != client)
>>> +	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
>>>   		return -EINVAL;
>>>   
>>>   	num = p9_req->tc.tag % priv->num_rings;
