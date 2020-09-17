Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62EA26E806
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIQWP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:15:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgIQWPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 18:15:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJ2Bv-00F8uw-VY; Fri, 18 Sep 2020 00:15:47 +0200
Date:   Fri, 18 Sep 2020 00:15:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] add virtual PHY for PHY-less devices
Message-ID: <20200917221547.GD3598897@lunn.ch>
References: <20200917214030.646-1-sbauer@blackbox.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917214030.646-1-sbauer@blackbox.su>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 12:40:10AM +0300, Sergej Bauer wrote:
> From: sbauer@blackbox.su
> 
>     Here is a kernel related part of my work which was helps to develop brand
> new PHY device.
> 
>     It is migth be helpful for developers work with PHY-less lan743x
> (7431:0011 in my case). It's just a fake virtual PHY which can change speed of
> network card processing as a loopback device. Baud rate can be tuned with
> ethtool from command line or by means of SIOCSMIIREG ioctl. Duplex mode not
> configurable and it's allways DUPLEX_FULL.

Hi Sergej

What is the advantage of this over using driver/net/phy/fixed_phy.c
which also emulates a standard PHY?

      Andrew
