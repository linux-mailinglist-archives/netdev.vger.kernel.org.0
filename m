Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C770032486D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbhBYBPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:15:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235019AbhBYBPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:15:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF5EP-008KUp-B0; Thu, 25 Feb 2021 02:14:17 +0100
Date:   Thu, 25 Feb 2021 02:14:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 06/12] Documentation: networking: dsa:
 document the port_bridge_flags method
Message-ID: <YDb56X8EzlobB/2n@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-7-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  the bridge port flags for the CPU port. The assumption is that address
> +  learning should be statically enabled (if supported by the hardware) on the
> +  CPU port, and flooding towards the CPU port should also be enabled, in lack
> +  of an explicit address filtering mechanism in the DSA core.

Hi Vladimir

"in lack of" is a bit odd wording. Maybe "due to a lack of"

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
