Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F5623D0C9
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgHETxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:53:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727792AbgHEQuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:50:21 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 075D3f36027833;
        Wed, 5 Aug 2020 09:21:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32qsqa6ygq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Aug 2020 09:21:50 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 075D3unD029305;
        Wed, 5 Aug 2020 09:21:50 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32qsqa6yfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Aug 2020 09:21:50 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 075DJiPI011757;
        Wed, 5 Aug 2020 13:21:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 32n0184dhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Aug 2020 13:21:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 075DLkTU25297218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Aug 2020 13:21:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AEE7A4054;
        Wed,  5 Aug 2020 13:21:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA130A405C;
        Wed,  5 Aug 2020 13:21:45 +0000 (GMT)
Received: from osiris (unknown [9.171.16.161])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  5 Aug 2020 13:21:45 +0000 (GMT)
Date:   Wed, 5 Aug 2020 15:21:44 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20200805132144.GA12227@osiris>
References: <20200805223121.7dec86de@canb.auug.org.au>
 <20200805150627.3351fe24@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805150627.3351fe24@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_09:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=1 impostorscore=0
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 03:06:27PM +0200, Stefano Brivio wrote:
> On Wed, 5 Aug 2020 22:31:21 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > After merging the net-next tree, today's linux-next build (s390 defconfig)
> > failed like this:
> > 
> > net/ipv4/ip_tunnel_core.c:335:2: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
> > 
> > Caused by commit
> > 
> >   4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
> 
> Ouch, sorry for that.
> 
> I'm getting a few of them by the way:
> 
> ---
> net/core/skbuff.o: In function `skb_checksum_setup_ipv6':
> /home/sbrivio/net-next/net/core/skbuff.c:4980: undefined reference to `csum_ipv6_magic'
> net/core/netpoll.o: In function `netpoll_send_udp':
> /home/sbrivio/net-next/net/core/netpoll.c:419: undefined reference to `csum_ipv6_magic'
> net/netfilter/utils.o: In function `nf_ip6_checksum':
> /home/sbrivio/net-next/net/netfilter/utils.c:74: undefined reference to `csum_ipv6_magic'
> /home/sbrivio/net-next/net/netfilter/utils.c:84: undefined reference to `csum_ipv6_magic'
> net/netfilter/utils.o: In function `nf_ip6_checksum_partial':
> /home/sbrivio/net-next/net/netfilter/utils.c:112: undefined reference to `csum_ipv6_magic'
> net/ipv4/ip_tunnel_core.o:/home/sbrivio/net-next/net/ipv4/ip_tunnel_core.c:335: more undefined references to `csum_ipv6_magic' follow
> ---
> 
> ...checking how it should be fixed now.
> 
> Heiko, by the way, do we want to provide a s390 version similar to the
> existing csum_partial() implementation in
> arch/s390/include/asm/checksum.h right away? Otherwise, I'll just take
> care of the ifdeffery.

You probably only need to include include/net/ip6_checksum.h which
contains the default implementation.

And yes, I put it on my todo list that we need to provide an s390
variant as well.
