Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBC729150A
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 01:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439927AbgJQXPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 19:15:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTvQV-002CxO-9h; Sun, 18 Oct 2020 01:15:51 +0200
Date:   Sun, 18 Oct 2020 01:15:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Message-ID: <20201017231551.GX456889@lunn.ch>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201017213611.2557565-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Driver statistics, other than those in struct rtnl_link_stats64.
> + * These are collected per-CPU and aggregated by ethtool.
> + */
> +struct dsa_slave_stats {
> +	__u64			tx_reallocs;
> +	struct u64_stats_sync	syncp;
> +} __aligned(1 * sizeof(u64));

The convention seems to be to use a prefix of pcpu_,
e.g. pcpu_sw_netstats, pcpu_lstats.

Also, why __u64? Neither pcpu_sw_netstats nor pcpu_lstats use __u64.

      Andrew
