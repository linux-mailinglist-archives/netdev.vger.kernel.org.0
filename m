Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21673248A5
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhBYBms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:42:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56880 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235552AbhBYBmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:42:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF5fI-008Kfh-C1; Thu, 25 Feb 2021 02:42:04 +0100
Date:   Thu, 25 Feb 2021 02:42:04 +0100
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
Subject: Re: [RFC PATCH net-next 10/12] Documentation: networking: dsa: add
 paragraph for the HSR/PRP offload
Message-ID: <YDcAbFkT+OkE70kh@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-11-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +IEC 62439-3 (HSR/PRP)
> +---------------------
> +
> +The Parallel Redundancy Protocol (PRP) is a network redundancy protocol which
> +works by duplicating and sequence numbering packets through two independent L2
> +networks (which are unaware of the PRP tail tags carried in the packets), and
> +eliminating the duplicates at the receiver. The High-availability Seamless
> +Redundancy (HSR) protocol is similar in concept, except all nodes that carry
> +the redundant traffic are aware of the fact that it is HSR-tagged (because HSR
> +uses a header with an EtherType of 0x892f) and are physically connected in a
> +ring topology. Both HSR and PRP use supervision frames for monitoring the

I don't know HSR/PRP terms. Should it be supervisory instead of
supervision?

> +health of the network and for discovering the other nodes.

Either "discovering other nodes" or "discovery of other nodes".

> +
> +In Linux, both HSR and PRP are implemented in the hsr driver, which
> +instantiates a virtual, stackable network interface with two member ports.
> +The driver only implements the basic roles of DANH (Doubly Attached Node
> +implementing HSR) and DANP (Doubly Attached Node implementing PRP); the roles
> +of RedBox and QuadBox aren't (therefore, bridging a hsr network interface with

In colloquial English, you can get away with just 'aren't'. But in
Queens English, you should follow it with something, in this case
'supported'.

	Andrew
