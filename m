Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FED7AE44
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbfG3Qol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:44:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfG3Qok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:44:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE2DD1264D9A4;
        Tue, 30 Jul 2019 09:44:39 -0700 (PDT)
Date:   Tue, 30 Jul 2019 09:44:36 -0700 (PDT)
Message-Id: <20190730.094436.855806617449032791.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     andrew@lunn.ch, robh+dt@kernel.org, leoyang.li@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/4] enetc: Add mdio bus driver for the
 PCIe MDIO endpoint
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564479919-18835-1-git-send-email-claudiu.manoil@nxp.com>
References: <1564479919-18835-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 09:44:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Tue, 30 Jul 2019 12:45:15 +0300

> First patch fixes a sparse issue and cleans up accessors to avoid
> casting to __iomem.
> Second patch just registers the PCIe endpoint device containing
> the MDIO registers as a standalone MDIO bus driver, to allow
> an alternative way to control the MDIO bus.  The same code used
> by the ENETC ports (eth controllers) to manage MDIO via local
> registers applies and is reused.
> 
> Bindings are provided for the new MDIO node, similarly to ENETC
> port nodes bindings.
> 
> Last patch enables the ENETC port 1 and its RGMII PHY on the
> LS1028A QDS board, where the MDIO muxing configuration relies
> on the MDIO support provided in the first patch.
 ...

Series applied, thank you.
