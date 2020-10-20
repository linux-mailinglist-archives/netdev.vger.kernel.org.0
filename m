Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FBD293DAB
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407697AbgJTNtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407689AbgJTNtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 09:49:45 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8B4C061755;
        Tue, 20 Oct 2020 06:49:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 4EAF413FC95;
        Tue, 20 Oct 2020 15:49:42 +0200 (CEST)
Date:   Tue, 20 Oct 2020 15:49:40 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201020154940.60357b6c@nic.cz>
In-Reply-To: <20201020101552.GB1551@shell.armlinux.org.uk>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
        <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
        <20201020101552.GB1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 11:15:52 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Oct 20, 2020 at 04:45:56PM +1300, Chris Packham wrote:
> > When a port is configured with 'managed = "in-band-status"' don't force
> > the link up, the switch MAC will detect the link status correctly.
> > 
> > Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>  
> 
> I thought we had issues with the 88E6390 where the PCS does not
> update the MAC with its results. Isn't this going to break the
> 6390? Andrew?
> 

Russell, I tested this patch on Turris MOX with 6390 on port 9 (cpu
port) which is configured in devicetree as 2500base-x, in-band-status,
and it works...

Or will this break on user ports?
