Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EBA1A8B8E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505239AbgDNTxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:53:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505240AbgDNTwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 15:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JJ05CwHnEt8CVITDAq55HucVUWn50kQQhr98xSt6Jj8=; b=J4T55cwe6/gAF5fkE/xbN3J0F7
        IxpeYOlW9iET90Qe8a6TCnRohLjxivf8xt9wzvGaMjo7KfqZaFf7CC4M+YiFHlO8dN8UkIQV/Vtfa
        zgqtRxq8JHuG6MUKNvjamv6XSHiG9X1bV2avXjeacMjS1BkYrsXHMwKK+86lwZct45z4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jORbr-002ice-Dg; Tue, 14 Apr 2020 21:52:39 +0200
Date:   Tue, 14 Apr 2020 21:52:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: marvell10g: report firmware version
Message-ID: <20200414195239.GA647388@lunn.ch>
References: <20200414194753.GB25745@shell.armlinux.org.uk>
 <E1jORYN-000401-3U@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jORYN-000401-3U@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:49:03PM +0100, Russell King wrote:
> Report the firmware version when probing the PHY to allow issues
> attributable to firmware to be diagnosed.
> 
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
