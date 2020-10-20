Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98BB293D97
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407627AbgJTNqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:46:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407595AbgJTNqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 09:46:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUryD-002fn4-DM; Tue, 20 Oct 2020 15:46:33 +0200
Date:   Tue, 20 Oct 2020 15:46:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201020134633.GD139700@lunn.ch>
References: <20201008162347.5290-1-dmurphy@ti.com>
 <20201008162347.5290-3-dmurphy@ti.com>
 <20201016220240.GM139700@lunn.ch>
 <31cbfec4-3f1c-d760-3035-2ff9ec43e4b7@ti.com>
 <20201019215506.GY139700@lunn.ch>
 <4add1229-ad74-48e9-064d-e12d62ecc574@ti.com>
 <0e7c70ad-91f0-b3b7-bf28-c258f1a0a0e0@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e7c70ad-91f0-b3b7-bf28-c258f1a0a0e0@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> HW team says no to interoperability.  So we can just add T1L and advertise
> that type.
> 
> The DP83TD510L capability is limited to 10Base-T1L only.

Thanks for checking. We will avoid issues getting this correct from
the start, rather than adding it later, like we did for other T1 PHYs.

    Andrew
