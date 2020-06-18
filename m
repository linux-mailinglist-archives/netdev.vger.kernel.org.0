Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FE51FDFF3
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733086AbgFRBoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:44:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbgFRBoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:44:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljav-0013GB-1Z; Thu, 18 Jun 2020 03:43:57 +0200
Date:   Thu, 18 Jun 2020 03:43:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v7 1/6] dt-bindings: net: Add tx and rx internal
 delays
Message-ID: <20200618014357.GG249144@lunn.ch>
References: <20200617182019.6790-1-dmurphy@ti.com>
 <20200617182019.6790-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617182019.6790-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:20:14PM -0500, Dan Murphy wrote:
> tx-internal-delays and rx-internal-delays are a common setting for RGMII
> capable devices.
> 
> These properties are used when the phy-mode or phy-controller is set to
> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
> controller that the PHY will add the internal delay for the connection.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
