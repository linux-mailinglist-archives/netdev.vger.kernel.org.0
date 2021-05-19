Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDC038873E
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhESGG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:06:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58738 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232402AbhESGG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 02:06:57 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J634BH127941;
        Wed, 19 May 2021 02:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=EUV0/p8Lz0Kv50ZMioZE56FcvKm0ymaIPCpGgQKVLU8=;
 b=p6Dd2pKdLkyfihHUGFLPJVJR0jqbFen7Xoaj1dGIwyu+JoNe8r0RkIo4SNYx98nO72ZP
 2BPlVIoyuz6DxTOHfBlQvXnIOcv8T5cHo/XhNtzdjrYqm9YIhEgKVjq6Xhvx+I9my+kx
 TMMUz7Ozhf3cXiU6eoS99Ryi5eDrC+RSboJ4U3vUvnfPS5GH3IcLbxFFEgEWLVfLa81W
 Eb3ZNJBPArze3LZn8EHFbbMy9y7WqhxjuiRGUVORQC2jmGhr8yKrwhbYX9hG1KqHDWVm
 0P2Nv/LU6siUeu6nb8sdhiA/utonX4ZRKqFkIpnxQONXrMViVNRDiAtj8CJEWBjNKSHA lw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mpbggcew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 02:05:29 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J645n4031052;
        Wed, 19 May 2021 06:05:29 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 38j5x9cq3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 06:05:29 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J64R9516777614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 06:04:27 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF0B96A051;
        Wed, 19 May 2021 06:04:27 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB8FD6A04D;
        Wed, 19 May 2021 06:04:26 +0000 (GMT)
Received: from [9.65.90.43] (unknown [9.65.90.43])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 19 May 2021 06:04:26 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 09/20] net: ibm: remove leading spaces before tabs
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <1621402253-27200-10-git-send-email-tanghui20@huawei.com>
Date:   Wed, 19 May 2021 01:04:25 -0500
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4DA295C-5DDE-4758-AD3F-90F2EE740054@linux.vnet.ibm.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
 <1621402253-27200-10-git-send-email-tanghui20@huawei.com>
To:     Hui Tang <tanghui20@huawei.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gT3corWUGNi2_YJIqiR7DtRdTxy80U06
X-Proofpoint-GUID: gT3corWUGNi2_YJIqiR7DtRdTxy80U06
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=752 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 12:30 AM, Hui Tang <tanghui20@huawei.com> wrote:
>=20
> There are a few leading spaces before tabs and remove it by running =
the
> following commard:
>=20
> 	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
> 	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'
> Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> =E2=80=94

Acked-by: Lijun Pan <lijunp213@gmail.com>

