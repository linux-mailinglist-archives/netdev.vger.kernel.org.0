Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4090118E9C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfLJRKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:10:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727610AbfLJRKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 12:10:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YrpH1ddKkdbeqDtNUtw9eCdE7Ae/HSOVVVFiRP1KcA8=; b=g+OQ26sYbDfxzxnXIE2xWlFpEr
        8MCkjxNE7/5iRKeCJVVlsSCpd61+rZe8VMIka5Awi9SDjjnf36rMZorvfCZingpeCUGPvz7eFm0LZ
        9fRVdpcCzFAQuZ7tPrs6vLKJ53xxIdkuc9txRwTRsnTsKydjNSvW3+SR5TklLIhEAxTA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iej1p-0005d6-IS; Tue, 10 Dec 2019 18:10:29 +0100
Date:   Tue, 10 Dec 2019 18:10:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 10/14] net: phylink: split
 phylink_sfp_module_insert()
Message-ID: <20191210171029.GP27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKof-0004vb-Ai@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKof-0004vb-Ai@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:19:17PM +0000, Russell King wrote:
> Split out the configuration step from phylink_sfp_module_insert() so
> we can re-use this later.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

