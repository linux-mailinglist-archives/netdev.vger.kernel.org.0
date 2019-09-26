Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CC7BF688
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfIZQS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:18:29 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:50335 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfIZQS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 12:18:29 -0400
X-Originating-IP: 83.56.35.30
Received: from localhost (30.red-83-56-35.staticip.rima-tde.net [83.56.35.30])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 5B8911BF203;
        Thu, 26 Sep 2019 16:18:26 +0000 (UTC)
Date:   Thu, 26 Sep 2019 18:18:25 +0200
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
Message-ID: <20190926161825.GB6825@piout.net>
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
 <506889a6-4148-89f9-302e-4be069595bb4@web.de>
 <20190920190908.GH3530@lunn.ch>
 <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2019 17:29:02+0200, Markus Elfring wrote:
> >> Simplify this function implementation by using a known wrapper function.
> …
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Does this feedback indicate also an agreement for the detail
> if the mapping of internal phy registers would be a required operation?
> (Would such a resource allocation eventually be optional?)

It is optional.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
