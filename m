Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86603FE812
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKOWg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:36:28 -0500
Received: from correo.us.es ([193.147.175.20]:47452 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfKOWg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 17:36:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CDB38FB366
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 23:36:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BECE7D1DBB
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 23:36:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3E46DA3A9; Fri, 15 Nov 2019 23:36:24 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0AB6DA7B6;
        Fri, 15 Nov 2019 23:36:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 23:36:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AC04F426CCBA;
        Fri, 15 Nov 2019 23:36:22 +0100 (CET)
Date:   Fri, 15 Nov 2019 23:36:24 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Garver <eric@garver.life>
Subject: Re: [nf-next PATCH] net: netfilter: Support iif matches in
 POSTROUTING
Message-ID: <20191115223624.ocmnjslnsszw6ddm@salvia>
References: <20191112161437.19511-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112161437.19511-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 05:14:37PM +0100, Phil Sutter wrote:
> Instead of generally passing NULL to NF_HOOK_COND() for input device,
> pass skb->dev which contains input device for routed skbs.
> 
> Note that iptables (both legacy and nft) reject rules with input
> interface match from being added to POSTROUTING chains, but nftables
> allows this.

Applied, thanks.
