Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3632912888D
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 11:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfLUKc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 05:32:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfLUKc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 05:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZLLUZpJnkLBntPrYgkZ0eLvRTG/5CNGD+v3mJn84hSk=; b=OwW0n1L0KvKRDIyRlO4VVPDj9i
        USJza6Tk50WRSt/K9YTIG0PgYGrTwcqKEoujlyx1ZZUJmkA+e06N8On1sebEy9/4fKTS6JdaxVw5i
        czkaSMQcyfVh2DmpuyH9+YYWcgWsNygjJkFLxStAVD06atmPV5QeEirtfn0ZEXZolXQY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iic3a-0008Qc-Sp; Sat, 21 Dec 2019 11:32:22 +0100
Date:   Sat, 21 Dec 2019 11:32:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V7 net-next 07/11] net: Add a layer for non-PHY MII time
 stamping drivers.
Message-ID: <20191221103222.GB30801@lunn.ch>
References: <cover.1576865315.git.richardcochran@gmail.com>
 <eb6976012724b50a9d830eafd048e6956d8a3be0.1576865315.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6976012724b50a9d830eafd048e6956d8a3be0.1576865315.git.richardcochran@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 10:15:16AM -0800, Richard Cochran wrote:
> While PHY time stamping drivers can simply attach their interface
> directly to the PHY instance, stand alone drivers require support in
> order to manage their services.  Non-PHY MII time stamping drivers
> have a control interface over another bus like I2C, SPI, UART, or via
> a memory mapped peripheral.  The controller device will be associated
> with one or more time stamping channels, each of which sits snoops in
> on a MII bus.
> 
> This patch provides a glue layer that will enable time stamping
> channels to find their controlling device.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
