Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4422278B5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgGUGO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:14:59 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35500 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGUGO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:14:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 666AC20265;
        Tue, 21 Jul 2020 08:14:56 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 94PZoZvLZkCG; Tue, 21 Jul 2020 08:14:55 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B8160201E2;
        Tue, 21 Jul 2020 08:14:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 21 Jul 2020 08:14:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 21 Jul
 2020 08:14:55 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E06AD31801E1;
 Tue, 21 Jul 2020 08:14:54 +0200 (CEST)
Date:   Tue, 21 Jul 2020 08:14:54 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Randy Dunlap <rdunlap@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>, <broonie@kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-next@vger.kernel.org>,
        <mhocko@suse.cz>, <mm-commits@vger.kernel.org>,
        <sfr@canb.auug.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Miller" <davem@davemloft.net>
Subject: Re: mmotm 2020-07-20-19-06 uploaded (net/ipv6/ip6_vti.o)
Message-ID: <20200721061454.GK20687@gauss3.secunet.de>
References: <20200721020722.6C7YAze1t%akpm@linux-foundation.org>
 <536c2421-7ae2-5657-ff31-fbd80bd71784@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <536c2421-7ae2-5657-ff31-fbd80bd71784@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 11:09:34PM -0700, Randy Dunlap wrote:
> On 7/20/20 7:07 PM, Andrew Morton wrote:
> > The mm-of-the-moment snapshot 2020-07-20-19-06 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> > You will need quilt to apply these patches to the latest Linus release (5.x
> > or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > http://ozlabs.org/~akpm/mmotm/series
> > 
> 
> 
> on i386:
> 
> ld: net/ipv6/ip6_vti.o: in function `vti6_rcv_tunnel':
> ip6_vti.c:(.text+0x2d11): undefined reference to `xfrm6_tunnel_spi_lookup'

Thanks for the report!

I've applied a fix to ipsec-next just a minute ago.
