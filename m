Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169E13EC3B5
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhHNQHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:07:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhHNQHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 12:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eHC2d1DLd2HNf9ew49TAVNIw0xy0JcmrJY3D6G5o1oM=; b=HE1vqAixcCH3+QZHUdDx9Vt4wR
        ISLMneg1m7mP/i2he6Gfp3OibKixtp76Y9i+n0ujZKjRkkEAvcChblBIF8jrT+J/JTObFVucPVH5E
        A9jYVBKCQfMyGa0iVKAIAnW4YaNqYRlWF/14bTkvqxkWc6+v+usPOWT84jYAkYz3FfGk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEwAr-0005AO-EU; Sat, 14 Aug 2021 18:06:17 +0200
Date:   Sat, 14 Aug 2021 18:06:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: pcs: xpcs: Add Pause Mode support for
 SGMII and 2500BaseX
Message-ID: <YRfp+bjCE+a/2rOe@lunn.ch>
References: <20210813021129.1141216-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813021129.1141216-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 10:11:29AM +0800, Wong Vee Khee wrote:
> SGMII/2500BaseX supports Pause frame as defined in the IEEE802.3x
> Flow Control standardization.
> 
> Add this as a supported feature under the xpcs_sgmii_features struct.
> 
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
