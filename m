Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C699BB7DC
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfIWP12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:27:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40140 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfIWP11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 11:27:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8NFRAHW058846
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 11:27:26 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v6yqxjqm5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 11:27:24 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Mon, 23 Sep 2019 16:27:21 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Sep 2019 16:27:18 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8NFRHW143712550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 15:27:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3124A11C058;
        Mon, 23 Sep 2019 15:27:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E613511C050;
        Mon, 23 Sep 2019 15:27:16 +0000 (GMT)
Received: from oc5311105230.ibm.com (unknown [9.145.92.229])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Sep 2019 15:27:16 +0000 (GMT)
Subject: Re: [PATCH net v2 0/3] net/smc: move some definitions to UAPI
To:     Eugene Syromiatnikov <esyr@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>
References: <cover.1568993930.git.esyr@redhat.com>
From:   Ursula Braun <ubraun@linux.ibm.com>
Openpgp: preference=signencrypt
Date:   Mon, 23 Sep 2019 17:27:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1568993930.git.esyr@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19092315-0008-0000-0000-00000319FD4F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092315-0009-0000-0000-00004A388D8B
Message-Id: <c5d4a6d4-cb91-1add-5ed8-8b08a56c70d5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909230146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/19 5:41 PM, Eugene Syromiatnikov wrote:
> Hello.
> 
> As of now, it's a bit difficult to use SMC protocol, as significant part
> of definitions related to it are defined in private headers and are not
> part of UAPI. The following commits move some definitions to UAPI,
> making them readily available to the user space.
> 
> Changes since v1[1]:
>  * Patch "provide fallback diagnostic codes in UAPI" is updated
>    in accordance with the updated set of diagnostic codes.
> 
> [1] https://lkml.org/lkml/2018/10/7/177
> 

Thanks Eugene, your patches look good. They will be part of our next SMC
patch submission for the net-next tree.

Regards, Ursula

> Eugene Syromiatnikov (3):
>   uapi, net/smc: move protocol constant definitions to UAPI
>   uapi, net/smc: provide fallback diagnostic codes in UAPI
>   uapi, net/smc: provide socket state constants in UAPI
> 
>  include/uapi/linux/smc.h      | 32 +++++++++++++++++++++++++++++++-
>  include/uapi/linux/smc_diag.h | 17 +++++++++++++++++
>  net/smc/smc.h                 | 22 ++--------------------
>  net/smc/smc_clc.h             | 22 ----------------------
>  4 files changed, 50 insertions(+), 43 deletions(-)
> 

