Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E1A30A70
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfEaIhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:37:47 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41224 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaIhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 04:37:46 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id D0BED25AE77;
        Fri, 31 May 2019 18:37:43 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id C0941940461; Fri, 31 May 2019 10:37:41 +0200 (CEST)
Date:   Fri, 31 May 2019 10:37:41 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jacky Hu <hengqing.hu@gmail.com>, jacky.hu@walmart.com,
        jason.niesz@walmart.com, Wensong Zhang <wensong@linux-vs.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v4] ipvs: add checksum support for gue encapsulation
Message-ID: <20190531083741.dxsat27bnsy72wdv@verge.net.au>
References: <20190530001641.504-1-hengqing.hu@gmail.com>
 <alpine.LFD.2.21.1905301008470.4257@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1905301008470.4257@ja.home.ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:10:15AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 30 May 2019, Jacky Hu wrote:
> 
> > Add checksum support for gue encapsulation with the tun_flags parameter,
> > which could be one of the values below:
> > IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM
> > IP_VS_TUNNEL_ENCAP_FLAG_CSUM
> > IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM
> > 
> > Signed-off-by: Jacky Hu <hengqing.hu@gmail.com>
> 
> 	Looks good to me, thanks!
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Likewise, thanks.

Pablo, pleas consider applying this to nf-next.

Signed-off-by: Simon Horman <horms@verge.net.au>
