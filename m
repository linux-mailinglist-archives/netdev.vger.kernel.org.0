Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DB52CC331
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbgLBROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:14:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16936 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbgLBROK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:14:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2H4whL062017;
        Wed, 2 Dec 2020 12:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0H2V1uDjEplQbB3pXgQHeoAFLdGws8lRhW4VbogIoR0=;
 b=Txdfj6ET+WszriMirFy8YPK7IiELBXZti8bzOjVzR/JUTrNth02H0/AWjVEcJCRJrBrV
 cSNsxM1pud77k+RO7wfwXJeyYUdW93e0cEZvHj7YDZDTmjR3XpQQDu5bt96pZWVZgu5i
 UedxgDa6FRC9LPqx2synDtIWRD3ssRmIhPUoCd9JrnmUOpRVg8o8qXCypnGBwW38u1o3
 blKNupkyJx3Gzoj6C+W3C5x/mxY0AzitwGqqf6Q75ESFpquSsudGWqpLwHkrvSYDtrU3
 rk9KkDxYP9U/YzXv5AF2uZDpm9GrvR5WbarbXr3XwYy/3PepLAUeUPxkPJBxuiVq9JVx Mg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355k19nxn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 12:13:21 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2HCgNK002941;
        Wed, 2 Dec 2020 17:13:18 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 353e69jkhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 17:13:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2HDID011862592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 17:13:18 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0123112063;
        Wed,  2 Dec 2020 17:13:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B676112062;
        Wed,  2 Dec 2020 17:13:17 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.222.207])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 17:13:17 +0000 (GMT)
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Dwip N. Banerjee" <dnbanerg@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20201202122009.0fe25caf@canb.auug.org.au>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <0f612db3-9ac8-0e8d-0437-5cc1243db326@linux.ibm.com>
Date:   Wed, 2 Dec 2020 11:13:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201202122009.0fe25caf@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20 7:20 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>    drivers/net/ethernet/ibm/ibmvnic.c
>
> between commit:
>
>    b71ec9522346 ("ibmvnic: Ensure that SCRQ entry reads are correctly ordered")
>
> from the net tree and commit:
>
>    ec20f36bb41a ("ibmvnic: Correctly re-enable interrupts in NAPI polling routine")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
Hi, Stephen, thank you for fixing that conflict. Sorry for the 
inconvenience.
