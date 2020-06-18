Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB05B1FDF51
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731646AbgFRB3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:29:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732252AbgFRB3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:29:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljMd-00133F-2O; Thu, 18 Jun 2020 03:29:11 +0200
Date:   Thu, 18 Jun 2020 03:29:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [net-next PATCH 3/5 v2] net: dsa: rtl8366: Split out default
 VLAN config
Message-ID: <20200618012911.GD249144@lunn.ch>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
 <20200617083132.1847234-3-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617083132.1847234-3-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:31:30AM +0200, Linus Walleij wrote:
> We loop over the ports to initialize the default VLAN
> and PVID for each port. As we need to reuse the
> code to reinitialize a single port, break out the
> function rtl8366_set_default_vlan_and_pvid().
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
