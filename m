Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922743248B0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhBYB6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:58:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56900 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235086AbhBYB6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:58:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF5u3-008KkI-CC; Thu, 25 Feb 2021 02:57:19 +0100
Date:   Thu, 25 Feb 2021 02:57:19 +0100
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
Subject: Re: [RFC PATCH net-next 11/12] Documentation: networking: switchdev:
 clarify device driver behavior
Message-ID: <YDcD/wEnoSleaN7v@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-12-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +devices and unsolicited multicast must be filtered as early as possible into
> +the hardware.

'into' sounds wrong here. Probably just 'in'.

> +- with VLAN filtering turned off: the bridge is strictly VLAN unaware and its
> +  data path will only process untagged Ethernet frames. Frames ingressing the
> +  device with a VID that is not programmed into the bridge/switch's VLAN table
> +  must be forwarded and may be processed using a VLAN device (see below).

I must be missing something, because these two sentence seems to
contradict each other?

> +Finally, even when VLAN filtering in the bridge is turned off, the underlying
> +switch hardware and driver may still configured itself in a VLAN-aware mode

configure.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
