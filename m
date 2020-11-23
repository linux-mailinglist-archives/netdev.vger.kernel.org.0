Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287592C1497
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgKWTiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:38:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729407AbgKWTiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:38:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJW26d081731
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:38:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=clZnkPap0H686q1vybjpas8Sh9rwAnQTvrd4ac5LPIQ=;
 b=P8fkLWmZk1pPaLX6EDmpyzOOs4Ug7kUwyqxSixxlR7MlG1zJ7fQxTP/wS+rkLax+VHgH
 owvG38Wco/jdxxOGmppW5xN3M6xa839+4Z8OVHwYY09xxBoVNJhCGmELKEdOOJ3dhOEr
 Nl6zJbDFwENsFZyxpksiD8LtB7qbiORHV+R0nq+bWKilBQameiNvQHQKqoSAo5ioQWL7
 rv9JGigk2tO3aJcqeOuMNE6+6Qq//cRYqxl9yWSZvdjjMcv/oFO67+g+irfe4NNKixW6
 7jnimZkYFz6ioL8YFslZTVXf1wkymCm4E3Gw/ZDwge/VzY1X74C6nmK0DhVhlSZ6lq7J lg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fe716qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 14:38:13 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJb7R7024587
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:38:13 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 34xth9p41g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 19:38:12 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANJcCTr8454820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 19:38:12 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21151124052;
        Mon, 23 Nov 2020 19:38:12 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4F89124058;
        Mon, 23 Nov 2020 19:38:11 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 19:38:11 +0000 (GMT)
MIME-Version: 1.0
Date:   Mon, 23 Nov 2020 13:38:11 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 00/15] ibmvnic: assorted bug fixes
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
Message-ID: <319f8afadcd856037b1d83891f98db3d@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=645 mlxscore=0
 bulkscore=0 suspectscore=2 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 16:40, Lijun Pan wrote:
> Assorted fixes and improvements for ibmvnic bugs.
> 
> Dany Madden (9):
>   ibmvnic: handle inconsistent login with reset
>   ibmvnic: process HMC disable command
>   ibmvnic: stop free_all_rwi on failed reset
>   ibmvnic: remove free_all_rwi function
>   ibmvnic: avoid memset null scrq msgs
>   ibmvnic: restore adapter state on failed reset
>   ibmvnic: send_login should check for crq errors
>   ibmvnic: no reset timeout for 5 seconds after reset
>   ibmvnic: reduce wait for completion time
> 
> Lijun Pan (3):
>   ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
>   ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq
>   ibmvnic: enhance resetting status check during module exit
> 
> Sukadev Bhattiprolu (3):
>   ibmvnic: delay next reset if hard reset failed
>   ibmvnic: track pending login
>   ibmvnic: add some debugs
> 
>  drivers/net/ethernet/ibm/ibmvnic.c | 246 +++++++++++++++++++++--------
>  drivers/net/ethernet/ibm/ibmvnic.h |   9 +-
>  2 files changed, 183 insertions(+), 72 deletions(-)

In v2, we will split to 3 sets according to patch dependencies so that 
the
individual author can re-work on them during the coming holiday season.
1-11 as a set since they are dependent and most of them are Dany's 
patches
12-14 as a set since they are independent of 1-11.
15 to be sent to net-next.

Thanks,
Lijun
