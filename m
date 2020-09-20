Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48722714F5
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgITOSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 10:18:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgITOSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 10:18:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kK0AH-00FTwj-Sv; Sun, 20 Sep 2020 16:18:05 +0200
Date:   Sun, 20 Sep 2020 16:18:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v4 2/2] net: mdio-ipq4019: add Clause 45 support
Message-ID: <20200920141805.GA3689762@lunn.ch>
References: <20200920141653.357493-1-robert.marko@sartura.hr>
 <20200920141653.357493-3-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920141653.357493-3-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 04:16:53PM +0200, Robert Marko wrote:
> While up-streaming the IPQ4019 driver it was thought that the controller had no Clause 45 support,
> but it actually does and its activated by writing a bit to the mode register.
> 
> So lets add it as newer SoC-s use the same controller and Clause 45 compliant PHY-s.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
