Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CBA323218
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhBWU2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:28:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhBWU2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:28:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E9A64E7A;
        Tue, 23 Feb 2021 20:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614112059;
        bh=vmU5F26YgOkAtvLHpvo5c4HHGCzi+SVsCuih77MNkSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uo40ikqkpz2E2piSdQmYNzoyShenJ3gq5N7P332Zu1GIM0L9iu5mtMkVV2TY+Ehzn
         0cHhpzaDQraHAZKrMqrXIEmDinzn3/xCrdmtuyKohXs/fpeorDokecyrH2T+mrfPTp
         M3cSYTRtnovSJNniyfsRZxZO9OxEQEIbwozU7QrUUh+1d2dtHmzVl6ZSlJ45WxQlvq
         nGHJ8Dy12kMAm6CLXpnLMOSvc/+EJw+4me0GkaxnoIGrO4S74CcVLVbRDYa8V5Y6rk
         w2FlhnfXl/QLnJANqm6TO742oWrb+Z8Z+HEtqO5/Nf0T5+qefSy8c7f3Ov69XJha4S
         aV5kxLKk6q/yw==
Date:   Tue, 23 Feb 2021 12:27:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net v2 0/2] net: dsa: Learning fixes for b53/bcm_sf2
Message-ID: <20210223122735.699660e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222223010.2907234-1-f.fainelli@gmail.com>
References: <20210222223010.2907234-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 14:30:08 -0800 Florian Fainelli wrote:
> This patch series contains a couple of fixes for the b53/bcm_sf2 drivers
> with respect to configuring learning.
> 
> The first patch is wiring-up the necessary dsa_switch_ops operations in
> order to support the offloading of bridge flags.
> 
> The second patch corrects the switch driver's default learning behavior
> which was unfortunately wrong from day one.
> 
> This is submitted against "net" because this is technically a bug fix
> since ports should not have had learning enabled by default but given
> this is dependent upon Vladimir's recent br_flags series, there is no
> Fixes tag provided.
> 
> I will be providing targeted stable backports that look a bit
> difference.

Applied, thanks!
