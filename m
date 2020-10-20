Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490A0293902
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406026AbgJTKQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733233AbgJTKQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:16:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DC0C061755;
        Tue, 20 Oct 2020 03:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3s30KdYLfR0XxQKTPdKrtDrwddmdih/E9ag+JxS1Kqk=; b=tOsh8CdxFDLDwYqgf9ketSXl2
        80gHKtlqOOjTfuayxKq1jrSiUSfqhJqHuE5Yiy9JtpfHMBHwVxprxI3U7HUtSofz3bcMvF7UNyEfu
        wQU37gkCZ5MGC64dVuxULxBTpRG3l0F8oaH7DRyiIjh5GlRGLYM9PkbnVgb1yPkXqGe1lCigd6b0G
        jeVwOae7sGuHAurr2HJHaNJAvG9e0nM88LlW25adSgnBXcb+QuAtmw59yyrVWSOTb1+UJ+NBIv0fl
        9whHrFDD0ZDzJ/v/esQfLR0BB/Ns+pnRxYuxP9RnY6JD5mwMegEPHK420uTv1v+wWE9K1RvPxdbVX
        H0N8qtINw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48620)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUogV-00077V-FO; Tue, 20 Oct 2020 11:16:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUogK-0005CV-UP; Tue, 20 Oct 2020 11:15:52 +0100
Date:   Tue, 20 Oct 2020 11:15:52 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201020101552.GB1551@shell.armlinux.org.uk>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 04:45:56PM +1300, Chris Packham wrote:
> When a port is configured with 'managed = "in-band-status"' don't force
> the link up, the switch MAC will detect the link status correctly.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I thought we had issues with the 88E6390 where the PCS does not
update the MAC with its results. Isn't this going to break the
6390? Andrew?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
