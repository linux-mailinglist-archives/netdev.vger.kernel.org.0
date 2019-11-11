Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E44F797C
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 18:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKKRIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 12:08:43 -0500
Received: from muru.com ([72.249.23.125]:41552 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfKKRIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 12:08:43 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 678BE8047;
        Mon, 11 Nov 2019 17:09:11 +0000 (UTC)
Date:   Mon, 11 Nov 2019 09:08:26 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Sekhar Nori <nsekhar@ti.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 00/12] net: ethernet: ti: introduce new cpsw
 switchdev based driver
Message-ID: <20191111170826.GT5610@atomide.com>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024160549.GY5610@atomide.com>
 <dc621a9d-eb92-5df9-81d7-ad2b037ac3c7@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc621a9d-eb92-5df9-81d7-ad2b037ac3c7@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [191109 15:16]:
> Hi Tony,
> 
> On 24/10/2019 19:05, Tony Lindgren wrote:
> > Hi,
> > 
> > * Grygorii Strashko <grygorii.strashko@ti.com> [191024 10:10]:
> > > This the RFC v5 which introduces new CPSW switchdev based driver which is
> > > operating in dual-emac mode by default, thus working as 2 individual
> > > network interfaces. The Switch mode can be enabled by configuring devlink driver
> > > parameter "switch_mode" to 1/true:
> > > 	devlink dev param set platform/48484000.ethernet_switch \
> > > 	name switch_mode value 1 cmode runtime
> > 
> > Just wondering about the migration plan.. Is this a replacement
> > driver or used in addition to the old driver?
> > 
> 
> Sry, I've missed you mail.
> 
> As it's pretty big change the idea is to keep both drivers at least for sometime.
> Step 1: add new driver and enable it on one platform. Do announcement.
> Step 2: switch all one-port and dual mac drivers to the new driver
> Step 3: switch all other platform to cpsw switchdev and deprecate old driver.

OK sounds good to me. So for the dts changes, we keep the old binding
and just add a new module there?

Or do you also have to disable some parts of the old dts?

Regards,

Tony
