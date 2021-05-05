Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB62373352
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhEEAtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:49:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEAtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:49:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5iA-002Z2Y-Ji; Wed, 05 May 2021 02:48:22 +0200
Date:   Wed, 5 May 2021 02:48:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 09/20] devicetree: net: dsa: qca8k:
 Document new compatible qca8327
Message-ID: <YJHrViP8HhzXh5w5@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:03AM +0200, Ansuel Smith wrote:
> Add support for qca8327 in the compatible list.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
