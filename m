Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA6426E9E8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRARc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:17:32 -0400
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:47940 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIRARc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 20:17:32 -0400
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id A2B868195C;
        Fri, 18 Sep 2020 03:17:59 +0300 (MSK)
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] add virtual PHY for PHY-less devices
Date:   Fri, 18 Sep 2020 03:17:14 +0300
Message-ID: <1680322.qRJ2Tc3Qy1@metabook>
In-Reply-To: <20200917221547.GD3598897@lunn.ch>
References: <20200917214030.646-1-sbauer@blackbox.su> <20200917221547.GD3598897@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

  To tell the truth, I thought that fixed_phy is only for devices with a Device
Trees and I never met DTS on x86 machines... 

So it looks like there realy no any significant advantage _except_ of
ability to use ethtool and ioctl to set speed and rx-all/fcs flags without
removing module. That was most wanted request from HW designers as they are
wanted to change registers of virtual PHY on-the-fly with ethtool either custom
tool (using SIOCSMIIREG ioctl) for controling PHY registers.

p.s. And that's my bad, the original driver was developed year ago (for 
linux-5.2.15),
but I had no time before this moment.


p.p.s. sorry for long time to answer but it's far behind the midnight in my 
region.

-- 
                                        Sergej


On Friday, September 18, 2020 1:15:47 AM MSK Andrew Lunn wrote:
> On Fri, Sep 18, 2020 at 12:40:10AM +0300, Sergej Bauer wrote:
> > From: sbauer@blackbox.su
> > 
> >     Here is a kernel related part of my work which was helps to develop
> >     brand
> > 
> > new PHY device.
> > 
> >     It is migth be helpful for developers work with PHY-less lan743x
> > 
> > (7431:0011 in my case). It's just a fake virtual PHY which can change
> > speed of network card processing as a loopback device. Baud rate can be
> > tuned with ethtool from command line or by means of SIOCSMIIREG ioctl.
> > Duplex mode not configurable and it's allways DUPLEX_FULL.
> 
> Hi Sergej
> 
> What is the advantage of this over using driver/net/phy/fixed_phy.c
> which also emulates a standard PHY?
> 
>       Andrew




