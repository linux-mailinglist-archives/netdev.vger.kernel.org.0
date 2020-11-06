Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8153D2A96F8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 14:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgKFNZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 08:25:26 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:52068 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbgKFNZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 08:25:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D327C201CA;
        Fri,  6 Nov 2020 14:25:23 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uu67ucs3-TKt; Fri,  6 Nov 2020 14:25:23 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 53C6C2006F;
        Fri,  6 Nov 2020 14:25:23 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 6 Nov 2020 14:25:23 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 6 Nov 2020
 14:25:23 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 324DB31844B7;
 Fri,  6 Nov 2020 14:25:23 +0100 (CET)
Date:   Fri, 6 Nov 2020 14:25:23 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Allen Pais <allen.lkml@gmail.com>, <davem@davemloft.net>,
        <gerrit@erg.abdn.ac.uk>, <edumazet@google.com>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <johannes@sipsolutions.net>, <alex.aring@gmail.com>,
        <stefan@datenfreihafen.org>, <santosh.shilimkar@oracle.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [net-next v4 8/8] net: xfrm: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20201106132523.GT26422@gauss3.secunet.de>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
 <20201103091823.586717-9-allen.lkml@gmail.com>
 <20201105164818.402a2cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201105164818.402a2cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 04:48:18PM -0800, Jakub Kicinski wrote:
> On Tue,  3 Nov 2020 14:48:23 +0530 Allen Pais wrote:
> > From: Allen Pais <apais@linux.microsoft.com>
> > 
> > In preparation for unconditionally passing the
> > struct tasklet_struct pointer to all tasklet
> > callbacks, switch to using the new tasklet_setup()
> > and from_tasklet() to pass the tasklet pointer explicitly.
> > 
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> 
> Steffen - ack for applying this to net-next?

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
