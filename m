Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FC636FA1A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 14:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhD3MZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 08:25:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhD3MZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 08:25:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcSCS-001oIF-Su; Fri, 30 Apr 2021 14:24:52 +0200
Date:   Fri, 30 Apr 2021 14:24:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH v2 1/1] net: phy: marvell: enable downshift by default
Message-ID: <YIv3FFWQfPF2539m@lunn.ch>
References: <20210430045733.6410-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430045733.6410-1-fido_max@inbox.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 07:57:33AM +0300, Maxim Kochetkov wrote:
> A number of PHYs support the PHY tunable to set and get
> downshift. However, only 88E1116R enables downshift by default. Extend
> this default enabled to all the PHYs that support the downshift
> tunable.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
