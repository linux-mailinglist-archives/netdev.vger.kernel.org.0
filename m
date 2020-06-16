Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610CB1FB517
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgFPOzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:55:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgFPOzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 10:55:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlCzL-000pVy-3q; Tue, 16 Jun 2020 16:54:59 +0200
Date:   Tue, 16 Jun 2020 16:54:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH 01/02] net: phy: marvell: Add Marvell 88E1340 support
Message-ID: <20200616145459.GA197468@lunn.ch>
References: <3fcbc447-877d-0e95-af39-86fc72a34e10@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fcbc447-877d-0e95-af39-86fc72a34e10@inbox.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 10:01:11AM +0300, Maxim Kochetkov wrote:
> Add Marvell 88E1340 support

Hi Maxim

Are you sure this is an 88E1340, not a 88E1340S?

Marvells DSDT SDK has:

    MAD_88E1340S = 0x1C,    /* 88E1340S */
    MAD_88E1340  = 0x1e,    /* 88E1340/x0a */
    MAD_88E1340M = 0x1f,    /* 88E1340M/x0a */
 
>  #define MARVELL_PHY_ID_88E1149R		0x01410e50
>  #define MARVELL_PHY_ID_88E1240		0x01410e30
>  #define MARVELL_PHY_ID_88E1318S		0x01410e90
> +#define MARVELL_PHY_ID_88E1340		0x01410dc0
>  #define MARVELL_PHY_ID_88E1116R		0x01410e40
>  #define MARVELL_PHY_ID_88E1510		0x01410dd0
>  #define MARVELL_PHY_ID_88E1540		0x01410eb0

For 88E1340 i would expect the ID to be 0x01410de0

    Andrew
