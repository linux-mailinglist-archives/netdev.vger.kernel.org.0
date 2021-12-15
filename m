Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA07476472
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 22:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhLOVR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 16:17:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhLOVR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 16:17:56 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFJEVtx014264;
        Wed, 15 Dec 2021 21:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=HrvX+MXvQbCBEOWN6sajnu0iKgVh+zmYO4w7V9uFkw4=;
 b=pNzx+N07KB9bzojCEDBkD59ZW2K+sGxBR9sUQ4+ELj2SbXiJ6Yf94dz56q3njqpLkvMG
 C2gioIrM2WjFIrFcFbqMiEXxgPKjwnZQ06mmXhWNsKj2y9Fssu6A3b7DDKnb/o2OuP7j
 /0koSskUTwAoIoUdjki2ZIa7D3m2gatIOhWOrY0b1vgzqvfKtLnRmp/vC7IdhCXn6bpu
 AGR0i0d1bpAMoB+DvLkX/MNM8vk3U2YCg6HbK8KRlCE7MmxoRYBzuL/kHCfnfaz3izyE
 leqcwPRi1RAiRDhVeBWlUB5F5Pk9F9JLou/8RcG9Jec3zQQVfwwuX27OKV6PxqG9jSZg rg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyfdp5bga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 21:17:55 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BFLC0xk011175;
        Wed, 15 Dec 2021 21:17:54 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3cy7fvrsvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 21:17:54 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BFLHrnv14287276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 21:17:53 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CA58BE04F;
        Wed, 15 Dec 2021 21:17:53 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3A17BE061;
        Wed, 15 Dec 2021 21:17:52 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.65.207.4])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with SMTP;
        Wed, 15 Dec 2021 21:17:52 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 04BEB2E0B34; Wed, 15 Dec 2021 13:17:51 -0800 (PST)
Date:   Wed, 15 Dec 2021 13:17:51 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, ricklind@linux.ibm.com,
        brking@linux.ibm.com, otis@otisroot.com
Subject: Re: [PATCH net 2/2] ibmvnic: remove unused defines
Message-ID: <YbpbfySAj3qtxIiR@us.ibm.com>
References: <20211214051748.511675-1-drt@linux.ibm.com>
 <20211214051748.511675-3-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214051748.511675-3-drt@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9wVzut9-3HG2B_s2J3Hq50G3OCnjLaJ6
X-Proofpoint-ORIG-GUID: 9wVzut9-3HG2B_s2J3Hq50G3OCnjLaJ6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_12,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=827 adultscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dany Madden [drt@linux.ibm.com] wrote:
> IBMVNIC_STATS_TIMEOUT and IBMVNIC_INIT_FAILED are not used in the driver.
> Remove them.
> 
> Suggested-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
