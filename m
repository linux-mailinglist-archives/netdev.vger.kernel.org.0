Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13774197383
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgC3Eop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:44:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgC3Eoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:44:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A906415C5482C;
        Sun, 29 Mar 2020 21:44:43 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:44:43 -0700 (PDT)
Message-Id: <20200329.214443.1573923323943355565.davem@davemloft.net>
To:     philippe.schenker@toradex.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        mark.rutland@arm.com, linux-kernel@vger.kernel.org,
        silvan.murer@gmail.com, a.fatoum@pengutronix.de,
        s.hauer@pengutronix.de, o.rempel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 2/2] ARM: dts: apalis-imx6qdl: use rgmii-id
 instead of rgmii
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325173425.306802-2-philippe.schenker@toradex.com>
References: <20200325173425.306802-1-philippe.schenker@toradex.com>
        <20200325173425.306802-2-philippe.schenker@toradex.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:44:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Philippe Schenker <philippe.schenker@toradex.com>
Date: Wed, 25 Mar 2020 18:34:25 +0100

> Until now a PHY-fixup in mach-imx set our rgmii timing correctly. For
> the PHY KSZ9131 there is no PHY-fixup in mach-imx. To support this PHY
> too, use rgmii-id.
> For the now used KSZ9031 nothing will change, as rgmii-id is only
> implemented and supported by the KSZ9131.
> 
> Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>

Applied.
