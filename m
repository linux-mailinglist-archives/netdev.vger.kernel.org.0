Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74823F317A
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhHTQ2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:28:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhHTQ23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 12:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FOO2Hn4H5lmv2wkFeFv12neelWhc/nSN63Z8Cgs9kE8=; b=fK20hbmD9aPQ4JINN1ID/n6yT/
        BN06Ry/UftV2DUt3ibAxiSlYzDIYe5dV5oNbblLtY28LECJruRw7IOYyXZ8XTRhNjqDDAYvNEDz+G
        wPKdCphX3CQ580T1VqbhCKsi/yxVCMbhH33YyW/54JgKGxnDjI0zwZGwSaBvzpTwoQsM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mH7N0-001BnG-B0; Fri, 20 Aug 2021 18:27:50 +0200
Date:   Fri, 20 Aug 2021 18:27:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Gade, Jonas" <jonas.gade@rutenbeck.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: mv88e6352 no traffic over phy to phy cpu port
Message-ID: <YR/YBvl5B+DUic9W@lunn.ch>
References: <5874a25e685547e695004d8c3c20d820@rutenbeck.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5874a25e685547e695004d8c3c20d820@rutenbeck.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 02:47:52PM +0000, Gade, Jonas wrote:
> Hi everyone,

> we have a 8devices Carambola2 (running OpenWrt 21, Kernel 5.4)
> connected to mv88e6352 switch on a custom board. On the Carambola2
> MDC is connected to GPIO 19 and MDIO is connected to GPIO 21 (Bit
> banging). The Port 1 of the mv88e6352 is connected to fast ethernet
> port 2 on the internal AR9331 switch.

It appears you are using swconfig for the AR9331 and DSA for the
mv88e6352. I don't think anybody has done that before. Mainline
clearly has not, because swconfig is not part of mainline.

I doubt we can help you much until you swap to a mainline kernel,
preferable 5.13 or net-next, and use the DSA driver for the AR9331.

    Andrew
