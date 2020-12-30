Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFAC2E7AF6
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgL3QMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgL3QMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 11:12:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E70C061799;
        Wed, 30 Dec 2020 08:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vWrxzaa/+R0AJWy+zgvTuWC5ulBqsve/SdPdO1a9IQQ=; b=0suEv0JbLx9qQbxBYyLl5NMe0
        wU8cW+QFeqhUQnaSoo8i/zuecm0NZXvVWKanjxW3XzmzOGIRazxinubazim+84/xla+hf009NhmYT
        gKDXANTuKLwshEhN4D8p33toA3KuIJskkaoz7NnR+vHIK0Kp2R8mOxNinuX2Zr5dV4C2arM2EKvP0
        2Sb8mcBo0VNAoTqArR1BgBoioygCO3i0PHtPmXueHtKdEMWcvCSTwo9hIMBTx6Y57R0/VaYxjASXe
        cdDDFSsQZaqmP/CRKTXcvNoA5TVxQjbPv6yu7zsSniBWDsepFdjRzbcPCsiMwk8P/x6a0ibps59CG
        Ooqky6ugw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44914)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kue4l-0005oY-Qz; Wed, 30 Dec 2020 16:11:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kue4l-0002KO-Kf; Wed, 30 Dec 2020 16:11:51 +0000
Date:   Wed, 30 Dec 2020 16:11:51 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: sfp: allow to use also SFP modules which are
 detected as SFF
Message-ID: <20201230161151.GS1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-3-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230154755.14746-3-pali@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 04:47:53PM +0100, Pali Rohár wrote:
> Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set SFF phys_id
> in their EEPROM. Kernel SFP subsystem currently does not allow to use
> modules detected as SFF.
> 
> This change extends check for SFP modules so also those with SFF phys_id
> are allowed. With this change also GPON SFP module Ubiquiti U-Fiber Instant
> is recognized.

I really don't want to do this for every single module out there.
It's likely that Ubiquiti do this crap as a vendor lock-in measure.
Let's make it specific to Ubiquiti modules _only_ until such time
that we know better.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
