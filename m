Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6243116C8
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 12:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfEBKAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 06:00:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38662 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfEBKAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 06:00:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x429nQnd031052;
        Thu, 2 May 2019 10:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2018-07-02;
 bh=5XZpXGg1zw174XLID8DL9ihSlBko1OHGz7AWUph4B1M=;
 b=YB1XPWcuG7eeSwJ+Etz2AhALHfOlwcEjxOXhO6ySmli6v36tQIjyMQOyi92qZxN8RpAI
 xJgKJE5MSrUFrLvJ64vEouvVL6keUbgpvUWYfGqTBLoJexGQlbutXt/M9ZE2hez5HZsr
 55rC5XHWy0QExVg4t9ruKIxOtg5EdFwBk6Y6kzH196asZZHgy8jXMRevsniH4I1/wOBL
 2dsomTft0osg00gvbM3iZzSSLrmWdWi5hl6EIplqgT8aP6Zzn25jo/Dz9aGhTZXz2VuN
 NvsWkD3nFf66a07gBDgTz1g5KRcpTQeksUYttn4g08588lH4fOIT72C1WA02zoellEd4 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2s6xhyffhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 10:00:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x429wpTs185709;
        Thu, 2 May 2019 10:00:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2s6xhgqcgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 10:00:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x42A0Bta004877;
        Thu, 2 May 2019 10:00:11 GMT
Received: from dhcp-10-175-160-224.vpn.oracle.com (/10.175.160.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 May 2019 03:00:11 -0700
Date:   Thu, 2 May 2019 11:00:07 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-160-224.vpn.oracle.com
To:     David Ahern <dsahern@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, netdev@vger.kernel.org,
        daniel@iogearbox.net, Ian Kumlien <ian.kumlien@gmail.com>
Subject: Re: MPLS encapsulation and arp table overflow
In-Reply-To: <876582ab-2b8c-7e46-7795-236c0ef6d90d@gmail.com>
Message-ID: <alpine.LRH.2.20.1905021055490.5146@dhcp-10-175-160-224.vpn.oracle.com>
References: <alpine.LRH.2.20.1905011655100.1124@dhcp-10-175-212-223.vpn.oracle.com> <876582ab-2b8c-7e46-7795-236c0ef6d90d@gmail.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905020074
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905020074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 May 2019, David Ahern wrote:

> On 5/1/19 10:03 AM, Alan Maguire wrote:
> > I'm seeing the following repeated error
> > 
> > [  130.821362] neighbour: arp_cache: neighbor table overflow!
> > 
> > when using MPLSoverGRE or MPLSoverUDP tunnels on bits synced
> > with bpf-next as of this morning. The test script below reliably
> > reproduces the problem, while working fine on a 4.14 (I haven't
> > bisected yet). It can be run with no arguments, or specifying
> > gre or udp for the specific encap type.
> > 
> > It seems that every MPLS-encapsulated outbound packet is attempting
> > to add  a neighbor entry, and as a result we hit the 
> > net.ipv4.neigh.default.gc_thresh3 limit quickly.
> > 
> > When this failure occurs, the arp table doesn't show any of
> > these additional entries. Existing arp table entries are
> > disappearing too, so perhaps they are being recycled when the
> > table becomes full?
> > 
> 
> There are 2 bugs:
> 1. neigh_xmit fails to find a neighbor entry on every single Tx. This
> was introduced by:
> 
> cd9ff4de010 ("ipv4: Make neigh lookup keys for loopback/point-to-point
> devices be INADDR_ANY")
> 
> Basically, the primary_key is reset to 0 for tun's but the neigh_xmit
> lookup was not corrected.
> 
> That caused a new neigh entry to be created on each packet Tx, but
> before inserting the new one to the table the create function looks to
> see if an entry already exists. The arp constructor had reset the key to
> 0 in the new neighbor entry so the second lookup finds a match and the
> new one is dropped.
> 
> That exposed a second bug.
> 
> 2. neigh_alloc bumps the gc_entries counter when a new one is allocated,
> but ___neigh_create is not dropping the counter in the error path.
> 
> Ian reported a similar problem, but we were not able to isolate the cause.
>

Fantastic, thanks so much for the quick fixes! I verified them at my
end, ensuring that with the patches applied to the latest net tree,
the previously-failing test succeeds.
 
> Thanks for the script - very helpful in resolving the bugs. I made some
> changes to it and I plan to submit it to selftests as a starter for mpls
> tests.
> 

Sounds great! It's mostly cobbled together from Willem's
bpf test_tc_tunnel.sh script, so like that could probably be
generalized to cover more tunnel types too.

Thanks again!

Alan

> Bug fix patches coming.
> 
