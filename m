Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6619211592
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgGAWCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:02:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41184 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727778AbgGAWCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:02:21 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 01B8920111;
        Wed,  1 Jul 2020 22:02:21 +0000 (UTC)
Received: from us4-mdac16-20.at1.mdlocal (unknown [10.110.49.202])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F3AEA800AD;
        Wed,  1 Jul 2020 22:02:20 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.9])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D6D36100078;
        Wed,  1 Jul 2020 22:02:18 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8FCBF58009E;
        Wed,  1 Jul 2020 22:02:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 23:02:12 +0100
Subject: Re: [PATCH net-next] sfc: remove udp_tnl_has_port
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <mhabets@solarflare.com>, <linux-net-drivers@solarflare.com>
References: <20200630225038.1190589-1-kuba@kernel.org>
 <29d3564b-6bcc-9df7-f6a9-3d3867390e15@solarflare.com>
 <20200701114336.62b57cc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <7b38b929-bdbb-f54f-0242-34d80a86b54d@solarflare.com>
Date:   Wed, 1 Jul 2020 23:02:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200701114336.62b57cc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-6.137400-8.000000-10
X-TMASE-MatchedRID: oHOSwQSJZWjmLzc6AOD8DfHkpkyUphL9B4Id7CiQcz/wJYZa/L83HXSc
        G7HWVwYXhUTB8KvA9mLw+3D2CvtUZ7CIaxP0cx8mHbdv6Uke88CtfY6YPaw3YUkrZ4mFjTbDHM2
        5p8w5Q52FgsWpXAVfd5KMHqoRXiPlJFTEHHYFNqnC0TXpqtexIjyj3VMDmg2y4ilGqCIXmu3OuU
        Hq59sPQpHxgmyTvxaaqzdortUqk45+3MjV7YQcjVZ85UImhNtaNACXtweanwZsMPuLZB/IR8PTN
        U675EmHAdWX+YOlswkmrvubBBQyrvC7EcujoW6zimHWEC28pk0F49/U/gRHwL+Z3Zp2Td1E1ZvM
        nRa3QPK2ym8+XF7E6mxMnn7QGws9zyFwutRiXkvBLypRtAo4yEGaUEX8gnR8PAk/lMnjA2KEeES
        yuRtYoThHlW6CacmW5M+2FneJhThDyFDttIdo/FVeGWZmxN2Md0jERm7/xBKbKItl61J/yZkw8K
        dMzN86KrauXd3MZDWKM/X3itkL+/ugrH+mKG1/SpGp2xna9eZs5TGq0J49fKH/3xJjTupY
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.137400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593640940-Pzz5fRlIbLAi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2020 19:43, Jakub Kicinski wrote:
> There's a number of drivers which try to match the UDP ports. That
> seems fragile to me. Is it actually required for HW to operate
> correctly? 
For EF10 hardware, yes, because the hardware parses the packet headers
 to find for itself the offsets at which to make the various TSO edits;
 thus its parser needs to know which UDP ports correspond to VXLAN or
 GENEVE.  If a GSO skb arrives at the driver with skb->encapsulation
 set but on a UDP port that's not known to the hardware, the driver
 will have to reject it in ndo_features_check() or 'manually' fall back
 to software segmentation from the transmit path.
EF10 also makes use of encap parsing on receive, for CHECKSUM_UNNECESSARY
 offload (with CSUM_LEVEL) as well as RSS and filtering on inner headers
 (although there is currently no driver support for inner-frame RXNFC, as
 ethtool's API doesn't cover it).
> Aren't the ports per ns in the kernel? There's no guarantee that some
> other netns won't send a TSO skb and whatever other UDP encap.
That is indeed one of the flaws with port-based tunnel offloads; in
 theory the UDP port's scope is only the 3-tuple of the socket used by
 the tunnel device, so never mind netns, it would be logically valid to
 use the same port for different encap protocols on different IP
 addresses on the same network interface.
AFAICT udp_tunnel_notify_add_rx_port() gets a netns from the sock and
 then calls the ndo for every netdev in that ns.  So in a setup like
 that, the ndo would get called twice for the same port (without any IP
 address information other than sa_family being passed to the driver),
 the driver would ignore the second one (print a netif_dbg and return
 EEXIST, which the caller ignores), and any TSO skbs trying to use the
 second one would be parsed by the hardware with the wrong encap type
 and probably go out garbled on the wire.  I think at the time everyone
 took the position that "this is a really unlikely setup and if anybody
 really wants to do that they'll just have to turn off encap TSO".

So ndo_udp_tunnel_add is a fundamentally broken interface that people
 shouldn't design new hardware to support but it's close enough that it
 seems reasonable to use it to get _some_ encap TSO mileage out of the
 port-based hardware that already exists.  Agree/disagree/other?

-ed
