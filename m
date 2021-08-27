Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9173F986F
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbhH0L2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhH0L2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 07:28:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A631E60F44;
        Fri, 27 Aug 2021 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630063638;
        bh=VS9pNvPgZIeuIxoLgsr/G51Wht1Q+X2dTP9YC1fEMgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pP/BdrV+hjA51/sXrvI9hexBzNeRl4YCZtcSveQDmP/uG94s7+9ACw36gWKzasUSD
         0u0LiF0wuIknKyiDa4Ugt10e3dUIx/cOM5nd3UMrmCDem34FtdL/5vm8ho2OqieM3V
         qeghFzcekoUmtqY8E6ONxYyQO8lFJ4N8OweaakgYA/1hfKoHu0T4QdSlfl8v2FJe8c
         ZpYOYzYjbkYFpdCZnRlIIVvQo84pOGFmwMv3ohtNNgpIF6EUFtEMaE080XYNoQWe0k
         JFSk79RPcav7iyLVaH1I4J1Qo6N3vwNA1db+c4J7uadjC+1/Pi/QNmUg58mBGgFAMn
         7ZmN78mqFeMvw==
Date:   Fri, 27 Aug 2021 13:27:13 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: marvell: phy-mvebu-a3700-comphy: Remove
 unsupported modes
Message-ID: <20210827132713.61ef86f0@thinkpad>
In-Reply-To: <20210827092753.2359-3-pali@kernel.org>
References: <20210827092753.2359-1-pali@kernel.org>
        <20210827092753.2359-3-pali@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 11:27:53 +0200
Pali Roh=C3=A1r <pali@kernel.org> wrote:

> Armada 3700 does not support RXAUI, XFI and neither SFI. Remove unused
> macros for these unsupported modes.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> Fixes: 9695375a3f4a ("phy: add A3700 COMPHY support")

BTW I was thinking about merging some parts of these 2 drivers into
common code. Not entirely sure if I should follow, though.
