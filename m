Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC453FE1C8
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346777AbhIASIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:08:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346752AbhIASIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:08:39 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181I4C9V009785;
        Wed, 1 Sep 2021 14:07:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=BE8TENnMPSb4iD0H9C+s5VzH/Hh3lLCDZFNA2A4/Wzc=;
 b=E6MVr0gHICan/R7DN1mFcwxo0co6g/fyaHfbg2DtmrDOhlBCcGWhZbhAyGdSHelSA0qL
 3ZzOGUmq7ll/TcayhdU6Gw0C2kJo2x7gDPw5baEO9GbHLIS8K79zQ1tKScLclr8mk9IK
 v+BEZJFokKdK8CIsoRQZ4aPJx0W/MkfK9cg1DWmYG8NdcYm5liPEOlEEqmuDgF7tsH3r
 gxk1Z1TSDj/feH2VNnqB7HJiuo39s+6JoFeRie4IySZHpaDhOVaO3XfyXX1W3rzmWvs4
 6iM6Fpqfh1dUidiq89A+IIQtgwr0AqHemRa9qkIvUMt646gYBznHTuAleHoXhZa6O3Nc 5w== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3atbb36493-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 14:07:42 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181I43Rn023181;
        Wed, 1 Sep 2021 18:07:41 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 3atdxbgyav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 18:07:41 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181I7ep245875486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 18:07:40 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B9006E054;
        Wed,  1 Sep 2021 18:07:40 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A9176E052;
        Wed,  1 Sep 2021 18:07:39 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.160.152.143])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with SMTP;
        Wed,  1 Sep 2021 18:07:39 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 7AD832E1062; Wed,  1 Sep 2021 11:07:36 -0700 (PDT)
Date:   Wed, 1 Sep 2021 11:07:36 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 0/9] ibmvnic: Reuse ltb, rx, tx pools
Message-ID: <YS/BaCG0Aq1QQqx5@us.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210831193523.3929a265@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831193523.3929a265@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6tU9xsGYEDmcJ08B8XG_kRWzUVoGQJGS
X-Proofpoint-ORIG-GUID: 6tU9xsGYEDmcJ08B8XG_kRWzUVoGQJGS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 impostorscore=0
 mlxlogscore=842 clxscore=1015 phishscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2109010104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> 
> Please fix the kdoc issues in this submission. Kdoc script is your
> friend:
> 
> ./scripts/kernel-doc -none <files>

Yes, Thanks! I fixed them in v2

Sukadev
