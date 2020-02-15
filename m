Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88EF15FFF1
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 20:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOTEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 14:04:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgBOTEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 14:04:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pQwC1ecH4Pp04Gzec4Xs67vN8WVYg3FZkJDVS9U8n24=; b=y2B+YiX0E54FS1Gdn8hA9mzrFc
        rDB6m7GErolYNRnm/87sIHZe+8mvtlx61gvxgWG73yAzXaxETT6OGs1dO1kFKnA7LuPEsI0BIxGCC
        HkG+L2mlT5N5i6p8NGsVuXC2/mkcc98CgSlY0oLCzCXSsWQfIfPOk4rYro0gKyAvWMXk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j32k3-0005Cl-IS; Sat, 15 Feb 2020 20:04:39 +0100
Date:   Sat, 15 Feb 2020 20:04:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/10] net: phylink: allow ethtool -A to change
 flow control advertisement
Message-ID: <20200215190439.GX31084@lunn.ch>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zhe-0003YH-OZ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j2zhe-0003YH-OZ@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 03:49:58PM +0000, Russell King wrote:
> When ethtool -A is used to change the pause modes, the pause
> advertisement is not being changed, but the documentation in
> uapi/linux/ethtool.h says we should be. Add that capability to
> phylink.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
