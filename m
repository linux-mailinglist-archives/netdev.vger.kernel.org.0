Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCE234E9E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfFDRV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:21:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFDRV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:21:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54HIK6e041685;
        Tue, 4 Jun 2019 17:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2018-07-02;
 bh=HCaMBzaHqLDd6VrCHLaNxl+UWnBBKBAImvCfac3RBf8=;
 b=mjcvZy426gCnIYuO62xISvRaKv9nt8/egtmrgljFlGpUTahiCuRENmQwQKGKj/EvU4lD
 R5gQaniAl9esqCD2DEm3q2DUnDisxal0q45MqbtCZmZX2YBLu6BV7gN7wP9P2YsdVPBD
 uok9ubVJMAhDF6t7xGsKCY2354Rdio+it1w9JqdY9XzWEk4obU1W0fh4Vd9gjewzTi5J
 I2bn1Q3GOMFcT+kMkwBtRHSG1vJEwyawx/Zr8SjqKRp6TMF6hcBSdHiJGo4Dm54PQnHQ
 PvwUZAP9RoKKmy4O7Uvq79al4yxVSPrB/ZTcE70Yfujc1t4HWmHEhczZi8+Xi4XOi85U nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2suj0qebsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 17:21:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54HKaTU138210;
        Tue, 4 Jun 2019 17:21:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2swnhbqk73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 17:21:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54HLLYg009690;
        Tue, 4 Jun 2019 17:21:21 GMT
Received: from dhcp-10-175-213-181.vpn.oracle.com (/10.175.213.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 10:21:20 -0700
Date:   Tue, 4 Jun 2019 18:21:13 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-213-181.vpn.oracle.com
To:     David Ahern <dsahern@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, netdev@vger.kernel.org
Subject: Re: support for popping multiple MPLS labels with iproute2?
In-Reply-To: <b1455c03-d98c-c08b-a6f3-330d9f36d8be@gmail.com>
Message-ID: <alpine.LRH.2.20.1906041819440.7085@dhcp-10-175-213-181.vpn.oracle.com>
References: <alpine.LRH.2.20.1905311313080.9247@dhcp-10-175-206-186.vpn.oracle.com> <b1455c03-d98c-c08b-a6f3-330d9f36d8be@gmail.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019, David Ahern wrote:

> On 5/31/19 6:24 AM, Alan Maguire wrote:
> > I was wondering if there is a way to pop multiple MPLS labels at
> > once for local delivery using iproute2?
> > 
> > Adding multiple labels for encapsulation is supported via
> > label1/label2/... syntax, but I can't find a way to do the same
> > for popping multiple labels for local delivery.
> > 
> > For example if I run
> > 
> > # ip route add 192.168.1.0/24 encap mpls 100/200 via inet 192.168.1.101 \
> >    dev mytun mtu 1450
> > 
> > ...I'm looking for the equivalent command to pop both labels on the
> > target system for local delivery; something like
> > 
> > # ip -f mpls route add 100/200 dev lo
> > 
> > ...but that gets rejected as only a single label is expected.
> > 
> 
> as I recall the kernel driver only pops one and does a look for it.
> 
> Try:
> 
> ip -f mpls route add 100 dev lo
> ip -f mpls route add 200 dev lo
> 

That worked perfectly (once I remembered to run

sysctl -w net.ipv4.conf.lo.accept_local=1

...as well as on the tunnel). Thanks again!

Alan
