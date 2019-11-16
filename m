Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747E7FF3F4
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKPQhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:37:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65318 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727579AbfKPQhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 11:37:51 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAGGahT3036216
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:37:50 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wact3u74d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:37:50 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Sat, 16 Nov 2019 16:37:48 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 16 Nov 2019 16:37:46 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAGGbi3n51445986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Nov 2019 16:37:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8A3952054;
        Sat, 16 Nov 2019 16:37:44 +0000 (GMT)
Received: from [9.145.75.73] (unknown [9.145.75.73])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8728652050;
        Sat, 16 Nov 2019 16:37:44 +0000 (GMT)
Subject: Re: [PATCH net-next 0/8] net/smc: improve termination handling (part
 3)
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
References: <20191114120247.68889-1-kgraul@linux.ibm.com>
 <20191115.123014.497961657029798608.davem@davemloft.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Sat, 16 Nov 2019 17:37:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191115.123014.497961657029798608.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111616-0008-0000-0000-000003303066
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111616-0009-0000-0000-00004A4F45E9
Message-Id: <59756a0d-d0c3-8e9a-a586-ca55fb092baf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-16_05:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=853 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911160154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/11/2019 21:30, David Miller wrote:
> From: Karsten Graul <kgraul@linux.ibm.com>
> Date: Thu, 14 Nov 2019 13:02:39 +0100
> 
>> Part 3 of the SMC termination patches improves the link group
>> termination processing and introduces the ability to immediately
>> terminate a link group.
> 
> Series applied, thanks.
> 
> I wonder if you need an explicit ATOMIC_INIT() for that new atomic_t you
> add to the data structures?

I will discuss this question with Ursula next week, thanks for pointing it out.

> 

-- 
Karsten

