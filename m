Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E49281208
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgJBMJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:09:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40118 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgJBMJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:09:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kOJsc-00HDA8-SM; Fri, 02 Oct 2020 14:09:42 +0200
Date:   Fri, 2 Oct 2020 14:09:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: b53: Add missing reg
 property to example
Message-ID: <20201002120942.GI4067422@lunn.ch>
References: <20201002062051.8551-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002062051.8551-1-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 08:20:51AM +0200, Kurt Kanzenbach wrote:
> The switch has a certain MDIO address and this needs to be specified using the
> reg property. Add it to the example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
