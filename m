Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB29F45F6F2
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 23:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbhKZWqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 17:46:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244913AbhKZWoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 17:44:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=vEWXtK/tCpHD2+pJugCQLUUK33UZEve/ofl63XMeAdc=; b=RM
        FSoXI9di9trA7ThP1nIIuSSrfXHzeFd0dlG7ZfheKhkNFvdc91Dl385NXx2w7OEnVylBwuLAvGWza
        OwGYC+k32HpbKPu9rzxTos0D2+SpojiYD6zPTjx25WhhCoIy1i+JnH+VflxdWu1rFRKpihVl04Z4P
        DDX2WNXg2N5Z+QI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqjuI-00EjY5-3G; Fri, 26 Nov 2021 23:41:26 +0100
Date:   Fri, 26 Nov 2021 23:41:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch:
 convert txt bindings to yaml
Message-ID: <YaFiljIjC6gkScSi@lunn.ch>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211126172739.329098-2-clement.leger@bootlin.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 06:27:36PM +0100, Clément Léger wrote:
> Convert existing txt bindings to yaml format. Additionally, add bindings
> for FDMA support and phy-mode property.

Whenever i see 'additionally' i think a patch is doing two things, and
it should probably be two or more patches. Do these needs to be
combined into one patch?

    Andrew
