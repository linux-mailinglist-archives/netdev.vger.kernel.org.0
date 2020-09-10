Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CDA264F07
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgIJTdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgIJTdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:33:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9133C061573;
        Thu, 10 Sep 2020 12:32:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A65712A2C208;
        Thu, 10 Sep 2020 12:16:11 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:32:57 -0700 (PDT)
Message-Id: <20200910.123257.1333858679864684014.davem@davemloft.net>
To:     helmut.grohne@intenta.de
Cc:     nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: dsa: microchip: look for phy-mode in port nodes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908080136.GA14279@laureti-dev>
References: <20200907125555.GO3164319@lunn.ch>
        <20200908080136.GA14279@laureti-dev>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:16:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>
Date: Tue, 8 Sep 2020 10:01:38 +0200

> Documentation/devicetree/bindings/net/dsa/dsa.txt says that the phy-mode
> property should be specified on port nodes. However, the microchip
> drivers read it from the switch node.
> 
> Let the driver use the per-port property and fall back to the old
> location with a warning.
> 
> Fix in-tree users.
> 
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
> Link: https://lore.kernel.org/netdev/20200617082235.GA1523@laureti-dev/
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Applied, thanks.
