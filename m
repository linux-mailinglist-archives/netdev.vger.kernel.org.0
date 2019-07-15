Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732926851D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 10:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfGOI05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 04:26:57 -0400
Received: from mail.us.es ([193.147.175.20]:56148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbfGOI05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 04:26:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B63311031F4
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 10:26:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6920DA4D1
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 10:26:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 947231150DF; Mon, 15 Jul 2019 10:26:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74EE1DA704;
        Mon, 15 Jul 2019 10:26:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jul 2019 10:26:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 443C44265A2F;
        Mon, 15 Jul 2019 10:26:53 +0200 (CEST)
Date:   Mon, 15 Jul 2019 10:26:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     yangxingwu <xingwu.yang@gmail.com>
Cc:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH] ipvs: remove unnecessary space
Message-ID: <20190715082652.nwwugofsnaihlrjg@salvia>
References: <80a4e132f3be48899904eccdc023f5c53229840b.camel@perches.com>
 <20190712130721.7168-1-xingwu.yang@gmail.com>
 <20190715075703.ak6nk3sbnqksjh72@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715075703.ak6nk3sbnqksjh72@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 09:57:03AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 12, 2019 at 09:07:21PM +0800, yangxingwu wrote:
> > this patch removes the extra space and use bitmap_zalloc instead
> > 
> > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> > ---
> >  net/netfilter/ipvs/ip_vs_mh.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
> > index 94d9d34..3229867 100644
> > --- a/net/netfilter/ipvs/ip_vs_mh.c
> > +++ b/net/netfilter/ipvs/ip_vs_mh.c
> > @@ -174,8 +174,7 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
> >  		return 0;
> >  	}
> >  
> > -	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > -			 sizeof(unsigned long), GFP_KERNEL);
> > +	table = bitmap_zalloc(IP_VS_MH_TAB_SIZE, GFP_KERNEL);
> 
> By doing:
> 
>         git grep "=  " ...
> 
> on the netfilter folders, I see more of these, it would be good if you
> fix them at once or, probably, you want to use coccinelle for this.

If patch subject is "remove unnecessary space" then just remove
unnecessary spaces in the patch, otherwise I suggest you rename this
to "ipvs: use bitmap_zalloc()" or such, since the space removal here
is irrelevant.
