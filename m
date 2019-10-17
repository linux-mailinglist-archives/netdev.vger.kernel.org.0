Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60583DB59E
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441188AbfJQSLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:11:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395229AbfJQSLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:11:03 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A5D513FCB177;
        Thu, 17 Oct 2019 11:11:02 -0700 (PDT)
Date:   Thu, 17 Oct 2019 14:11:01 -0400 (EDT)
Message-Id: <20191017.141101.365756703972576189.davem@davemloft.net>
To:     alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, vz@mleia.com, slemieux.tyco@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] net: lpc_eth: parse phy nodes from device tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017094757.26885-2-alexandre.belloni@bootlin.com>
References: <20191017094757.26885-1-alexandre.belloni@bootlin.com>
        <20191017094757.26885-2-alexandre.belloni@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 11:11:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date: Thu, 17 Oct 2019 11:47:57 +0200

> When connected to a micrel phy, phy_find_first doesn't work properly
> because the first phy found is on address 0, the broadcast address but, the
> first thing the phy driver is doing is disabling this broadcast address.
> The phy is then available only on address 1 but the mdio driver doesn't
> know about it.
> 
> Instead, register the mdio bus using of_mdiobus_register and try to find
> the phy description in device tree before falling back to phy_find_first.
> 
> This ultimately also allows to describe the interrupt the phy is connected
> to.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

You need to respin this series because this patch doesn't apply to any of
the networking trees.
