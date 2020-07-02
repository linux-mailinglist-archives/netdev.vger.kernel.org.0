Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF2C212485
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgGBNZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:25:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgGBNZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:25:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqzDJ-003KHp-0E; Thu, 02 Jul 2020 15:25:17 +0200
Date:   Thu, 2 Jul 2020 15:25:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Subject: Re: [net-next,PATCH 1/4] net: mdio-ipq4019: change defines to upper
 case
Message-ID: <20200702132516.GH730739@lunn.ch>
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-2-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702103001.233961-2-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 12:29:58PM +0200, Robert Marko wrote:
> In the commit adding the IPQ4019 MDIO driver, defines for timeout and sleep partially used lower case.
> Lets change it to upper case in line with the rest of driver defines.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
