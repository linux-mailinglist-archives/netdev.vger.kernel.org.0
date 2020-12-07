Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6942D16FB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgLGQ5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:57:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3202 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727571AbgLGQ5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:57:50 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GrdNu011199;
        Mon, 7 Dec 2020 11:57:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HMFRAhzaiMFPTWfeydjjuQNAu+WBamS/K1+H6UneyBU=;
 b=DTUE1NTNR32ZK3Ixzpmo3icN7sGEKcYUodUD3vdOttBbTmaOJGAZfrxKBAazbFeNs/o0
 6Xiuz93ium0LOVh3Ast8qo4do0sxd5h4zqhy+YURFhW2oc63d/L9Q2aPukfHUi1lBnri
 cfgFS2K8KX6VyC9sRhphm7cr6rs5sTqLAy7HY7Wvl/rjcdw/GjCQEi+Izssvl2bcaKIl
 5oUCdJjbEmH4ZFI+pevwkl/thpwqVFQoPJCo8QhhK53BEoDpH/YQpkHDh0JbIZIFwBbm
 J66mHCt+PUn9cmbprQSu1l03KzuZHCqffpVHWqlMbOwkIc2eWSGepIFQ+hEcvPxB3zCm BQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359qt0haad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 11:57:03 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GmYWX018557;
        Mon, 7 Dec 2020 16:57:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3581fhjpcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 16:57:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7Guxqs50725246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 16:56:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 295F4AE058;
        Mon,  7 Dec 2020 16:56:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4FD1AE059;
        Mon,  7 Dec 2020 16:56:58 +0000 (GMT)
Received: from [9.145.78.121] (unknown [9.145.78.121])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 16:56:58 +0000 (GMT)
Subject: Re: [PATCH net-next 0/6] s390/qeth: updates 2020-12-07
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
References: <20201207131233.90383-1-jwi@linux.ibm.com>
 <20201207.065713.357907127824978080.davem@davemloft.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <655a8aca-182b-1813-8293-b7e6be02ac09@linux.ibm.com>
Date:   Mon, 7 Dec 2020 17:56:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201207.065713.357907127824978080.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 bulkscore=0 mlxlogscore=959 priorityscore=1501
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012070102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.12.20 16:57, David Miller wrote:
> From: Julian Wiedmann <jwi@linux.ibm.com>
> Date: Mon,  7 Dec 2020 14:12:27 +0100
> 
>> Hi Jakub,
>>
>> please apply the following patch series for qeth to netdev's net-next tree.
>>
>> Some sysfs cleanups (with the prep work in ccwgroup acked by Heiko), and
>> a few improvements to the code that deals with async TX completion
>> notifications for IQD devices.
>>
>> This also brings the missing patch from the previous net-next submission.
> 
> Series applied, thanks Julian!
> 

Oh hey Dave, you're back on board? Excellent, glad to see you are feeling better!
