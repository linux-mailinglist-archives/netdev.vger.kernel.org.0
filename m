Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED97317B526
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 04:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCFD53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 22:57:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgCFD53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 22:57:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y2Tk8DnxkMRwDEpsS6R/Mi17xAcIntdMnZlt/sSK8zg=; b=vbd9Xf3ajHGE4btEJgJirrrXN3
        /nqA2qa3OmEMqahSlsMwgU31ELQ9u0izMFCBRj5QFg1yEwRCD2vSXnrxDNd/TH52mtHaUTJoFOk1x
        /LcF5JOA7DMkZj1DYwGXRQq0XDxx+E7oWoiriw47Ye6Z3EeIeOD9Nc010wFXGnjnmYVs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jA46y-0001yn-An; Fri, 06 Mar 2020 04:57:20 +0100
Date:   Fri, 6 Mar 2020 04:57:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200306035720.GD2450@lunn.ch>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200305225407.GD25183@lunn.ch>
 <20200305234557.GE25745@shell.armlinux.org.uk>
 <20200306011310.GC2450@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306011310.GC2450@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell

> I will try to figure out which patch broke it.

ommit e67b45adefa8d43c68560906f3955845a5ee14d8 (HEAD)
Author: Russell King <rmk+kernel@armlinux.org.uk>
Date:   Thu Mar 5 12:42:26 2020 +0000

    net: dsa: mv88e6xxx: configure interface settings in mac_config
    
    Only configure the interface settings in mac_config(), leaving the
    speed and duplex settings to mac_link_up to deal with.

Maybe:


+       /* FIXME: should we force the link down here - but if we do, how
+        * do we restore the link force/unforce state? The driver layering
+        * gets in the way.
+        */

???

	Andrew
