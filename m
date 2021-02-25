Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ABC324891
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhBYBdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:33:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235849AbhBYBdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:33:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF5WQ-008KcD-QB; Thu, 25 Feb 2021 02:32:54 +0100
Date:   Thu, 25 Feb 2021 02:32:54 +0100
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
Subject: Re: [RFC PATCH net-next 09/12] Documentation: networking: dsa: add
 paragraph for the MRP offload
Message-ID: <YDb+RpYrMjB93YrT@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-10-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-10-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +implemented as a function of the bridge driver. MRP uses management PDUs
> +(Test, Topology, LinkDown/Up, Option) sent at a multicast destination MAC

"sent to", or "sent with"

> +address range of 01:15:4e:00:00:0x and with an EtherType of 0x88e3.

address in the range.

	Andrew
