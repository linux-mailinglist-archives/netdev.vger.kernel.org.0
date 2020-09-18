Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5CC26EA31
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIRA66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:58:58 -0400
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:48000 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgIRA66 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 20:58:58 -0400
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id D656F82D06;
        Fri, 18 Sep 2020 03:59:25 +0300 (MSK)
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] add virtual PHY for PHY-less devices
Date:   Fri, 18 Sep 2020 03:58:40 +0300
Message-ID: <2016817.gfEZhycloL@metabook>
In-Reply-To: <b708f713-4840-7521-1d3d-e4aba5b3fc5e@gmail.com>
References: <20200917214030.646-1-sbauer@blackbox.su> <b708f713-4840-7521-1d3d-e4aba5b3fc5e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian

  The fixed-PHY driver looks a little bit hardly tunable, please look at
https://www.lkml.org/lkml/2020/9/17/1424
  This is not my idea. This is a request of HW team, and I thnk it will be
useful for someone else. But I'll try to combine fixed-phy with virtual-PHY
tomorrow. It just to rearrange some lines in lan743x_phy_open.

-- 
                                                Sergej

On Friday, September 18, 2020 1:16:30 AM MSK Florian Fainelli wrote:
> On 9/17/2020 2:40 PM, Sergej Bauer wrote:
> > From: sbauer@blackbox.su
> > 
> >      Here is a kernel related part of my work which was helps to develop
> >      brand
> > 
> > new PHY device.
> > 
> >      It is migth be helpful for developers work with PHY-less lan743x
> > 
> > (7431:0011 in my case). It's just a fake virtual PHY which can change
> > speed of network card processing as a loopback device. Baud rate can be
> > tuned with ethtool from command line or by means of SIOCSMIIREG ioctl.
> > Duplex mode not configurable and it's allways DUPLEX_FULL.
> > 
> >      It also provides module parameter mii_regs for setting initial values
> >      of
> > 
> > IEEE 802.3 Control Register.
> 
> You appear to have re-implemented the fixed PHY driver, please use that
> instead of rolling your own.




