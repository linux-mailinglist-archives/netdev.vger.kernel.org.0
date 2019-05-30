Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D45303AC
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfE3U7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:59:13 -0400
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:41172 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726100AbfE3U7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:59:12 -0400
Received: from pps.filterd (m0049463.ppops.net [127.0.0.1])
        by m0049463.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x4UKnano004230;
        Thu, 30 May 2019 16:53:19 -0400
Received: from alpi155.enaf.aldc.att.com (sbcsmtp7.sbc.com [144.160.229.24])
        by m0049463.ppops.net-00191d01. with ESMTP id 2stpj6r2es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 May 2019 16:53:18 -0400
Received: from enaf.aldc.att.com (localhost [127.0.0.1])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x4UKrANv028175;
        Thu, 30 May 2019 16:53:11 -0400
Received: from zlp27129.vci.att.com (zlp27129.vci.att.com [135.66.87.42])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x4UKr8P6028126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 30 May 2019 16:53:09 -0400
Received: from zlp27129.vci.att.com (zlp27129.vci.att.com [127.0.0.1])
        by zlp27129.vci.att.com (Service) with ESMTP id 9C32140392B7;
        Thu, 30 May 2019 20:53:08 +0000 (GMT)
Received: from mlpi432.sfdc.sbc.com (unknown [144.151.223.11])
        by zlp27129.vci.att.com (Service) with ESMTP id 7D12F403929C;
        Thu, 30 May 2019 20:53:08 +0000 (GMT)
Received: from sfdc.sbc.com (localhost [127.0.0.1])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x4UKr8Ow008700;
        Thu, 30 May 2019 16:53:08 -0400
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x4UKr1iS008441;
        Thu, 30 May 2019 16:53:01 -0400
Received: from gwilkie-Precision-7520 (unknown [10.156.17.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.eng.vyatta.net (Postfix) with ESMTPSA id AF683360060;
        Thu, 30 May 2019 13:52:58 -0700 (PDT)
Date:   Thu, 30 May 2019 21:52:50 +0100
From:   George Wilkie <gwilkie@vyatta.att-mail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] vrf: local route leaking
Message-ID: <20190530205250.GA7379@gwilkie-Precision-7520>
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
 <20190525070924.GA1184@debian10.local>
 <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
 <20190527083402.GA7269@gwilkie-Precision-7520>
 <1f761acd-80eb-0e80-1cf4-181f8b327bd5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f761acd-80eb-0e80-1cf4-181f8b327bd5@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 09:29:22PM -0600, David Ahern wrote:
> you are correct that use of loopback here for default VRF does not work
> -- the lookup code gets confused because it is a forward path (as
> opposed to MPLS which is a local input). I found a couple of solutions
> that work for default VRF.
> 
> Again, using namespaces to demonstrate within a single node. This is the
> base setup:
> 
>  ip li add vrf-b up type vrf table 2
>  ip route add vrf vrf-b unreachable default
>  ip ru add pref 32765 from all lookup local
>  ip ru del pref 0
> 
>  ip netns add foo
>  ip li add veth1 type veth peer name veth11 netns foo
>  ip addr add dev veth1 10.200.1.1/24
>  ip li set veth1 vrf vrf-b up
>  ip -netns foo li set veth11 up
>  ip -netns foo addr add dev veth11 10.200.1.11/24
>  ip -netns foo ro add 10.200.2.0/24 via 10.200.1.1
> 
>  ip netns add bar
>  ip li add veth2 type veth peer name veth12 netns bar
>  ip li set veth2 up
>  ip addr add dev veth2 10.200.2.1/24
>  ip -netns bar li set veth12 up
>  ip -netns bar addr add dev veth12 10.200.2.12/24
> 
> Cross VRF routing can be done with a veth pair, without addresses:
> 
>  ip li add xvrf1 type veth peer name xvrf2
>  ip li set xvrf1 up
>  ip li set xvrf2 master vrf-b up
> 
>  ip ro add vrf vrf-b 10.200.2.0/24 dev xvrf2
>  ip ro add 10.200.1.0/24 dev vrf-b


This doesn't work for me (again, not using namespaces).
For traffic coming in on vrf-b to a destination on 10.200.2.0,
I see ARPs going out for the destination on xvrf2/in on xvrf1,
but nothing replies to it.

> 
> or with addresses:
> 
>  ip li add xvrf1 type veth peer name xvrf2
>  ip li set xvrf1 up
>  ip addr add dev xvrf1 10.200.3.1/30
>  ip li set xvrf2 master vrf-b up
>  ip addr add dev xvrf2 10.200.3.2/30
> 
>  ip ro add vrf vrf-b 10.200.2.0/24 via 10.200.3.1 dev xvrf2
>  ip ro add 10.200.1.0/24 via 10.200.3.2 dev xvrf1

Having to use additional addresses is not ideal.

However, there does seem to be an alternative approach which works.
If I create another vrf "vrfdefault" and associate it with table "local"
and use that to leak routes from global into a vrf, then it seems to
work for both v4 and v6.
Can reach both local and remote destinations
(which was somewhat surprising to me anyway).

 ip link add vrfdefault type vrf table local
 ip route add 10.10.4.0/24 vrf vrfA dev vrfdefault
 ip -6 route add 10:10:4::/64 vrf vrfA dev vrfdefault

Do you see any issue with relying on that?
Thx.
