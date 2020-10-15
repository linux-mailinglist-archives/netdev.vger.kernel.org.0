Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A630128F5D1
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389653AbgJOP2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:28:42 -0400
Received: from correo.us.es ([193.147.175.20]:39352 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388686AbgJOP2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 11:28:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A563A1C4386
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 17:28:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98D5FDA73D
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 17:28:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E3D6DA78B; Thu, 15 Oct 2020 17:28:39 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F6C9DA78C;
        Thu, 15 Oct 2020 17:28:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 17:28:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 814BA42EF4E1;
        Thu, 15 Oct 2020 17:28:37 +0200 (CEST)
Date:   Thu, 15 Oct 2020 17:28:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 9/9] netfilter: flowtable: add vlan support
Message-ID: <20201015152837.GA14689@salvia>
References: <20201015011630.2399-1-pablo@netfilter.org>
 <20201015011630.2399-10-pablo@netfilter.org>
 <20201015081013.4f059b7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201015081013.4f059b7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 08:10:13AM -0700, Jakub Kicinski wrote:
> On Thu, 15 Oct 2020 03:16:30 +0200 Pablo Neira Ayuso wrote:
> > Add the vlan id and proto to the flow tuple to uniquely identify flows
> > from the receive path. Store the vlan id and proto to set it accordingly
> > from the transmit path. This patch includes support for two VLAN headers
> > (Q-in-Q).
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> 20+ sparse warnings here as well - do you want to respin quickly?

Yes, preparing for this.
