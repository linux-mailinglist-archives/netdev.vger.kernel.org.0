Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B892124EC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgGBNip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:38:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43690 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729115AbgGBNio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:38:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqzQI-003KOo-Da; Thu, 02 Jul 2020 15:38:42 +0200
Date:   Thu, 2 Jul 2020 15:38:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Subject: Re: [net-next,PATCH 4/4] dt-bindings: mdio-ipq4019: add clock support
Message-ID: <20200702133842.GK730739@lunn.ch>
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-5-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702103001.233961-5-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  clock-frequency:
> +    default: 100000000

IEEE 802.3 says the default should be 2.5MHz. Some PHYs will go
faster, but 100MHz seems unlikely!

     Andrew
