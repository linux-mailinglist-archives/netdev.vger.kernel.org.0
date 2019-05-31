Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FA730CB9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEaKja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 06:39:30 -0400
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:39714 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726280AbfEaKj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 06:39:29 -0400
Received: from pps.filterd (m0049462.ppops.net [127.0.0.1])
        by m0049462.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x4VAYZJL032248;
        Fri, 31 May 2019 06:38:58 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049462.ppops.net-00191d01. with ESMTP id 2stv6v6b3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 06:38:58 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4VAcvoS073478;
        Fri, 31 May 2019 05:38:57 -0500
Received: from zlp30495.vci.att.com (zlp30495.vci.att.com [135.46.181.158])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4VAcopY073376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 05:38:51 -0500
Received: from zlp30495.vci.att.com (zlp30495.vci.att.com [127.0.0.1])
        by zlp30495.vci.att.com (Service) with ESMTP id C76114009E80;
        Fri, 31 May 2019 10:38:50 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30495.vci.att.com (Service) with ESMTP id B3EE94009E66;
        Fri, 31 May 2019 10:38:50 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4VAcoE1041418;
        Fri, 31 May 2019 05:38:50 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4VAchx6041233;
        Fri, 31 May 2019 05:38:43 -0500
Received: from gwilkie-Precision-7520 (unknown [10.156.30.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.eng.vyatta.net (Postfix) with ESMTPSA id 8F48F360190;
        Fri, 31 May 2019 03:38:40 -0700 (PDT)
Date:   Fri, 31 May 2019 11:38:32 +0100
From:   George Wilkie <gwilkie@vyatta.att-mail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] vrf: local route leaking
Message-ID: <20190531103832.GA17076@gwilkie-Precision-7520>
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
 <20190525070924.GA1184@debian10.local>
 <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
 <20190527083402.GA7269@gwilkie-Precision-7520>
 <1f761acd-80eb-0e80-1cf4-181f8b327bd5@gmail.com>
 <20190530205250.GA7379@gwilkie-Precision-7520>
 <f0f4b5c8-0beb-6c97-34c8-f5b73ea426b8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0f4b5c8-0beb-6c97-34c8-f5b73ea426b8@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.0.1-1810050000 definitions=main-1905310069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 03:50:09PM -0600, David Ahern wrote:
> On 5/30/19 2:52 PM, George Wilkie wrote:
> > This doesn't work for me (again, not using namespaces).
> > For traffic coming in on vrf-b to a destination on 10.200.2.0,
> > I see ARPs going out for the destination on xvrf2/in on xvrf1,
> > but nothing replies to it.
> 
> Is rp_filter set?
> 

No, but arp_filter and arp_ignore was.
After setting net.ipv4.conf.all.arp_ignore=0 and
net.ipv4.conf.xvrf1.arp_filter=0 I can get ARP replies to the local address
but unsurprisingly not to the peer address.
So would only be able to leak the local /32 in this way,
and leak the /24 via the interface:
   sysctl net.ipv4.conf.all.arp_ignore=0
   ip li add xvrf1 type veth peer name xvrf2
   ip li set xvrf1 up
   ip li set xvrf2 master vrfA up
   sysctl net.ipv4.conf.xvrf1.arp_filter=0
   ip ro add vrf vrfA 10.10.3.0/24 dev enp1s3
   ip ro add vrf vrfA 10.10.3.2/32 dev xvrf2
   ip ro add 10.10.2.0/24 dev vrfA

It doesn't help for ipv6 though. No response to the neighbor solicitation.

What are your thoughts on creating a "vrfdefault" for "local" table?
   ip link add vrfdefault type vrf table local
   ip link set dev vrfdefault up
   ip ro add vrf vrfA 10.10.3.0/24 dev vrfdefault
   ip ro add 10.10.2.0/24 dev vrfA
   ip -6 ro add vrf vrfA 10:10:3::/64 dev vrfdefault
   ip -6 ro add 10:10:2::/64 dev vrfA

I'm able to reach local and peer addresses for both v4 and v6 with this
approach.

