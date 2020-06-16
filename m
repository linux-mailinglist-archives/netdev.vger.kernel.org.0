Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE01FADAD
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgFPKO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPKOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:14:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AB6C08C5C2;
        Tue, 16 Jun 2020 03:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YMNjtPkUP07OueOokG4fk77Nq73HNsl0a5WlXwfxR7g=; b=gt9Hi1QPxBoutmH3mi4JL7iRs
        9UF/thJLliLHe2KCL9wnfKBJralaec4Mbl2VsPihwkzCQOgFNlypT0Oyt23nVPBmvqaGb1PH/Lqoq
        PfomGQH7b5VGWIERc+e2TjJgdNHm1dPXs6NF6/JIaU67DyERIXPqD8xqSifOM8+guWOHmhs5McZB/
        8KfHWhdncf/InaezM7VcgbomwexiC/OAUZXYSvwONUFHFHQcFM9uSgVA6xtViHYIyzFsE4X2PP+DQ
        P414SVMD2c1o2/n37q3hIhNza3GW8pHA7Bx0ROgiun69ldGDuUXPUL1WoZNDL97XeYcUP0rI8GziU
        M0yhbJgMQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57860)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jl8bS-0002HY-1X; Tue, 16 Jun 2020 11:14:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jl8bN-00022E-SX; Tue, 16 Jun 2020 11:13:57 +0100
Date:   Tue, 16 Jun 2020 11:13:57 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com
Subject: Re: [PATCH v3 1/3] net: phy: mscc: move shared probe code into a
 helper
Message-ID: <20200616101357.GM1551@shell.armlinux.org.uk>
References: <20200615144501.1140870-1-heiko@sntech.de>
 <20200615.181129.570239999533845176.davem@davemloft.net>
 <20200615.181225.2016760272076151342.davem@davemloft.net>
 <1656001.WqWBulSbu3@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1656001.WqWBulSbu3@diego>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:10:27AM +0200, Heiko Stübner wrote:
> > 
> > You also need to provide a proper header posting when you repost this series
> > after fixing this bug.
> 
> not sure I understand what you mean with "header posting" here.

David is requesting that you send a "0/N" email summarising the purpose
of the patch series and any other relevant information to the series as
a whole.  The subsequent patches should be threaded to the 0/N email.

The 0/N email should also contain the overall diffstat for the series.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
