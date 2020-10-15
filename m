Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF6528FB66
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbgJOXEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:04:31 -0400
Received: from correo.us.es ([193.147.175.20]:39706 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732282AbgJOXEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 19:04:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39EAFFB36B
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 01:04:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C270DA722
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 01:04:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 21CABDA730; Fri, 16 Oct 2020 01:04:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B509CDA722;
        Fri, 16 Oct 2020 01:04:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 16 Oct 2020 01:04:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 951A342EF4E0;
        Fri, 16 Oct 2020 01:04:26 +0200 (CEST)
Date:   Fri, 16 Oct 2020 01:04:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next,v2 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201015230426.GA15673@salvia>
References: <20201015163038.26992-1-pablo@netfilter.org>
 <20201015124748.7793cbda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201015124748.7793cbda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 12:47:48PM -0700, Jakub Kicinski wrote:
> On Thu, 15 Oct 2020 18:30:29 +0200 Pablo Neira Ayuso wrote:
> > The following patchset adds infrastructure to augment the Netfilter
> > flowtable fastpath [1] to support for local network topologies that
> > combine IP forwarding, bridge and vlan devices.
> > 
> > A typical scenario that can benefit from this infrastructure is composed
> > of several VMs connected to bridge ports where the bridge master device
> > 'br0' has an IP address. A DHCP server is also assumed to be running to
> > provide connectivity to the VMs. The VMs reach the Internet through
> > 'br0' as default gateway, which makes the packet enter the IP forwarding
> > path. Then, netfilter is used to NAT the packets before they leave to
> > through the wan device.
> 
> Hi Pablo, I should have looked at this closer yesterday, but I think it
> warrants a little more review than we can afford right now. 
> 
> Let's take it after the merge window, sorry!

I understand, I admit it was a bit late patchset.

I have to say that I'm dissapointed. I cannot avoid shaking the
feeling that there is always a reason to push back for Netfilter
stuff.

Probably it's not fair to mention this in this case.

It's just a personal perception, so I might be really wrong about it.
