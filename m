Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3F25821F
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbgHaTxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgHaTw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:52:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB66C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:52:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B31511289AB77;
        Mon, 31 Aug 2020 12:36:10 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:52:56 -0700 (PDT)
Message-Id: <20200831.125256.1187593109320697104.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, linux@armlinux.org.uk,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v5 0/5] net: phy: add Lynx PCS MDIO module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200830083402.11047-1-ioana.ciornei@nxp.com>
References: <20200830083402.11047-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:36:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Sun, 30 Aug 2020 11:33:57 +0300

> Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> The advantage of this structure is that multiple ethernet or switch
> drivers used on NXP hardware (ENETC, Seville, Felix DSA switch etc) can
> share the same implementation of PCS configuration and runtime
> management.
> 
> The module implements phylink_pcs_ops and exports a phylink_pcs
> (incorporated into a lynx_pcs) which can be directly passed to phylink
> through phylink_pcs_set.
> 
> The first 3 patches add some missing pieces in phylink and the locked
> mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
> standalone module. The majority of the code is extracted from the Felix
> DSA driver. The last patch makes the necessary changes in the Felix and
> Seville drivers in order to use the new common PCS implementation.
> 
> At the moment, USXGMII (only with in-band AN), SGMII, QSGMII (with and
> without in-band AN) and 2500Base-X (only w/o in-band AN) are supported
> by the Lynx PCS MDIO module since these were also supported by Felix and
> no functional change is intended at this time.
 ...

Series applied, thanks.

