Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00EDC4EFE0
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfFUUL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 16:11:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfFUUL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 16:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AR49Vay+7BcJXSk91lACQllXk236StVu43BYiK/yMBg=; b=ts737wX2V6oSVxMMfzr2BOBjuK
        zMmskfi7x4C+3SN0IR2KWabGjUCSQqfem5mHf+hTaUIo/OHNAFf6sSAk4FDf7fqjhFVXX3rtqSrKe
        XYp29UYKyq/yj3q0hsEGLZMhPxBfyL4kB9DTTW6RqMqA6n6qIm8ilT2Dae09imMUoNDw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hePsS-0008H6-3K; Fri, 21 Jun 2019 22:11:16 +0200
Date:   Fri, 21 Jun 2019 22:11:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] doc: phy: document some PHY_INTERFACE_MODE_xxx
 settings
Message-ID: <20190621201116.GN31306@lunn.ch>
References: <E1heL0P-00075z-An@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1heL0P-00075z-An@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 03:59:09PM +0100, Russell King wrote:
> There seems to be some confusion surrounding three PHY interface modes,
> specifically 1000BASE-X, 2500BASE-X and SGMII.  Add some documentation
> to phylib detailing precisely what these interface modes refer to.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
