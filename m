Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4658E7E6B
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 03:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfJ2CIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 22:08:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39484 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfJ2CIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 22:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RNmlArHoh/2GlPBVh7E1KN5ZmvJmTtZTaxq8xLwAhLU=; b=ZdXqSHT+d6HUuRebCRRKY5Fw1T
        WG+6h/8TOsAydWd6N5xavrY+lcSun4tvdWfgiJKNRzDoviROEO1uCHsnhHwNrK04fCQxdyFvVHu5I
        NjyjSL/JJofsinecYptKdVYa2NWQ4abLdsH/ikVKM9gZ03sy8RFsJy5sXfO6UHwnEtE8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPGva-0001K9-M1; Tue, 29 Oct 2019 03:08:10 +0100
Date:   Tue, 29 Oct 2019 03:08:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 5/5] net: documentation: add docs for MAC/PHY
 support in DPAA2
Message-ID: <20191029020810.GJ15259@lunn.ch>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
 <1571998630-17108-6-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571998630-17108-6-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +DPAA2 Software Architecture
> +---------------------------
> +
> +Among other DPAA2 objects, the fsl-mc bus exports DPNI objects (abstracting a
> +network interface) and DPMAC objects (abstracting a MAC). The dpaa2-eth driver
> +probes on the DPNI object and connects to and configures a DPMAC object with
> +the help of phylink.

Does a DPMAC object always connect to a PHY? Can a DPMAC connect to
another DPMAC? I guess you would not normally do that, you would
connect a DPNI to a DPNI? But can you connect a DPMAC to a switch?

I guess it actually does not matter. Phylib/Phylink has the concept of
a fixed-link, which is used when there is no PHY and you need to
emulate it in order to configure the MAC. That will work here.

	Andrew
