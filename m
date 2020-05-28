Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203131E69AC
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391518AbgE1Sns convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 14:43:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:57314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391498AbgE1Snp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 14:43:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68384AC96;
        Thu, 28 May 2020 18:43:43 +0000 (UTC)
Date:   Thu, 28 May 2020 20:43:42 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-Id: <20200528204342.9c1c067c2b7ad9150bebcc16@suse.de>
In-Reply-To: <20200528163327.GF840827@lunn.ch>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
        <20200528130738.GT1551@shell.armlinux.org.uk>
        <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
        <20200528135608.GU1551@shell.armlinux.org.uk>
        <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
        <20200528163327.GF840827@lunn.ch>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 18:33:27 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, May 28, 2020 at 04:33:35PM +0200, Thomas Bogendoerfer wrote:
> > below is the dts part for the two network interfaces. The switch to
> > the outside has two ports, which correlate to the two internal ports.
> > And the switch propagates the link state of the external ports to
> > the internal ports.
> 
> Hi Thomas
> 
> Any plans to add mainline support for this board?
> Contribute the DT files?

I'll ask our partner, if they are interested in upstreaming it.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
