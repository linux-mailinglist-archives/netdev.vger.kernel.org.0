Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE381C24B4
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 13:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEBLW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 07:22:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgEBLW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 07:22:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042B2Xh3184724;
        Sat, 2 May 2020 07:21:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s50wucma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 07:21:51 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 042BJ3Ks021250;
        Sat, 2 May 2020 07:21:51 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s50wuckr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 07:21:50 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042BKSVA012967;
        Sat, 2 May 2020 11:21:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5g8wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 11:21:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042BLkKJ53674396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 11:21:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB76411C050;
        Sat,  2 May 2020 11:21:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA28A11C04C;
        Sat,  2 May 2020 11:21:43 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.204.17])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat,  2 May 2020 11:21:43 +0000 (GMT)
Date:   Sat, 2 May 2020 14:21:41 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/14] docs: add IRQ documentation at the core-api book
Message-ID: <20200502112141.GE342687@linux.ibm.com>
References: <cover.1588345503.git.mchehab+huawei@kernel.org>
 <2da7485c3718e1442e6b4c2dd66857b776e8899b.1588345503.git.mchehab+huawei@kernel.org>
 <20200502074133.GC342687@linux.ibm.com>
 <20200502110438.1aad7d86@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502110438.1aad7d86@coco.lan>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1015 suspectscore=1 mlxlogscore=999 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 02, 2020 at 12:16:41PM +0200, Mauro Carvalho Chehab wrote:
> Em Sat, 2 May 2020 10:41:33 +0300
> Mike Rapoport <rppt@linux.ibm.com> escreveu:
> 
> > Hello Mauro,
> > 
> > On Fri, May 01, 2020 at 05:37:51PM +0200, Mauro Carvalho Chehab wrote:
> > > There are 4 IRQ documentation files under Documentation/*.txt.
> > > 
> > > Move them into a new directory (core-api/irq) and add a new
> > > index file for it.  
> > 
> > Just curious, why IRQ docs got their subdirectory and DMA didn't :)
> 
> Heh, you got me... :-)
> 
> The rationale I used is that DMA fits nicely being close to other 
> memory related documents.  As those currently don't have a subdir,
> I opted to not create a DMA-specific dir. I admit that his is a
> weak reason. I wouldn't mind placing them on a separate subdir,
> if you think it would be worth.

I'm Ok without a dir as well :)

> Thanks,
> Mauro

-- 
Sincerely yours,
Mike.
