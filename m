Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6489ABFA21
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfIZTcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 15:32:43 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54795 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbfIZTcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 15:32:42 -0400
X-Originating-IP: 83.56.35.30
Received: from localhost (30.red-83-56-35.staticip.rima-tde.net [83.56.35.30])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 4895240003;
        Thu, 26 Sep 2019 19:32:40 +0000 (UTC)
Date:   Thu, 26 Sep 2019 21:32:39 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [1/2] net/phy/mdio-mscc-miim: Use
 devm_platform_ioremap_resource() in mscc_miim_probe()
Message-ID: <20190926193239.GC6825@piout.net>
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
 <506889a6-4148-89f9-302e-4be069595bb4@web.de>
 <20190920190908.GH3530@lunn.ch>
 <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
 <20190926161825.GB6825@piout.net>
 <0a1f4dbf-4cc6-8530-a38e-31c3369e6db6@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a1f4dbf-4cc6-8530-a38e-31c3369e6db6@web.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2019 20:52:38+0200, Markus Elfring wrote:
> >> Does this feedback indicate also an agreement for the detail
> >> if the mapping of internal phy registers would be a required operation?
> >> (Would such a resource allocation eventually be optional?)
> >
> > It is optional.
> 
> Would you like to integrate an other patch variant then?
> 

You have to ensure it stays optional. Also, adjust the subject so it
uses the correct prefix.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
