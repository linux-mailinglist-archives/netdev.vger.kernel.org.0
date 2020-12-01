Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A692CB0FF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 00:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgLAXmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 18:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727353AbgLAXmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 18:42:00 -0500
Date:   Tue, 1 Dec 2020 15:41:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606866080;
        bh=CukjVda5yRGsOsN3nV1ysrrsRUENFaRj7YrS5A+ZX0M=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=k3pl0t8qB8opJjRvJhLH5A2CpaQvVUmZ3znZd9sb9MeqFNVo6vPQeBcqiey8lL3aL
         z8UCs8iekmPGPoey9Mq35dU1LRkitc7Vqz7k85H32CcUY0zkaRLklZdYeIfgABEDqR
         +oLoVpV40/pbBaCL24h8T1WbhHG8H1Kjyb4f6za0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: delete __dev_getfirstbyhwtype
Message-ID: <20201201154118.004db0f0@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <3095163.1606729122@warthog.procyon.org.uk>
References: <20201129200550.2433401-1-vladimir.oltean@nxp.com>
        <3095163.1606729122@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 09:38:42 +0000 David Howells wrote:
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> > The last user of the RTNL brother of dev_getfirstbyhwtype (the latter
> > being synchronized under RCU) has been deleted in commit b4db2b35fc44
> > ("afs: Use core kernel UUID generation").
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> 
> Fine by me.  I thought it had already been removed.

Applied, thanks!
