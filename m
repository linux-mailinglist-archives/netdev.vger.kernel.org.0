Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1049B1890F
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEILfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:35:03 -0400
Received: from a3.inai.de ([88.198.85.195]:49240 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfEILfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 07:35:03 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2019 07:35:02 EDT
Received: by a3.inai.de (Postfix, from userid 25121)
        id 2ECF13BB8A93; Thu,  9 May 2019 13:29:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 276843BB6EF8;
        Thu,  9 May 2019 13:29:42 +0200 (CEST)
Date:   Thu, 9 May 2019 13:29:42 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH v2] netfilter: xt_owner: Add supplementary groups
 option
In-Reply-To: <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
Message-ID: <nycvar.YFH.7.76.1905091329090.1916@n3.vanv.qr>
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>        <20190508141211.4191-1-l.pawelczyk@samsung.com>        <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>        <cdba4a3b7f31ae8ece81be270233032fe774bd86.camel@samsung.com>
        <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>        <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>        <afc200a8-438f-5d73-2236-6d9e4979bb59@gmail.com> <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thursday 2019-05-09 12:47, Lukasz Pawelczyk wrote:
>> > > > > > index fa3ad84957d5..d646f0dc3466 100644
>> > > > > > --- a/include/uapi/linux/netfilter/xt_owner.h
>> > > > > > +++ b/include/uapi/linux/netfilter/xt_owner.h
>> > > > > > @@ -8,6 +8,7 @@ enum {
>> > > > > >  	XT_OWNER_UID    = 1 << 0,
>> > > > > >  	XT_OWNER_GID    = 1 << 1,
>> > > > > >  	XT_OWNER_SOCKET = 1 << 2,
>> > > > > > +	XT_SUPPL_GROUPS = 1 << 3,

In keeping with the naming, this should be something like
XT_OWNER_SUPPL_GROUPS.
