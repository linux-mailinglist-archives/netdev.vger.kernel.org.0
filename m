Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E389D49C3C0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 07:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiAZGmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 01:42:17 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:33570 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbiAZGmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 01:42:16 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 386E22053D;
        Wed, 26 Jan 2022 07:42:15 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6pN4wTFA6_a1; Wed, 26 Jan 2022 07:42:14 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id BBB6520504;
        Wed, 26 Jan 2022 07:42:14 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id AC77380004A;
        Wed, 26 Jan 2022 07:42:14 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 26 Jan 2022 07:42:14 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 26 Jan
 2022 07:42:14 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 148E9318303F; Wed, 26 Jan 2022 07:42:14 +0100 (CET)
Date:   Wed, 26 Jan 2022 07:42:14 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jiri Bohac <jbohac@suse.cz>
CC:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Mike Maloney" <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: fix MTU regression
Message-ID: <20220126064214.GO1223722@gauss3.secunet.de>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
 <20220124154531.GM1223722@gauss3.secunet.de>
 <20220125094102.ju7bhuplcxnkyv4x@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220125094102.ju7bhuplcxnkyv4x@dwarf.suse.cz>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 10:41:02AM +0100, Jiri Bohac wrote:
> On Mon, Jan 24, 2022 at 04:45:31PM +0100, Steffen Klassert wrote:
> > > sure; I'll send a v2 with added Fixes: for the original
> > > regression (749439bf), which will reappear once b515d263 (which
> > > causes the current regression) is reverted. Note this patch needs
> > > to be accompanied by the revert!
> > > 
> > > > Btw. this fixes a xfrm issue, but touches only generic IPv6 code.
> > > > To which tree should this patch be applied? I can take it to
> > > > the ipsec tee, but would also be ok if it is applied directly
> > > > to the net tree.
> > > 
> > > b515d263 touches xfrm code; but being a regression maybe we want
> > > the fastest track possible? 
> > 
> > The patch is already marked as 'awaiting upstream' in patchwork,
> > so I'll take it into the ipsec tree.
> 
> OK, thanks! Will you also revert b515d263 in the ipsec tree?

You need to send a patch if you want to have this reverted.
