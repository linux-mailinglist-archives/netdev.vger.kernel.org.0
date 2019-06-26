Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87368566C6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfFZKau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:30:50 -0400
Received: from mail.us.es ([193.147.175.20]:52036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfFZKau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 06:30:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 366D911EF4B
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 12:30:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23D776D2B0
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 12:30:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 21141DA3F4; Wed, 26 Jun 2019 12:30:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA52F4EDAF;
        Wed, 26 Jun 2019 12:30:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 12:30:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 86DBC4265A2F;
        Wed, 26 Jun 2019 12:30:45 +0200 (CEST)
Date:   Wed, 26 Jun 2019 12:30:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nft_meta: add
 NFT_META_BRI_PVID support
Message-ID: <20190626103045.fn6gq2mptrotpju4@salvia>
References: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
 <20190626090116.3qjmlnd5egeifozq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626090116.3qjmlnd5egeifozq@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 11:01:16AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 20, 2019 at 09:17:39AM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > nft add table bridge firewall
> > nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
> > nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }
> > 
> > As above set the bridge port with pvid, the received packet don't contain
> > the vlan tag which means the packet should belong to vlan 200 through pvid.
> > With this pacth user can get the pvid of bridge ports.
> > 
> > So add the following rule for as the first rule in the chain of zones.
> > 
> > nft add rule bridge firewall zones counter meta brvlan set meta brpvid
> 
> Applied, thanks.

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=da4f10a4265b109fbdb77d5995236e0843e4a26d

This patch is applied.

2/2 is not, until we finish a bit of discussion on where to go.

Thanks.
