Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B02212532
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgGBNuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:50:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43724 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbgGBNuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:50:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqzbU-003KUp-JR; Thu, 02 Jul 2020 15:50:16 +0200
Date:   Thu, 2 Jul 2020 15:50:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net] net: dsa: microchip: set the correct number of ports
Message-ID: <20200702135016.GL730739@lunn.ch>
References: <20200702094450.1353917-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702094450.1353917-1-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 12:44:50PM +0300, Codrin Ciubotariu wrote:
> The number of ports is incorrectly set to the maximum available for a DSA
> switch. Even if the extra ports are not used, this causes some functions
> to be called later, like port_disable() and port_stp_state_set(). If the
> driver doesn't check the port index, it will end up modifying unknown
> registers.
> 
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks for the minimum patch.

If you wait about a week, net will get merged into net-next. You can
then submit a refactoring patch based on your previous version.

    Andrew
