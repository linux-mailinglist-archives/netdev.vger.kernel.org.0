Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6BB3CD2BF
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbhGSKJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:09:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235471AbhGSKJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 06:09:07 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JAY2L0139884;
        Mon, 19 Jul 2021 06:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=3s2JWpUSsPWvJT/OE/9uZL68enwJwJUzJBo0mRP5fns=;
 b=NPtrN24F4RPuvTQl4RQqzULH/8iZcH3ZC6dsSxzoAPWt0togFdTlGB0xVl/eVrQlnkDK
 copGr1lzjLSfbWpyGAd+BCGgk493AryE2iH3+VN/NtC8hQhaibcblDAK4xn02fgPBMTv
 +EQOls+VTeGOZQbIM6l08Po8JnIaDN/z0zo7uawMtnOFNEo6rMZRSwJjCfm0lU1SEEvQ
 tQxU9EYYjXVCxLTL2Z1UNuyvjD3qyGRrQOdEXSdqv5DpXxexRhurQxR5gof6ZxhVacLF
 Ir3pI8g4i9g0sNADQrq0PfoIuO4Aqq8bX0vc/qnDoC4ApNeFjAF2f69VrGtM2awBo1AU hw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w6t0tf4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 06:49:44 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16JAmMKV026893;
        Mon, 19 Jul 2021 10:49:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 39upu88brs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 10:49:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16JAncUo11141444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 10:49:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA907A40A7;
        Mon, 19 Jul 2021 10:49:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D759A40A6;
        Mon, 19 Jul 2021 10:49:38 +0000 (GMT)
Received: from sig-9-145-44-27.uk.ibm.com (unknown [9.145.44.27])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jul 2021 10:49:38 +0000 (GMT)
Message-ID: <3d6005401d49c2a1f3303cf9aa3d672c0cb5ce74.camel@linux.ibm.com>
Subject: Re: Interface naming on v5.14-rc1 regressed, possible unintended
 revert of b28d8f0c25a9?
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Parav Pandit <parav@nvidia.com>,
        "David S.Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Date:   Mon, 19 Jul 2021 12:49:38 +0200
In-Reply-To: <PH0PR12MB54813D21F0F3338CD7764DE3DC149@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1a11d3079ef3f69627e6e5ef244448a704babae3.camel@linux.ibm.com>
         <PH0PR12MB54813D21F0F3338CD7764DE3DC149@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5jdVvz7VI31UWefUexTok1-W04MqcB4V
X-Proofpoint-ORIG-GUID: 5jdVvz7VI31UWefUexTok1-W04MqcB4V
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_03:2021-07-16,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1011 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-07-13 at 16:13 +0000, Parav Pandit wrote:
> Hi Niklas,
> 
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> > Sent: Tuesday, July 13, 2021 9:18 PM
> > 
> > Hi Parav, Hi Dave,
> > 
> > With v5.13 you added commit b28d8f0c25a9 ("devlink: Correct VIRTUAL port
> > to not have phys_port attributes") which changed the interface names of
> > VFs from e.g. ens2f0np0v0 to ens2f0v0. I did see that change for the v5.13-rc
> > cycle.
> > 
> > Now I just noticed that with v5.14-rc1 the old name is back. Looking at the
> > above commit and the code in v5.14-rc1 it looks to me like that commit was
> > partially reverted. In particular, the return of -EOPNOTSUPP from
> > __devlink_port_phys_port_name_get() in case of port flavour "virtual" is
> > gone while the part touching devlink_nl_port_attrs_put() seems to be there.
> > 
> > Now for some reason looking at git blame I still see the original commit
> > acf1ee44ca5da ("devlink: Introduce devlink port flavour
> > virtual") for the non removed lines. Could it be that somehow this got lost
> > while resolving a merge conflict?
> > 
> 
> Thanks for the bisecting and reporting.
> I searched further.
> I found that, it got introduced by below merge commit.
> but I haven’t yet found the patch that removed the return of -EOPNOTSUPP.
> 
> commit 126285651b7f95282a0afe3a1b0221419b31d989
> Merge: 9977d6f56bac 3822d0670c9d
> Author: David S. Miller <davem@davemloft.net>
> Date:   Mon Jun 7 13:01:52 2021 -0700
> 
>     Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net
> 
>     Bug fixes overlapping feature additions and refactoring, mostly.
> 
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Just a FYI, I still see interface names with '..np0' suffix on v5.14-
rc2. Any progress on tracking down what happened? Also I think I
accidentially used the wrong mail address for the netdev list before,
sorry about that.

