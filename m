Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD00299986
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393437AbgJZWWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:22:01 -0400
Received: from kernel.crashing.org ([76.164.61.194]:50916 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392831AbgJZWWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:22:00 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09QMLIgd032401
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 26 Oct 2020 17:21:22 -0500
Message-ID: <e6c8e96bb26a5505e967e697946d359c22ac68c5.camel@kernel.crashing.org>
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>,
        Andrew Jeffery <andrew@aj.id.au>
Cc:     BMC-SW <BMC-SW@aspeedtech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        netdev <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Date:   Tue, 27 Oct 2020 09:21:17 +1100
In-Reply-To: <PS1PR0601MB18498469F0263306A6E5183F9C1A0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
         <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
         <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <PS1PR0601MB1849166CBF6D1678E6E1210C9C1F0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
         <CAK8P3a2pEfbLDWTppVHmGxXduOWPCwBw-8bMY9h3EbEecsVfTA@mail.gmail.com>
         <32bfb619bbb3cd6f52f9e5da205673702fed228f.camel@kernel.crashing.org>
         <529612e1-c6c4-4d33-91df-2a30bf2e1675@www.fastmail.com>
         <PS1PR0601MB18498469F0263306A6E5183F9C1A0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-23 at 13:08 +0000, Dylan Hung wrote:
> The issue was found on our test chip (ast2600 version A0) which is
> just for testing and won't be mass-produced.  This HW bug has been
> fixed on ast2600 A1 and later versions.
> 
> To verify the HW fix, I run overnight iperf and kvm tests on
> ast2600A1 without this patch, and get stable result without hanging.
> So I think we can discard this patch.

This is great news. Thanks !

Cheers,
Ben.


