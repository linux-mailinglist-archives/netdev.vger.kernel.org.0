Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7812BC8C0
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 20:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgKVTaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 14:30:16 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:45261 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbgKVTaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 14:30:15 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CfL373H6dz3qvnM;
        Sun, 22 Nov 2020 20:30:11 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CfL305RcZz2TTLX;
        Sun, 22 Nov 2020 20:30:04 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.21) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 22 Nov
 2020 20:29:23 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] mlxsw: spectrum_ptp: use PTP wide message type definitions
Date:   Sun, 22 Nov 2020 20:29:22 +0100
Message-ID: <2074851.ybSLjXPktx@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201122143555.GA515025@shredder.lan>
References: <20201122082636.12451-1-ceggers@arri.de> <20201122082636.12451-3-ceggers@arri.de> <20201122143555.GA515025@shredder.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.21]
X-RMX-ID: 20201122-203004-4CfL305RcZz2TTLX-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, 22 November 2020, 15:35:55 CET, Ido Schimmel wrote:
> On Sun, Nov 22, 2020 at 09:26:35AM +0100, Christian Eggers wrote:
> > Use recently introduced PTP wide defines instead of a driver internal
> > enumeration.
> > 
> > Signed-off-by: Christian Eggers <ceggers@gmx.de>
> > Cc: Petr Machata <petrm@mellanox.com>
> > Cc: Jiri Pirko <jiri@nvidia.com>
> > Cc: Ido Schimmel <idosch@nvidia.com>
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> 
> But:
> 
> 1. Checkpatch complains about:
> WARNING: From:/Signed-off-by: email address mismatch: 'From: Christian
> Eggers <ceggers@arri.de>' != 'Signed-off-by: Christian Eggers
> <ceggers@gmx.de>'
unfortunately I changed this after running checkpatch. My intention was to 
separate my (private) weekend work from the patches I do while I'm on the job.

> 2. This series does not build, which fails the CI [1][2] and also
> required me to fetch the dependencies that are currently under review
> [3]. I believe it is generally discouraged to create dependencies
> between patch sets that are under review for exactly these reasons. 
this was also not by intention. Vladimir found some files I missed in the
first series. As the whole first series had already been reviewed at that time,
I wasn't sure whether I am allowed to add further patches to it. Additionally
I didn't concern that although my local build is successful, I should wait
until the first series is applied...

> I don't know what are Jakub's preferences, but had this happened on our
> internal patchwork instance, I would just ask the author to submit
> another version with all the patches.
Please let me know how I shall proceed...

> Anyway, I added all six patches to our regression as we have some PTP
> tests. Will let you know tomorrow.
> 
> Thanks
> 
> [1]
> https://lore.kernel.org/netdev/20201122082636.12451-1-ceggers@arri.de/T/#mc
> ef35858585d23b72b8f75450a51618d5c5d3260 [2]
> https://patchwork.hopto.org/static/nipa/389053/11923809/build_allmodconfig_
> warn/summary [3]
> https://patchwork.kernel.org/project/netdevbpf/cover/20201120084106.10046-1
> -ceggers@arri.de/




