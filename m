Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC392F0B65
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 04:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbhAKDNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 22:13:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbhAKDNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 22:13:08 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10B33Faw069119;
        Sun, 10 Jan 2021 22:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=lwaXgckAWdyhQ9Vdaz3A21YG69mLDvC3vE796b9G55c=;
 b=e9n/UFqLDVgocBuL7zL897+CGp85MvEyopkQ6LT3/HeK9i8pNn/e6Qpz8nGzhXmo/tp7
 1dsaj4nCBMvWmdVFLhV/D8K6io43Oq6tjjHAAh9bY+L/7xkJSpqAFzvGyXhMB7f8E4ym
 BtspyuBhLlbqR5aM4HoNLRsNvix1c5rEky+myvAwgyukteKhE1dVZlKB9lC94Xz6LNVc
 VxvEQuqOb1eZIjclEGIUexZrxxj1fwZ8ye/SLRjvFoN9zw4u186+Xlhzb7oruAJnENyV
 9+hUZBauBi903TuHZ4GoeQ16Eydr0g6YyS2P5AHCfmDgoTmlknIpvMMGUmBSGoUhw66U TQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360dd7s6rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 22:12:27 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10B3755U003003;
        Mon, 11 Jan 2021 03:12:26 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 35y448kuka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 03:12:25 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10B3CPLH12190158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 03:12:25 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ABE06E04C;
        Mon, 11 Jan 2021 03:12:25 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D007F6E050;
        Mon, 11 Jan 2021 03:12:24 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.203.51])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 03:12:24 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id A80482E2847; Sun, 10 Jan 2021 19:12:21 -0800 (PST)
Date:   Sun, 10 Jan 2021 19:12:21 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 2/7] ibmvnic: update reset function prototypes
Message-ID: <20210111031221.GA165065@us.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
 <20210108071236.123769-3-sukadev@linux.ibm.com>
 <20210109193755.606a4aef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109193755.606a4aef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Thu,  7 Jan 2021 23:12:31 -0800 Sukadev Bhattiprolu wrote:
> > The reset functions need just the 'reset reason' parameter and not
> > the ibmvnic_rwi list element. Update the functions so we can simplify
> > the handling of the ->rwi_list in a follow-on patch.
> > 
> > Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
> > 
> 
> No empty lines after Fixes tags, please. They should also not be
> wrapped.

Ah ok, will fix.
> 
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> Are these patches for net or net-next? It looks like they are fixing
> races, but at the same time they are rather large. Can you please
> produce minimal fixes, e.g. patch 3 should just fix the existing leaks
> rather than refactor the code to not do allocations. 130+ LoC is a lot
> for a fix.

This is a set of bug fixes, but yes a bit large. Should I submit to
net-next instead?

Thanks,

Sukadev
