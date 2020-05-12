Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774EC1CF7D5
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgELOuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:50:07 -0400
Received: from muru.com ([72.249.23.125]:54016 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgELOuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 10:50:07 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C1F088047;
        Tue, 12 May 2020 14:50:55 +0000 (UTC)
Date:   Tue, 12 May 2020 07:50:04 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>
Subject: Re: [PATCH net v4] net: ethernet: ti: Remove TI_CPTS_MOD workaround
Message-ID: <20200512145004.GG37466@atomide.com>
References: <20200512100230.17752-1-grygorii.strashko@ti.com>
 <20200512142230.GF37466@atomide.com>
 <9f86a9ef-c069-e69b-540a-2fd2731b8619@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f86a9ef-c069-e69b-540a-2fd2731b8619@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [200512 14:35]:
> On 12/05/2020 17:22, Tony Lindgren wrote:
> > However, there's at least one more issue left that shows up at least
> > on ti81xx dra62x-j5eco-evm on v5.7-rc5 that has commit b46b2b7ba6e1
> > ("ARM: dts: Fix dm814x Ethernet by changing to use rgmii-id mode").
> > 
> > I think this is a different issue though, any ideas?
> > 
> 
> This seems like completely different issue.

OK thanks for checking.

> Could we have separate thread started for this, pls?

Sure. No objections to the $subject fix.

Regards,

Tony
