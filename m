Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D08E3766
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407605AbfJXQFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:05:54 -0400
Received: from muru.com ([72.249.23.125]:39772 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407544AbfJXQFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 12:05:54 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 5D9B280C5;
        Thu, 24 Oct 2019 16:06:27 +0000 (UTC)
Date:   Thu, 24 Oct 2019 09:05:49 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 00/12] net: ethernet: ti: introduce new cpsw
 switchdev based driver
Message-ID: <20191024160549.GY5610@atomide.com>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024100914.16840-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* Grygorii Strashko <grygorii.strashko@ti.com> [191024 10:10]:
> This the RFC v5 which introduces new CPSW switchdev based driver which is 
> operating in dual-emac mode by default, thus working as 2 individual
> network interfaces. The Switch mode can be enabled by configuring devlink driver
> parameter "switch_mode" to 1/true:
> 	devlink dev param set platform/48484000.ethernet_switch \
> 	name switch_mode value 1 cmode runtime

Just wondering about the migration plan.. Is this a replacement
driver or used in addition to the old driver?

Regards,

Tony
