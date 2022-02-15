Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A114B6BD0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiBOMPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:15:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiBOMO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:14:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEBF1074C8;
        Tue, 15 Feb 2022 04:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bs8klJwTLBDrvOVFtUAi+wX0579+9qYln0qvbgucQxU=; b=kNOkfgULpIWj99EbMjYsAtK/ER
        2k8hgD8HcmXdPG/f5f3jKawpdoJTKDOVK/fBPHAmX0FOID7w5KbFJ1N+MqhLEuobMCJsNX4OqK1Y3
        SLmZwN/EJ4YBUxE91kezOy2wVEvqO+rDmTfL4ScUoJX+UNn5+yMEJhXzD3UaWfUwanJw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nJwj3-00655L-Hw; Tue, 15 Feb 2022 13:14:33 +0100
Date:   Tue, 15 Feb 2022 13:14:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] net: dsa: lantiq_gswip: fix use after free in
 gswip_remove()
Message-ID: <YguZKd6F2CNWdhLX@lunn.ch>
References: <1644921768-26477-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644921768-26477-1-git-send-email-khoroshilov@ispras.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 01:42:48PM +0300, Alexey Khoroshilov wrote:
> of_node_put(priv->ds->slave_mii_bus->dev.of_node) should be
> done before mdiobus_free(priv->ds->slave_mii_bus).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Fixes: 0d120dfb5d67 ("net: dsa: lantiq_gswip: don't use devres for mdiobus")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
