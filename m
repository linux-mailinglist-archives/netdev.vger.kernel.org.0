Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E851DBB8A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgETRcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:32:21 -0400
Received: from correo.us.es ([193.147.175.20]:47772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgETRcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 13:32:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A29B3303D09
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 19:32:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96C0EDA71F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 19:32:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B63ADA729; Wed, 20 May 2020 19:32:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90A5ADA701;
        Wed, 20 May 2020 19:32:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 19:32:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 703A942EF42A;
        Wed, 20 May 2020 19:32:16 +0200 (CEST)
Date:   Wed, 20 May 2020 19:32:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [PATCH v3 net-next] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200520173216.GA28641@salvia>
References: <2cf9024d-1568-4594-5763-6c4e4e8fe47b@solarflare.com>
 <f2586a0e-fce1-cee9-e2dc-f3dc73500515@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f2586a0e-fce1-cee9-e2dc-f3dc73500515@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 06:31:05PM +0100, Edward Cree wrote:
> On 20/05/2020 18:21, Edward Cree wrote:
> > @@ -582,7 +590,7 @@ nf_flow_offload_rule_alloc(struct net *net,
> >  	const struct flow_offload_tuple *tuple;
> >  	struct nf_flow_rule *flow_rule;
> >  	struct dst_entry *other_dst;
> > -	int err = -ENOMEM;
> > +	int err = -ENOMEM, i;
> >  
> >  	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
> >  	if (!flow_rule)
> Whoops, this changebar isn't meant to be there.  Somehow I missed
>  the unused var warning when I built it, too.
> Drop this, I'll spin v4.

The nf_tables_offload.c update is missing, please include this in v4.
