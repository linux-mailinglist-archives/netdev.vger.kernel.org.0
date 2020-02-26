Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B35F16F99E
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgBZIde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:33:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726425AbgBZIde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:33:34 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8SsCx125781
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 03:33:33 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydcntdsh1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 03:33:32 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Wed, 26 Feb 2020 08:33:30 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 08:33:28 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01Q8XRZt52953304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:33:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59BCE11C04A;
        Wed, 26 Feb 2020 08:33:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 157AD11C054;
        Wed, 26 Feb 2020 08:33:27 +0000 (GMT)
Received: from [9.145.0.34] (unknown [9.145.0.34])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 08:33:26 +0000 (GMT)
Subject: Re: [PATCH net-next v2 0/2] net/smc: improve peer ID in CLC decline
To:     Hans Wippel <ndev@hwipl.net>, ubraun@linux.ibm.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200225214122.335292-1-ndev@hwipl.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Wed, 26 Feb 2020 09:33:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225214122.335292-1-ndev@hwipl.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022608-0012-0000-0000-0000038A5D95
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022608-0013-0000-0000-000021C702A5
Message-Id: <cd02abb7-7175-8603-0c1c-f5916feb464e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_02:2020-02-25,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 mlxlogscore=811 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260064
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Acked-by: Karsten Graul <kgraul@linux.ibm.com>


On 25/02/2020 22:41, Hans Wippel wrote:
> The following two patches improve the peer ID in CLC decline messages if
> RoCE devices are present in the host but no suitable device is found for
> a connection. The first patch reworks the peer ID initialization. The
> second patch contains the actual changes of the CLC decline messages.
> 
> Changes v1 -> v2:
> * make smc_ib_is_valid_local_systemid() static in first patch
> * changed if in smc_clc_send_decline() to remove curly braces
> 
> Changes RFC -> v1:
> * split the patch into two parts
> * removed zero assignment to global variable (thanks Leon)
> 
> Thanks to Leon Romanovsky and Karsten Graul for the feedback!
> 
> Hans Wippel (2):
>   net/smc: rework peer ID handling
>   net/smc: improve peer ID in CLC decline for SMC-R
> 
>  net/smc/smc_clc.c |  3 ++-
>  net/smc/smc_ib.c  | 19 ++++++++++++-------
>  net/smc/smc_ib.h  |  1 +
>  3 files changed, 15 insertions(+), 8 deletions(-)
> 

-- 
Karsten

(I'm a dude)

