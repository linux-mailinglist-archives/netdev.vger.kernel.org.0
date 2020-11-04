Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D182A6FFC
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbgKDV4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:56:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732029AbgKDV4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 16:56:14 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4LZ2PR175696;
        Wed, 4 Nov 2020 16:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ep2rRyDc7Zq5d7vmFUX63pFTB/BZNMOT3iYGDvkLK98=;
 b=M7b8jh/pGRmYkAIK96cP5hWKCP79blDXH5mZ4wdFpfQkrHqdJ3/PxbhgwEMJzellzOjr
 Y11yNIEH6OeHq1ciMoXapLUI5h5EQP+eVTk2z9Pg1JGTLiTCXxr5SqREuI+DX7e5lYH7
 ZbDtVuW1SbStQCiod2sHTXUlgIkRHT4iRNSvM6Qd7qRFmHDVD7Dw2DUsLM3aznEw79zQ
 SMxXO7+xhTq5DLl5DSbqYaUzafXIMmzJx/bEm2hOv2pnVREUWfQ6R6RH5KbGH5MqbtsK
 c9IL4KONO35ajyOWOkd2i08jG8i2r+rBk876Jh8w0SjGRu50oE8SM5CfCdYdtx8380M5 bg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m47x0j6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 16:56:12 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A4Lm0CZ017180;
        Wed, 4 Nov 2020 21:56:11 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 34h02m47v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 21:56:11 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A4Lu4Bi34931428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Nov 2020 21:56:04 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43EFDC6055;
        Wed,  4 Nov 2020 21:56:10 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12300C6057;
        Wed,  4 Nov 2020 21:56:09 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  4 Nov 2020 21:56:09 +0000 (GMT)
MIME-Version: 1.0
Date:   Wed, 04 Nov 2020 13:56:09 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: merge do_change_param_reset into
 do_reset
In-Reply-To: <20201103150915.4411306e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201031094645.17255-1-ljp@linux.ibm.com>
 <20201103150915.4411306e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <63365b7e683e2c3b1b8e41c51668b401@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_15:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-03 15:09, Jakub Kicinski wrote:
> On Sat, 31 Oct 2020 04:46:45 -0500 Lijun Pan wrote:
>> Commit b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so
>> linkwatch_event can run") introduced do_change_param_reset function to
>> solve the rtnl lock issue. Majority of the code in 
>> do_change_param_reset
>> duplicates do_reset. Also, we can handle the rtnl lock issue in 
>> do_reset
>> itself. Hence merge do_change_param_reset back into do_reset to clean 
>> up
>> the code.
>> 
>> Fixes: b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so 
>> linkwatch_event can run")
>> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> 
> Applied, thanks!

Hi Jakub,

Thank you for applying this patch so promptly. However, I would like to 
ask that this patch be withdrawn.

1. It needs more time in testing.
2. There are a number of bug fix patches being tested. This patch would 
require rework of those patches.
3. As the lead maintainer for ibmvnic, I failed to communicate this to 
Lijun. I will do better going forward.

Please revert this commit. We will resubmit this patch later.

I sincerely apologize for any trouble this may have caused.

Regards,
Dany
