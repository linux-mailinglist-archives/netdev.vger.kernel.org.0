Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EABA2F202D
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391400AbhAKT6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:58:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390010AbhAKT6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:58:47 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BJX1cb133026;
        Mon, 11 Jan 2021 14:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=LWLftqYWvzHEhE6UjiOT4oECQtLOfv0Vua3tNLMLsUc=;
 b=Qiga//a3yYX/+vuTymFrzrIm3kxI0tE5wpNn4gmVuTchIhRy4OeykBjt/IlJuO3HzwC6
 n8REWYOL7CV1d0b7r+C/A42rk9OVeZbhy4o+JvfQv+fV2pnaNfE6P4WKs7MtCmnzv5cv
 OA2O+n4j4b5AnRwEMKysfXbFbCbNCdRaGnrzaypm98gQaGCg+rPjfxmZez6Hiwmm1iCP
 OcQiW7g8w6KwsyMRW0ktYDyMPfQReBeBJ8IfvmTsrWHT+wYcQU1PrA5PZy5v1HXkx571
 RXFniYFsEvGLMNw6OzCYUzQVxzZBdNpLg0AM/rqrowWM7PvwqGBK/tM7NGI2V49WVjV1 UQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360v70sxqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 14:58:05 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BJqAQ6008906;
        Mon, 11 Jan 2021 19:58:04 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 35y448ry9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 19:58:04 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BJw3di15925698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 19:58:03 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F9EABE054;
        Mon, 11 Jan 2021 19:58:03 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D3F3BE053;
        Mon, 11 Jan 2021 19:58:03 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.154.19])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 19:58:03 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 13B7A2E287F; Mon, 11 Jan 2021 11:57:59 -0800 (PST)
Date:   Mon, 11 Jan 2021 11:57:59 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 2/7] ibmvnic: update reset function prototypes
Message-ID: <20210111195759.GA178503@us.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
 <20210108071236.123769-3-sukadev@linux.ibm.com>
 <20210109193755.606a4aef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210111031221.GA165065@us.ibm.com>
 <20210111113249.1026433f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111113249.1026433f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_30:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Sun, 10 Jan 2021 19:12:21 -0800 Sukadev Bhattiprolu wrote:
> > Jakub Kicinski [kuba@kernel.org] wrote:
> > > On Thu,  7 Jan 2021 23:12:31 -0800 Sukadev Bhattiprolu wrote:  
> > > > The reset functions need just the 'reset reason' parameter and not
> > > > the ibmvnic_rwi list element. Update the functions so we can simplify
> > > > the handling of the ->rwi_list in a follow-on patch.
> > > > 
> > > > Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
> > > >   
> > > 
> > > No empty lines after Fixes tags, please. They should also not be
> > > wrapped.  
> > 
> > Ah ok, will fix.
> > >   
> > > > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>  
> > > 
> > > Are these patches for net or net-next? It looks like they are fixing
> > > races, but at the same time they are rather large. Can you please
> > > produce minimal fixes, e.g. patch 3 should just fix the existing leaks
> > > rather than refactor the code to not do allocations. 130+ LoC is a lot
> > > for a fix.  
> > 
> > This is a set of bug fixes, but yes a bit large. Should I submit to
> > net-next instead?
> 
> I'd rather you tried to address the problems with minimal patches, then
> you can refactor the code in net-next.

I had thought about that but fixing the leaks and then throwing away the
code did not seem very useful. The diff stat shows 78 insertions and 59
deletions. The bulk of the new code, about 70 lines including comments,
is just the fairly straightforward helper functions:

	- get_pending_reset()
	- add_pending_reset() 

Fixing the leak in the existing code would not reduce the size of these
helpers. We are now using a simpler approach with no allocations, so no
leaks.

Sukadev
