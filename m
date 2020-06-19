Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59631200D9B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 17:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390480AbgFSO7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:59:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49082 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390461AbgFSO7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 10:59:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmITz-001Hqv-DZ; Fri, 19 Jun 2020 16:59:07 +0200
Date:   Fri, 19 Jun 2020 16:59:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/3] net: phy: marvell: Add Marvell 88E1340S support
Message-ID: <20200619145907.GK279339@lunn.ch>
References: <20200619084904.95432-1-fido_max@inbox.ru>
 <20200619084904.95432-3-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619084904.95432-3-fido_max@inbox.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:49:03AM +0300, Maxim Kochetkov wrote:
> Add support for this new phy ID.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
