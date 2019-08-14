Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3598DBE0
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfHNR2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:28:47 -0400
Received: from correo.us.es ([193.147.175.20]:53464 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728563AbfHNR2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 13:28:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C2BA8DA725
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 19:28:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4F9FDA7E1
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 19:28:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AA7DADA730; Wed, 14 Aug 2019 19:28:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52EBCDA72F;
        Wed, 14 Aug 2019 19:28:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 19:28:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2E9E04265A2F;
        Wed, 14 Aug 2019 19:28:41 +0200 (CEST)
Date:   Wed, 14 Aug 2019 19:28:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Miller <davem@davemloft.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: fallout from net-next netfilter changes
Message-ID: <20190814172840.25rafnx3cqmypsqh@salvia>
References: <20190814.125330.1934256694306164517.davem@davemloft.net>
 <20190814172758.xtf6ioke4qztzzqi@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814172758.xtf6ioke4qztzzqi@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 07:27:58PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 14, 2019 at 12:53:30PM -0400, David Miller wrote:
> > 
> > This started happening after Jakub's pull of your net-next changes
> > yesterday:
> > 
> > ./include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
> >  #warning "Please update iptables, this file will be removed soon!"
> >   ^~~~~~~
> > In file included from <command-line>:
> > ./include/uapi/linux/netfilter_ipv4/ipt_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
> >  #warning "Please update iptables, this file will be removed soon!"
> >   ^~~~~~~
> > 
> > It's probaly from the standard kernel build UAPI header checks.
> > 
> > Please fix this.
> 
> Would you apply this patch that Jeremy posted via net-next instead of
> nf-next?
> 
> http://patchwork.ozlabs.org/patch/1146821/

Else I can prepare a small pull request with a few patches for
net-next later today, your choice.
