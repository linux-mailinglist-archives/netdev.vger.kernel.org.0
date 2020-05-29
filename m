Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480E91E7B55
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgE2LLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgE2LLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 07:11:09 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B18C03E969;
        Fri, 29 May 2020 04:11:09 -0700 (PDT)
Received: from [IPv6:2a02:810c:c200:2e91:c5de:fbc5:d517:dd4f] (unknown [IPv6:2a02:810c:c200:2e91:c5de:fbc5:d517:dd4f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EC56822F00;
        Fri, 29 May 2020 13:11:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590750664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gJBtfDC8Gbsc3WVhcu8v47PRfEmyI/yc6+d2gBht10=;
        b=vN1Lrdc6IcsLtQ3QPRqbT1Dfcjk9MYJzdDjBi5t1bRwcVSW4UcLYMQSshfNbTGlqKLRcH1
        jFwnoGaNwF8V89xoiCd5EosezGT5NikEPiYLz+uNiHsF++ZE+c+DiVc1ecR9nlz2s9eh9F
        D+DwKQtLVAN1UmuS63G0e+8WKviu9vo=
Date:   Fri, 29 May 2020 13:11:00 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20200529094909.1254629-1-antoine.tenart@bootlin.com>
References: <20200529094909.1254629-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next] net: phy: mscc: fix PHYs using the vsc8574_probe
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
CC:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Michael Walle <michael@walle.cc>
Message-ID: <223CE44E-8ACF-4F31-B5EC-FA5468F9D54A@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 29=2E Mai 2020 11:49:09 MESZ schrieb Antoine Tenart <antoine=2Etenart@bo=
otlin=2Ecom>:
>PHYs using the vsc8574_probe fail to be initialized and their
>config_init return -EIO leading to errors like:
>"could not attach PHY: -5"=2E
>
>This is because when the conversion of the MSCC PHY driver to use the
>shared PHY package helpers was done, the base address retrieval and the
>base PHY read and write helpers in the driver were modified=2E In
>particular, the base address retrieval logic was moved from the
>config_init to the probe=2E But the vsc8574_probe was forgotten=2E This
>patch fixes it=2E
>
>Fixes: deb04e9c0ff2 ("net: phy: mscc: use phy_package_shared")
>Signed-off-by: Antoine Tenart <antoine=2Etenart@bootlin=2Ecom>

Reviewed-by: Michael Walle <michael@walle=2Ecc>

thanks,=20
-michael

