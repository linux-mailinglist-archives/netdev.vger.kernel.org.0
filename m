Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7942CA40
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfE1PVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:21:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfE1PVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 11:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=spdZ2GvZxnPYHdBe8ZTDsq2mxAtpxrLP9Fx4Ad70a40=; b=ptGiQVdsVGtcQ+FXm8pR0WNEbL
        wAcZLhHiJmVlHyRGUqR8JJ/3fmR+iqc2YfAVI4uFp8TyyJlZQco0KtoABoA94Tm5Tk7msHIUl18O2
        /nOCwRhNEljmiXTQVqO4/Nz6+DHpGuKFuo80o+EAgs/TdVw7AN+6qDS8mRoU8nC9hfuA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVduR-0007px-TO; Tue, 28 May 2019 17:21:03 +0200
Date:   Tue, 28 May 2019 17:21:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: sfp: add mandatory attach/detach
 methods for sfp buses
Message-ID: <20190528152103.GK18059@lunn.ch>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
 <E1hVYrO-0005ZH-C8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hVYrO-0005ZH-C8@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 10:57:34AM +0100, Russell King wrote:
> Add attach and detach methods for SFP buses, which will allow us to get
> rid of the netdev storage in sfp-bus.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
