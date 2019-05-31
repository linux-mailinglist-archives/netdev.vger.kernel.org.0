Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF23131239
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfEaQWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:22:33 -0400
Received: from mail.us.es ([193.147.175.20]:45896 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbfEaQWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 12:22:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7E5FA80783
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 18:22:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F153DA70B
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 18:22:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 466B9DA715; Fri, 31 May 2019 18:22:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11A22DA781;
        Fri, 31 May 2019 18:22:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 18:22:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D27D04265A31;
        Fri, 31 May 2019 18:22:27 +0200 (CEST)
Date:   Fri, 31 May 2019 18:22:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com,
        Wensong Zhang <wensong@linux-vs.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v4] ipvs: add checksum support for gue encapsulation
Message-ID: <20190531162227.5mbbqqybn6jwausj@salvia>
References: <20190530001641.504-1-hengqing.hu@gmail.com>
 <alpine.LFD.2.21.1905301008470.4257@ja.home.ssi.bg>
 <20190531083741.dxsat27bnsy72wdv@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531083741.dxsat27bnsy72wdv@verge.net.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:37:41AM +0200, Simon Horman wrote:
> On Thu, May 30, 2019 at 10:10:15AM +0300, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Thu, 30 May 2019, Jacky Hu wrote:
> > 
> > > Add checksum support for gue encapsulation with the tun_flags parameter,
> > > which could be one of the values below:
> > > IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM
> > > IP_VS_TUNNEL_ENCAP_FLAG_CSUM
> > > IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM
> > > 
> > > Signed-off-by: Jacky Hu <hengqing.hu@gmail.com>
> > 
> > 	Looks good to me, thanks!
> > 
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> 
> Likewise, thanks.
> 
> Pablo, pleas consider applying this to nf-next.

Applied, thanks Simon.
