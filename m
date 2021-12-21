Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D0847C4E0
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 18:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbhLURVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 12:21:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230146AbhLURVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 12:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SiZgGKPRujLSgleduibTRuY7pw8AjV8yihmVZ8kHoaY=; b=hpushpXy4snLikLsb3wBNkLCCo
        XwdKQesgV+aPx2N8cXdWkjrlCoirBKT1eLDOSNvoIP6d//e7OyJVbk5bYJxXcjmwKYVScfTCEIz6I
        uSUdevo+tGbnkCT+1uFZvzjJ14VS3WNvFI99WG4dyYAcbYIDaACdtOnPC25WhUydDqhU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzip8-00H8py-Gd; Tue, 21 Dec 2021 18:21:14 +0100
Date:   Tue, 21 Dec 2021 18:21:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] net: phy: micrel: Adding interrupt support
 for Link up/Link down in LAN8814 Quad phy
Message-ID: <YcINCiiO/W1KQxzI@lunn.ch>
References: <20211221112217.9502-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221112217.9502-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 04:52:17PM +0530, Divya Koppera wrote:
> This patch add support for Link up or Link down
> interrupt support in LAN8814 Quad phy
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
