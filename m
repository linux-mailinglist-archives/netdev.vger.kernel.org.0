Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F6E15F8F9
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 22:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbgBNVur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 16:50:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbgBNVur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 16:50:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7iRmTIPwdVFSIEMmhYwyfw+SlQI0O1RLqb/oLphl5Ow=; b=0Fq+suukFgH9Wv9A6xtYGcRQxl
        x4ke43NR8rGrvA4iaY3LmvwGynr3DGHh4xKlW6C1htwXFCoqncX+xQmbu9Zr7rhxOMar1h4CNR5Jp
        6rUcsoXi2w6vLaUJQUCdRcgkO5rf8DHwqu7wZ1jhQETUWbCfSsVjInrXiFJkLQLEEQ+A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2ir7-0002EK-Az; Fri, 14 Feb 2020 22:50:37 +0100
Date:   Fri, 14 Feb 2020 22:50:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Scott Branden <scott.branden@broadcom.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arun Parameswaran <arun.parameswaran@broadcom.com>
Subject: Re: [PATCH v2] net: phy: restore mdio regs in the iproc mdio driver
Message-ID: <20200214215037.GR31084@lunn.ch>
References: <20200214214746.10153-1-scott.branden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214214746.10153-1-scott.branden@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 01:47:46PM -0800, Scott Branden wrote:
> From: Arun Parameswaran <arun.parameswaran@broadcom.com>
> 
> The mii management register in iproc mdio block
> does not have a retention register so it is lost on suspend.
> Save and restore value of register while resuming from suspend.

You actually just reconfigure, you don't save it. But that is minor.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
