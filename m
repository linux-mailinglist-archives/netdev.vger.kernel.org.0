Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5BC1AA38C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506093AbgDONL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:11:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506082AbgDONLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 09:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d/88LlrJNj/d4F115V1sgd+wWhjG+NBIkF8dbPSMqas=; b=JVrgbH7sW3JE9NF1Z62PGLkZVF
        /srK65laMmHpoN9pXWL7MZLX2syPIyp42MB9L4RzHCghJyBGg6z7QjkWjKHXRg5A0ALyCuLgXOZgM
        uSbkO6RV3HWzolZuxKjMZanEWE2AGJeXKw51SeuLTBwMM3dddKrHJ1mbinkNVUjxADNM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOhom-002sd1-1u; Wed, 15 Apr 2020 15:11:04 +0200
Date:   Wed, 15 Apr 2020 15:11:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200415131104.GA657811@lunn.ch>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415121209.12197-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 02:12:09PM +0200, Oleksij Rempel wrote:
> This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> auto-negotiation support, we needed to be able to configure the
> MASTER-SLAVE role of the port manually or from an application in user
> space.

Hi Oleksij

This is a nice way to do this.

> +/* Port mode */
> +#define PORT_MODE_MASTER	0x00
> +#define PORT_MODE_SLAVE		0x01
> +#define PORT_MODE_MASTER_FORCE	0x02
> +#define PORT_MODE_SLAVE_FORCE	0x03
> +#define PORT_MODE_UNKNOWN	0xff

It is not clear to me what PORT_MODE_MASTER and PORT_MODE_SLAVE. Do
these mean to negotiate master/slave? Maybe some comments, or clearer
names?

	Andrew
