Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983283240AD
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbhBXPTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:19:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236376AbhBXNrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:47:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lEuUP-008ETR-Q5; Wed, 24 Feb 2021 14:46:05 +0100
Date:   Wed, 24 Feb 2021 14:46:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev@vger.kernel.org, aford@beaconembedded.com,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/5] arm64: dts: renesas: Add fck to
 etheravb-rcar-gen3 clock-names list
Message-ID: <YDZYnUeVL4+tzNTF@lunn.ch>
References: <20210224115146.9131-1-aford173@gmail.com>
 <20210224115146.9131-3-aford173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224115146.9131-3-aford173@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 05:51:43AM -0600, Adam Ford wrote:
> The bindings have been updated to support two clocks, but the
> original clock now requires the name fck.  Add a clock-names
> list in the device tree with fck in it.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
