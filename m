Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADC3487A8D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbiAGQkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:40:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58928 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239952AbiAGQky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:40:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4791061F4D
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580E1C36AE0;
        Fri,  7 Jan 2022 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641573653;
        bh=Z4EjiGDl+FWry+Og4Es7u/EtFzY4/HUJHpQU6FI/TrY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihMYCBrWQtRNhwXOxINiXRLhGKwV7wrsoRplK9LE7KyIwFKsGMaiP5gUo5mipqRfJ
         /B4u1Okmza2KXY63aLC24xSMpOzRUoWQQL4ZYgkULJ6MkcoPAQLPac3h/zQi9w7VbI
         kn8wIjgXreP421Nk6RBOBPKlXUmfpS3TFlu4pkS6ZTEPfzYB3/jB7+NTz4LYPmquzZ
         i/WWnY2GuWg5KHLiqVK/h82T9Zvq054C4BDF2rscpnwWo1sl+lIwm/m8mLoDGWjaql
         mU7I2znejjLsBt7ooPZF2YfFlkIe1qPl0FMk6P3wAjXMAR3Wvp9UHSfuDI/EzSz/+K
         92XPbjYbg+nOQ==
Date:   Fri, 7 Jan 2022 08:40:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: mscc: ocelot: fix incorrect balancing with
 down LAG ports
Message-ID: <20220107084052.737c91bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220107135839.237534-1-vladimir.oltean@nxp.com>
References: <20220107135839.237534-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jan 2022 15:58:39 +0200 Vladimir Oltean wrote:
> Assuming the test setup described here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210205130240.4072854-1-vladimir.oltean@nxp.com/
> (swp1 and swp2 are in bond0, and bond0 is in a bridge with swp0)
> 
> it can be seen that when swp1 goes down (on either board A or B), then
> traffic that should go through that port isn't forwarded anywhere.

This only applies to net-next. Could you resend with the subject
tag changed? The tree probably doesn't matter at this point and 
would be nice to get it properly build-tested.
