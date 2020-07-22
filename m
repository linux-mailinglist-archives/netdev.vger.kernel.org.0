Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9DB22904F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgGVGDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:03:48 -0400
Received: from ja.ssi.bg ([178.16.129.10]:51892 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbgGVGDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 02:03:48 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 06M631l3002786;
        Wed, 22 Jul 2020 09:03:01 +0300
Date:   Wed, 22 Jul 2020 09:03:01 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Andrew Sy Kim <kim.andrewsy@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] ipvs: add missing struct name in ip_vs_enqueue_expire_nodest_conns
 when CONFIG_SYSCTL is disabled
In-Reply-To: <20200721232007.GA6367@salvia>
Message-ID: <alpine.LFD.2.23.451.2007220901320.2433@ja.home.ssi.bg>
References: <20200717162450.1049-1-kim.andrewsy@gmail.com> <alpine.LFD.2.23.451.2007172032370.4536@ja.home.ssi.bg> <20200721232007.GA6367@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 22 Jul 2020, Pablo Neira Ayuso wrote:

> On Fri, Jul 17, 2020 at 08:36:36PM +0300, Julian Anastasov wrote:
> > 
> > On Fri, 17 Jul 2020, Andrew Sy Kim wrote:
> > 
> > > Adds missing "*ipvs" to ip_vs_enqueue_expire_nodest_conns when
> > > CONFIG_SYSCTL is disabled
> > > 
> > > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> > 
> > 	Pablo, please apply this too.
> 
> I have squashed this fix and "ipvs: ensure RCU read unlock when
> connection flushing and ipvs is disabled" into the original patch:
> 
> "ipvs: queue delayed work to expire no destination connections if
> expire_nodest_conn=1"

	Very good, thanks!

Regards

--
Julian Anastasov <ja@ssi.bg>
