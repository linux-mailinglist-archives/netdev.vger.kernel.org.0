Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64492DF0F1
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgLSSE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgLSSE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 13:04:27 -0500
Date:   Sat, 19 Dec 2020 10:03:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608401026;
        bh=9PI67Gtjyaj60F8WUhcuDVMDvN38DEIx0E6CfrYsQA0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tb1aGie7OVfbx/nhj4daVOG2nUKdLjOgqVlaQpQZ9ar+jomkzH9JdwssawL1k68N7
         jqxbRhFHAeDj2iHU6icrmTmwZ55d/lvaqg5CiyMzBEaqIwtOovf5PliAyjzI1nl25V
         hhTUeMPsoWU6LEXYHO71K2dccMvCEuheIapQo/l06yOcj3UY1DNEVlG0FR5df0dP0S
         G4Qqa2AoebzBjufgb+c8nhZjTVUxYxcsNLM59iw/a+sQc6NkP3CIRpV5apU3hsL493
         xazQacBn2n7P1cDFR0Z8jMUQGb/BY5k2R8JpNYNlnvIUlW9zgQWedGEj7cAulrm4n1
         brv3IIZ90DPyQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <lironh@marvell.com>
Subject: Re: [PATCH net-next] net: mvpp2: prs: improve ipv4 parse flow
Message-ID: <20201219100345.22d86122@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1608221278-15043-1-git-send-email-stefanc@marvell.com>
References: <1608221278-15043-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 18:07:58 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Patch didn't fix any issue, just improve parse flow
> and align ipv4 parse flow with ipv6 parse flow.
> 
> Currently ipv4 kenguru parser first check IP protocol(TCP/UDP)
> and then destination IP address.
> Patch introduce reverse ipv4 parse, first destination IP address parsed
> and only then IP protocol.
> This would allow extend capability for packet L4 parsing and align ipv4
> parsing flow with ipv6.
> 
> Suggested-by: Liron Himi <lironh@marvell.com>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>

This one will need to wait until after the merge window

--

# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
