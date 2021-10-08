Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A8C42626E
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 04:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhJHCZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 22:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhJHCZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 22:25:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EFDD6103C;
        Fri,  8 Oct 2021 02:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633659785;
        bh=vv1BjdqYFGtWCazSG8NawFHuPDrSlMXWmYEnP/7By6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W2F3NAL2PNL4YfcB+pCHgbHTe0iP1tVFeDtvsB/Qn7kwC5aDjFqzJFXUUg8EiNBqu
         62h60wb7G6UG05e84hJxcE6x3tcRDAW85PtWo9ELjXf6zSBUkT1toU5CtHx+hRI6j7
         GgD+oYjYorJK6bLrEErM4o6H2iKOp0u928v5xyyyQXSkjmjJOENuumDOuWQTI7zTuR
         ZJ+I1MNj7s3Gs4g+PHBFr/0FZcBIxoeZicM/geGgOnaW/D4zhIexJugXYDtSEu6eP+
         qtQbvd/qFU5SqaMLqVwjBpe0Uyv88JUELURqe9YtMJRb4OEXKhGg/aFITA+Gzb2sKn
         ZD8kr14Ny9VyQ==
Date:   Thu, 7 Oct 2021 19:23:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net PATCH v2 01/15] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <20211007192304.7a9acabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008002225.2426-2-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
        <20211008002225.2426-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Oct 2021 02:22:11 +0200 Ansuel Smith wrote:
> From Documentation phy resume triggers phy reset and restart
> auto-negotiation. Add a dedicated function to wait reset to finish as
> it was notice a regression where port sometime are not reliable after a
> suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> Add dedicated suspend function to use genphy_suspend only with QCA8337
> phy and set only additional debug settings for QCA8327. With more test
> it was reported that QCA8327 doesn't proprely support this mode and
> using this cause the unreliability of the switch ports, especially the
> malfunction of the port0.
> 
> Fixes: 52a6cdbe43a3 ("net: phy: at803x: add resume/suspend function to qca83xx phy")

Strange, checkpatch catches the wrong hash being used, but the
verify_fixes script doesn't. Did you mean:

Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")

Or is 52a6cdbe43a3 the correct commit hash? Same question for patch 2.


The fixes have to be a _separate_ series.
