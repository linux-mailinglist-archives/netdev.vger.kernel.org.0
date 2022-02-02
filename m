Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4364A6C4C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 08:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbiBBH1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 02:27:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12492 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236259AbiBBH1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 02:27:05 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2126AUm7007360;
        Wed, 2 Feb 2022 07:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yT3X4c6tQ/1ef0u43R/g9DgpTmo2R3pXG5hCixEiG24=;
 b=VOER8oCNyE1kR1sp6tr+jWJSlbu8DKdYKgtMI+o2HsfzjBzppsyfDKzQnFGjIBV4KZxC
 bmyf2Z2B5lertHdu63YHe0FBuBHRHmsQX+B9O9X4HvZrwEtsUHOxB4aSVKPt021s4HcX
 gLaoDL9CFSR8fjQ5NrPrYuKBTks1hhxvK1MysG4Y7XU1fPwc2ZJhohQqmtAd1TP8MDq3
 uyPbaRvAKxBazM0Whp2ovwq+tRMaxZ8rqbxgV8iyu6Qh7J4y126IJ+mky8Ef5gtRNXOU
 yFPf7LKmjnq34KQ5etCDaYJ+/bhqi6o1wDrhvLR5zDco1lx8pmPewB/VyKU3vnp28G/u EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyjs6ag7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 07:26:59 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2126KLAt035461;
        Wed, 2 Feb 2022 07:26:58 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyjs6ag7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 07:26:58 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2127EPu1007318;
        Wed, 2 Feb 2022 07:26:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3dyaetb39y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 07:26:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2127Qs4141484622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Feb 2022 07:26:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 290C1A4040;
        Wed,  2 Feb 2022 07:26:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8EEFA404D;
        Wed,  2 Feb 2022 07:26:53 +0000 (GMT)
Received: from [9.145.78.145] (unknown [9.145.78.145])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Feb 2022 07:26:53 +0000 (GMT)
Message-ID: <4ace582e-8438-6e56-40d5-763309e93368@linux.ibm.com>
Date:   Wed, 2 Feb 2022 08:26:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] Partially revert "net/smc: Add netlink net namespace
 support"
Content-Language: en-US
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-api@vger.kernel.org
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
 <20211228130611.19124-3-tonylu@linux.alibaba.com>
 <20220131002453.GA7599@altlinux.org>
 <521e3f2a-8b00-43d4-b296-1253c351a3d2@linux.ibm.com>
 <20220202030904.GA9742@altlinux.org>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220202030904.GA9742@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7pihlwHkGGSJg5ItcXYpdQIcPhYadcLq
X-Proofpoint-ORIG-GUID: 2lBB1xK6qcEnycd-8iecEtDRiGiOqJkh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-02_02,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 priorityscore=1501 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202020035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2022 04:09, Dmitry V. Levin wrote:
> The change of sizeof(struct smc_diag_linkinfo) by commit 79d39fc503b4
> ("net/smc: Add netlink net namespace support") introduced an ABI
> regression: since struct smc_diag_lgrinfo contains an object of
> type "struct smc_diag_linkinfo", offset of all subsequent members
> of struct smc_diag_lgrinfo was changed by that change.
> 
> As result, applications compiled with the old version
> of struct smc_diag_linkinfo will receive garbage in
> struct smc_diag_lgrinfo.role if the kernel implements
> this new version of struct smc_diag_linkinfo.
> 
> Fix this regression by reverting the part of commit 79d39fc503b4 that
> changes struct smc_diag_linkinfo.  After all, there is SMC_GEN_NETLINK
> interface which is good enough, so there is probably no need to touch
> the smc_diag ABI in the first place.

Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>

Thank you Dmitry.
