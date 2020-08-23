Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4120F24EDA2
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 16:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHWOXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 10:23:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40462 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgHWOXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 10:23:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9quA-00BN08-D4; Sun, 23 Aug 2020 16:23:30 +0200
Date:   Sun, 23 Aug 2020 16:23:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: dsa: Fix typo
Message-ID: <20200823142330.GC2588906@lunn.ch>
References: <20200823121836.16441-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823121836.16441-1-kurt@kmk-computers.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 02:18:36PM +0200, Kurt Kanzenbach wrote:
> Fix spelling mistake documenation -> documentation.
> 
> Fixes: 5a18bb14c0f7 ("dt-bindings: net: dsa: Let dsa.txt refer to dsa.yaml")
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
