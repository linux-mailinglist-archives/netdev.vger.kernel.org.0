Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E0B5EB9D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGCSa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:30:29 -0400
Received: from ja.ssi.bg ([178.16.129.10]:43294 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfGCSa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 14:30:29 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x63ITQqx003852;
        Wed, 3 Jul 2019 21:29:26 +0300
Date:   Wed, 3 Jul 2019 21:29:26 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Randy Dunlap <rdunlap@infradead.org>
cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: Tree for Jul 3 (netfilter/ipvs/)
In-Reply-To: <406d9741-68ad-f465-1248-64eef05b1350@infradead.org>
Message-ID: <alpine.LFD.2.21.1907032126220.3226@ja.home.ssi.bg>
References: <20190703214900.45e94ae4@canb.auug.org.au> <406d9741-68ad-f465-1248-64eef05b1350@infradead.org>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-1070578143-1562178566=:3226"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1070578143-1562178566=:3226
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Wed, 3 Jul 2019, Randy Dunlap wrote:

> On 7/3/19 4:49 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20190702:
> > 
> 
> on i386:

	Oh, well. net/gre.h was included by CONFIG_NF_CONNTRACK, so
it is failing when CONFIG_NF_CONNTRACK is not used.

	Pablo, should I post v2 or just a fix?

> 
>   CC      net/netfilter/ipvs/ip_vs_core.o
> ../net/netfilter/ipvs/ip_vs_core.c: In function ‘ipvs_gre_decap’:
> ../net/netfilter/ipvs/ip_vs_core.c:1618:22: error: storage size of ‘_greh’ isn’t known
>   struct gre_base_hdr _greh, *greh;
>                       ^

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1070578143-1562178566=:3226--
