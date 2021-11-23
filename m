Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8FD459E31
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhKWIhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:37:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233462AbhKWIhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:37:40 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN5kh6M014633;
        Tue, 23 Nov 2021 08:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ps01qata9MbN8kne8OfUcvfiiSPt20awUbZInBAaCoo=;
 b=V6I3l1nDuwuL3sN4st83N5cxmboArLt83NwJ5fXaoReSiVHfHvy6NhzaYrHW/A+QzJP3
 +x3KDt9DrWsqOd/j5RCBkV3maXRpUNkq4WBrbUY3KAqhr3+NTUqPxj7YZJTzGwADga1a
 MOCSFtvQebHP2XpjQKKvigfoiPdE1/uYnRsTkXpX0WWej6qvUIwdEkxohMeMIF4BLh47
 /GPnQ+TDpJejQKC8TZ7sQAu/zQzwJbNtuhTrz8J9ctX2EpQIFLs/8Y2t1ODm9M5yUp0D
 TUSWQD0oH3P2RLpQdV5B3GBqSvg7MIAYxsHiJoGFWrjebwGKJTWxCBukso1cUx5esBi+ gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgtexar77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 08:34:31 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AN7rZmx028875;
        Tue, 23 Nov 2021 08:34:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgtexar6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 08:34:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AN8SHpa028860;
        Tue, 23 Nov 2021 08:34:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3cern9mf9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 08:34:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AN8YP7p55509406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 08:34:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC504A406D;
        Tue, 23 Nov 2021 08:34:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77EF1A4062;
        Tue, 23 Nov 2021 08:34:25 +0000 (GMT)
Received: from [9.145.60.43] (unknown [9.145.60.43])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 08:34:25 +0000 (GMT)
Message-ID: <1f8e9b89-d177-4803-7cb1-b76d2590a115@linux.ibm.com>
Date:   Tue, 23 Nov 2021 09:34:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net 1/2] net/smc: Clean up local struct sock variables
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211123082515.65956-1-tonylu@linux.alibaba.com>
 <20211123082515.65956-2-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211123082515.65956-2-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x0qWfJeI1PNgXNbT7-l2B8uySvygZITg
X-Proofpoint-GUID: DX-ceXURJW39wzkApKKRJGeJmgfoaM1p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_02,2021-11-22_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 bulkscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2021 09:25, Tony Lu wrote:
> There remains some variables to replace with local struct sock. So clean
> them up all.
> 
> Fixes: 3163c5071f25 ("net/smc: use local struct sock variables consistently")
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> ---

This is a rather cosmetic change, I will pick it up for our next submission to the 
net-next tree.

Thank you.
