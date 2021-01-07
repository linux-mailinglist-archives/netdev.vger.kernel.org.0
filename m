Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127632EE77F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbhAGVPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:15:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbhAGVPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 16:15:55 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxccc-00Gkce-NZ; Thu, 07 Jan 2021 22:15:06 +0100
Date:   Thu, 7 Jan 2021 22:15:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: replace mutex_is_locked with
 lockdep_assert_held in phylib
Message-ID: <X/d52l7Xv7i4WtBK@lunn.ch>
References: <ccc40b9d-8ee0-43a1-5009-2cc95ca79c85@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccc40b9d-8ee0-43a1-5009-2cc95ca79c85@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 02:03:40PM +0100, Heiner Kallweit wrote:
> Switch to lockdep_assert_held(_once), similar to what is being done
> in other subsystems. One advantage is that there's zero runtime
> overhead if lockdep support isn't enabled.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
