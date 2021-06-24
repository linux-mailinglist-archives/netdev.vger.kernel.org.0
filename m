Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337243B283A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhFXHJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:09:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231454AbhFXHJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 03:09:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O742WN005505
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ddi7JF3KXzxLJgZeO7KxYc9tz2JfNVVjbjxG8/fR/H0=;
 b=bSzZXEGvxf5WmK2XsJyT0PbSXIrwkZ+kB+DwjIpAV6HlVBaDpviZRUvwTucl7G7d6DQp
 w3zfEwoCfQ3EzAx7SYuqgOZMBcPso3vTnSjKMAXJ/kGDp4w2kafim1a0IntY0wMWZ3If
 WzKjM3/e+7zEBmAt4qvragxVaAhqXkZ0rqyLCLxOcezBNl9NCsi9ObWbA2wtKtJTrqPd
 1ysVDwWRbZpiIQ1BSb9ZcvPd4loddPZl2Bg6WHhytgt8uAk7fUdsxtZwUU/XVXfzu5AT
 X7nuSYVxzILZ9nxOD4V52owzdmOG/SpeMiauO2BLkkEmBpUKUPb+3W1OohVRrdzFy6Rv RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cn3t8n0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:07:11 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15O745UU006158
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:07:11 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cn3t8myq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 03:07:11 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O74dA8002606;
        Thu, 24 Jun 2021 07:07:10 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 399879pq3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 07:07:10 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O778vk23921070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 07:07:08 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D3DAE062;
        Thu, 24 Jun 2021 07:07:08 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32A9AAE05C;
        Thu, 24 Jun 2021 07:07:07 +0000 (GMT)
Received: from [9.160.66.172] (unknown [9.160.66.172])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 07:07:07 +0000 (GMT)
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Lijun Pan <lijunp213@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-3-sukadev@linux.ibm.com>
 <CAOhMmr6USoB-yw1HduSWc1h2AGdS7U3+Ze9nBRh51pM=V2P8Kw@mail.gmail.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <eb5d5fda-2c55-c322-0d1f-a56492a0878e@linux.vnet.ibm.com>
Date:   Thu, 24 Jun 2021 00:07:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAOhMmr6USoB-yw1HduSWc1h2AGdS7U3+Ze9nBRh51pM=V2P8Kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EWUx4Szm1GKpOR_yt1Ls0sfc6cCRhIgD
X-Proofpoint-ORIG-GUID: Q5SxQoJM4l3L-Y9fRHMlQweqJYgwVefF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_06:2021-06-23,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240039
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/21 11:20 PM, Lijun Pan wrote:

>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
>> index f13ad6bc67cd..fe1627ea9762 100644
>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> @@ -1234,6 +1234,11 @@ static int __ibmvnic_open(struct net_device *netdev)
>>
>>          netif_tx_start_all_queues(netdev);
>>
>> +       if (prev_state == VNIC_CLOSED) {
>> +               for (i = 0; i < adapter->req_rx_queues; i++)
>> +                       napi_schedule(&adapter->napi[i]);
>> +       }
>> +
> 
> interrupt_rx will schedule the napi, so not necessary here.

You keep saying this, but yet there is some case with the original patch that leaves napi unscheduled and the device unresponsive.  Until that is better understood, this patch should be reverted - especially when you consider that calling napi_schedule() when the rx_queue is already scheduled is harmless.  The original patch did not address any specific problem, but did introduce one.

Rick

