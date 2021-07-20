Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D153CFB69
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbhGTNOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:14:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238885AbhGTNLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3JTpgVeITQVUlbixeOimWd3RnQCgUdonTnDLRicnWPw=; b=0HkAqjJnkSYFZqE0XVyk/ELjqn
        Z4e86UYAJALvx5xFdvgXO8DLak5DsN1pcZrQQDBUnjqY5SHewptjYc4Kaxkz2zVErkHYc7i+qeOxy
        eTwHWgpVI7ObeLweDqkxAf+KiQ1p4dzJ745w1TAXCgSk+z0y+FrvQLlZht/GVsrUZWsY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5qAV-00E3jS-1Y; Tue, 20 Jul 2021 15:52:19 +0200
Date:   Tue, 20 Jul 2021 15:52:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phylink: add phy change pause mode debug
Message-ID: <YPbVE1qgXCO8dhII@lunn.ch>
References: <E1m5nia-0003Ml-Um@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1m5nia-0003Ml-Um@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 12:15:20PM +0100, Russell King (Oracle) wrote:
> Augment the phy link debug prints with the pause state.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
