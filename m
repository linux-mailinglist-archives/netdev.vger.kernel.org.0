Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CB81FDE34
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbgFRBbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:31:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45494 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732759AbgFRBbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:31:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljOj-00134m-HC; Thu, 18 Jun 2020 03:31:21 +0200
Date:   Thu, 18 Jun 2020 03:31:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [net-next PATCH 4/5 v2] net: dsa: rtl8366: VLAN 0 as disable
 tagging
Message-ID: <20200618013121.GE249144@lunn.ch>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
 <20200617083132.1847234-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617083132.1847234-4-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:31:31AM +0200, Linus Walleij wrote:
> The code in net/8021q/vlan.c, vlan_device_event() sets
> VLAN 0 for a VLAN-capable ethernet device when it
> comes up.
> 
> Since the RTL8366 DSA switches must have a VLAN and
> PVID set up for any packets to come through we have
> already set up default VLAN for each port as part of
> bringing the switch online.
> 
> Make sure that setting VLAN 0 has the same effect
> and does not try to actually tell the hardware to use
> VLAN 0 on the port because that will not work.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
