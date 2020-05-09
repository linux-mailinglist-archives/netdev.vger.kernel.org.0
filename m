Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA7D1CC2EA
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgEIQ47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:56:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgEIQ47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c1EdFOtJK8exrDN02KMPnX4sfvNbsWPWPXGrPUo74Es=; b=meXD+qHTHJzx5MeF/i522YUqr1
        RxzIaNWNAOqqOFWPw7uMfEdYA9x7yL0nRpy6UN+txn4i1ToZOckdUER8fLY4FUFnesDo+G3u2yEJk
        DZDEO6nGG8kdvT4rHWtNMl7AMCDE1xcLL6WfrY4Xwfhg2Hn/M3Fn8rAwQ9gDGLnop1Nc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSmW-001WVm-GE; Sat, 09 May 2020 18:56:56 +0200
Date:   Sat, 9 May 2020 18:56:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH v3 4/5] ksz: Add Microchip KSZ8863 SMI/SPI based driver
 support
Message-ID: <20200509165656.GB362499@lunn.ch>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-5-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508154343.6074-5-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 05:43:42PM +0200, Michael Grzeschik wrote:
> Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
> switches using the Microchip SMI Interface. They are currently only
> supported using the MDIO-Bitbang Interface. Which is making use of the
> mdio_ll_read/write functions. The patch uses the common functions
> from the ksz8795 driver.

This patch is pretty hard to review. It is huge, and making multiple
changes all at once.

Please break it up into a number of smaller changes.

       Andrew
