Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC1917C0E7
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 15:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCFOwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 09:52:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgCFOwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 09:52:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GIeI8sQ13RbUbwydTic1ZOaIHtJnoHm6mSFJlsOPSh0=; b=I+pqttXecX4Hgtvr/4WgOtPyxa
        CqtCCZdRJWt1mGweGjHcmXIUJWhJGyDfAVFyq6z1yK6O3szf0aY2cxF7iL5EFDLZJzca/hGD/+sVy
        u0pXDLgCAjvV7dq/COQwXN2D1ALtg0G9+h0I4dsk5hM9zF/fXLr1vPVqoDe2OylsuIXA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jAEKQ-0005PW-2n; Fri, 06 Mar 2020 15:51:54 +0100
Date:   Fri, 6 Mar 2020 15:51:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200306145154.GE25183@lunn.ch>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200305225407.GD25183@lunn.ch>
 <20200305234557.GE25745@shell.armlinux.org.uk>
 <20200306011310.GC2450@lunn.ch>
 <20200306035720.GD2450@lunn.ch>
 <20200306103934.GF25745@shell.armlinux.org.uk>
 <20200306145332.7b7a85da@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306145332.7b7a85da@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What I have been wondering about is if it would make sense to have the
> ability to set CPU/DSA link settings from userspace. Currently the
> CPU and DSA ports do not correspond to any system interface, so this is
> impossible via ethtool. I have been thinking about how this could be
> done.

Hi Marek

There has been some discussion about this in the context of the new
netlink ethtool implementation. It seems to make sense to move some
parts of ethtool into devlink. devlink does has a representation of
CPU and DSA ports. So it could provide the --dump-registers and
--statistics options. And for DSA switches, it would probably just
work.

      Andrew
