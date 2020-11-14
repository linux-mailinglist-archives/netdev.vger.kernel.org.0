Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E31B2B2E43
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 16:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgKNP4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 10:56:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbgKNP4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 10:56:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdxuQ-0072eL-5E; Sat, 14 Nov 2020 16:56:14 +0100
Date:   Sat, 14 Nov 2020 16:56:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Cc:     netdev@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        f.fainelli@gmail.com, marek.behun@nic.cz, vivien.didelot@gmail.com,
        info <info@turris.cz>
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
Message-ID: <20201114155614.GZ1480543@lunn.ch>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
 <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 1) with isc-dhcp-server configured with very short lease times (180
> seconds). After mox reboot (or systemctl restart systemd-networkd)
> clients successfully obtain a lease and a couple of RENEWs (requested
> after 90 seconds) but then all goes silent, Mox OS no longer sees the
> IPv6 multicast RENEW packets and client leases expire.

So it takes about 3 minutes to reproduce this?

Can you do a git bisect to figure out which change broke it? It will
take you maybe 5 minutes per step, and given the wide range of
kernels, i'm guessing you need around 15 steps. So maybe two hours of
work.

	Andrew
