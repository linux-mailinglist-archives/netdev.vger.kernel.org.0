Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F98BDDCC
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405422AbfIYMKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:10:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404622AbfIYMKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 08:10:12 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8PC8Prq145034
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 08:10:11 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v87txrghu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 08:10:10 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Wed, 25 Sep 2019 13:10:09 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Sep 2019 13:10:06 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8PCA5ki19333178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 12:10:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77F694C05A;
        Wed, 25 Sep 2019 12:10:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42FF44C04E;
        Wed, 25 Sep 2019 12:10:05 +0000 (GMT)
Received: from oc5311105230.ibm.com (unknown [9.152.224.222])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Sep 2019 12:10:05 +0000 (GMT)
Subject: Re: [PATCH net v2 0/3] net/smc: move some definitions to UAPI
To:     David Miller <davem@davemloft.net>, esyr@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgraul@linux.ibm.com
References: <cover.1568993930.git.esyr@redhat.com>
 <20190924.165240.1617972512581218831.davem@davemloft.net>
From:   Ursula Braun <ubraun@linux.ibm.com>
Openpgp: preference=signencrypt
Date:   Wed, 25 Sep 2019 14:10:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924.165240.1617972512581218831.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19092512-0016-0000-0000-000002B0701F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092512-0017-0000-0000-0000331137E4
Message-Id: <20af78a4-ded5-57ca-bd77-303cc7a59cf5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-25_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909250125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/24/19 4:52 PM, David Miller wrote:
> From: Eugene Syromiatnikov <esyr@redhat.com>
> Date: Fri, 20 Sep 2019 17:41:47 +0200
> 
>> As of now, it's a bit difficult to use SMC protocol, as significant part
>> of definitions related to it are defined in private headers and are not
>> part of UAPI. The following commits move some definitions to UAPI,
>> making them readily available to the user space.
>>
>> Changes since v1[1]:
>>  * Patch "provide fallback diagnostic codes in UAPI" is updated
>>    in accordance with the updated set of diagnostic codes.
>>
>> [1] https://lkml.org/lkml/2018/10/7/177
> 
> Isn't it way too late for this?
> 
> These definitions will now be duplicates for userland code that
> defines the values on their own.
>

Dave,
we have to admit that it is already late for these patches. Nevertheless
we think it is better to come up with them now than never. We doubt there
exists already much userland code for it - except our own IBM-provided
package smc-tools. Thus we appreciate acceptance of these patches.

Kind regards, Ursula

 

