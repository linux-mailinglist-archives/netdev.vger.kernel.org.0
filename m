Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DE010489B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUCkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:40:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKUCkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:40:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dgwFvvQ3tLdE75pisquIUQh+j4B/R3dEPvs6b8HPCYU=; b=g8VVMMmiwr47q4kqVxPJY3g6kh
        66F14z+012WbLJYtq1pdx/13hFQmI4193Qa2VU1cxuRSWChFHWf4d5GnjU3iqmJWLhp/Uu1TcJePZ
        DYcOQtleE5nqZXGn6EKfIVOsX08pI26sMHcDgT1gllAZlas4BcDc1dOp7tLYAqyOrENI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcCs-00074H-De; Thu, 21 Nov 2019 03:28:30 +0100
Date:   Thu, 21 Nov 2019 03:28:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Add rudimentary SFP module quirk support
Message-ID: <20191121022830.GH18325@lunn.ch>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120113900.GP25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:39:00AM +0000, Russell King - ARM Linux admin wrote:
> The SFP module EEPROM describes the capabilities of the module, but
> doesn't describe the host interface.  We have a certain amount of
> guess-work to work out how to configure the host - which works most
> of the time.
> 
> However, there are some (such as GPON) modules which are able to
> support different host interfaces, such as 1000BASE-X and 2500BASE-X.
> The module will switch between each mode until it achieves link with
> the host.
> 
> There is no defined way to describe this in the SFP EEPROM, so we can
> only recognise the module and handle it appropriately.  This series
> adds the necessary recognition of the modules using a quirk system,
> and tweaks the support mask to allow them to link with the host at
> 2500BASE-X, thereby allowing the user to achieve full line rate.

Hi Russell

Did you consider making the Cotsworks checksum issue a quirk?

    Andrew
