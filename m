Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5212AA7ED
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgKGUpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGUps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:45:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 139D7206C1;
        Sat,  7 Nov 2020 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604781948;
        bh=tuaYZkpNhucN3oE13/D9qcN/F+U1WHwW0VAxmnvvom8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zpt7WHocUhEqS4HJzao0wRCK1JRjmZQmcrFz1CYoj+ZBzoBw5gJOYzXJEd5xrjVGN
         AV7ozTPckmOae9zjNcPvVGU+PIxB+89RWr0bAyKEnpkMCjyw1IpaPJ9dX1Pqh0vGON
         26Uo5xeD/WC3zCxGsrs9uB89Djp72XaZGnsORmfY=
Date:   Sat, 7 Nov 2020 12:45:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net] net: marvell: prestera: fix compilation with
 CONFIG_BRIDGE=m
Message-ID: <20201107124547.0b22d635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4d67e1d4-4f5c-a0c1-ce87-42e141215aa1@infradead.org>
References: <20201106161128.24069-1-vadym.kochan@plvision.eu>
        <4d67e1d4-4f5c-a0c1-ce87-42e141215aa1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 12:13:12 -0800 Randy Dunlap wrote:
> On 11/6/20 8:11 AM, Vadym Kochan wrote:
> > With CONFIG_BRIDGE=m the compilation fails:
> > 
> >     ld: drivers/net/ethernet/marvell/prestera/prestera_switchdev.o: in function `prestera_bridge_port_event':
> >     prestera_switchdev.c:(.text+0x2ebd): undefined reference to `br_vlan_enabled'
> > 
> > in case the driver is statically enabled.
> > 
> > Fix it by adding 'BRIDGE || BRIDGE=n' dependency.
> > 
> > Fixes: e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementation")
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>  
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Applied, thanks!
