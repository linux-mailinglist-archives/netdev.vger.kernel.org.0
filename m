Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA732A103C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgJ3Vbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgJ3Vbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 17:31:49 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D75920796;
        Fri, 30 Oct 2020 21:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604093509;
        bh=SR8sl2q6CMLHE9sZW2ZzyLFMJwsT4eB9TJEHL1XrQmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D8T7RJuf7y4EmCIfNJx6J2eU/NeL6u+20KshASpJGFkKTZtrNeYOfvpn7YnA5dXpy
         rtyigb+d/NGWgFsMVYKUYRDOYhG1NY2262kKAWAMcnem0heT6sDvEF44cMcUJwV7q4
         xBKcofVq5f0awJ511HK+MGw8n2L2N5vHZ7NmHYHI=
Date:   Fri, 30 Oct 2020 14:31:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix vlan setup
Message-ID: <20201030143147.3ad112dc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <E1kYAU3-00071C-1G@rmk-PC.armlinux.org.uk>
References: <E1kYAU3-00071C-1G@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 16:09:03 +0000 Russell King wrote:
> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Allow the VLAN configuration to be updated on Marvell DSA bridges,
> otherwise we end up cutting all traffic when enabling vlan filtering.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks!
