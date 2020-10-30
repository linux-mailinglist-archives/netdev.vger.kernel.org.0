Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3842A0ED6
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgJ3Tnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:43:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgJ3Tnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 15:43:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYaJD-004PDd-9A; Fri, 30 Oct 2020 20:43:35 +0100
Date:   Fri, 30 Oct 2020 20:43:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] ethtool: Add 10base-T1L link mode entries
Message-ID: <20201030194335.GC1042051@lunn.ch>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030172950.12767-2-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 12:29:47PM -0500, Dan Murphy wrote:
> Add entries for the 10base-T1L full and half duplex supported modes.
> 
> $ ethtool eth0
>         Supported ports: [ TP ]
>         Supported link modes:   10baseT1L/Half 10baseT1L/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT1L/Half 10baseT1L/Full
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: 10Mb/s
>         Duplex: Full
>         Auto-negotiation: on
>         Port: MII
>         PHYAD: 1
>         Transceiver: external
>         Supports Wake-on: gs
>         Wake-on: d
>         SecureOn password: 00:00:00:00:00:00
>         Current message level: 0x00000000 (0)
> 
>         Link detected: yes
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
