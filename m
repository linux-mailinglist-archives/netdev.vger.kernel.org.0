Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F6A23ABAD
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgHCRca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHCRca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:32:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B508C06174A;
        Mon,  3 Aug 2020 10:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0ZDD1ZPqsN+tFofRrEFxYutxtUgK9Ft2cc16nR6TtKQ=; b=LCwADhUujEXFWHoJ0pW3J/I5r
        8o8K5TVpuJxvaMw2CkilXdpCncofaEBbZFdRkQQbvMWpwFI8Kclj03J2WFpO5e5n3o+sL2el9iBHw
        WVc8l2xunrWTmC9y731AAqcvJuflejdR0JqMDiqpj+fUQBKWUruowhC3yp5b0B2sqJD6kYxrU93Cu
        9p2ua/k9CcDM2UtkE01bACMbBkpkkw2Gke+OLNKcnGWkqpHavGU4xfPJd1rDqpiYiohWT8B/bMAmO
        9Yq4jVHkgEIvMFdcPWfE3zrUisPn1MXHJWgEUAvAT/OlvG5pv/NSbr/r10m2hWe0DsFLzWJjvU1az
        ip4OY4gGg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47888)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k2eK2-0001oV-JY; Mon, 03 Aug 2020 18:32:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k2eK0-0003Gp-3l; Mon, 03 Aug 2020 18:32:24 +0100
Date:   Mon, 3 Aug 2020 18:32:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in hci_le_meta_evt
Message-ID: <20200803173223.GS1551@shell.armlinux.org.uk>
References: <000000000000a876b805abfa77e0@google.com>
 <20200803171232.GR1551@shell.armlinux.org.uk>
 <20200803172104.GA1644292@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803172104.GA1644292@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 10:21:04AM -0700, Eric Biggers wrote:
> On Mon, Aug 03, 2020 at 06:12:33PM +0100, Russell King - ARM Linux admin wrote:
> > Dear syzbot,
> > 
> > Please explain why you are spamming me with all these reports - four so
> > far.  I don't understand why you think I should be doing anything with
> > these.
> > 
> > Thanks.
> 
> syzbot just uses get_maintainer.pl.
> 
> $ ./scripts/get_maintainer.pl net/bluetooth/hci_event.c
> Marcel Holtmann <marcel@holtmann.org> (maintainer:BLUETOOTH SUBSYSTEM)
> Johan Hedberg <johan.hedberg@gmail.com> (maintainer:BLUETOOTH SUBSYSTEM)
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
> Russell King <linux@armlinux.org.uk> (maintainer:SFF/SFP/SFP+ MODULE SUPPORT)
> linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM)
> netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
> linux-kernel@vger.kernel.org (open list)

Ah, and, because the file mentions "phylink" (although it makes no use
of the phylink code), get_maintainer spits out my address. Great.

So how do I get get_maintainer to identify patches that are making use
of phylink, but avoid this bluetooth code... (that's not a question.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
