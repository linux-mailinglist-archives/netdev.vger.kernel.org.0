Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A1218CFF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbgGHQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbgGHQcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 12:32:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1726206DF;
        Wed,  8 Jul 2020 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594225925;
        bh=H0Wu/BAz8vnX6yWwkCd9GCUvAWjGhNdK2uh35x2F+gY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vt/puv9WSgcAFnQCevVazOFMWEdNIStzG0eLIdImPSn2pTYfN9LfWO4TavwlYO8+5
         PcL9lHHK02+gd38OxHtt47Zqt4w45KXH4mk/pigiMmtBe44UDTiN4EbGNZZiUFwZOV
         tH7un04276lBm9oRAe3U6rcafKhgOCGHkKSIlyfo=
Date:   Wed, 8 Jul 2020 09:32:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     linux-mediatek@lists.infradead.org,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix mtu warning
Message-ID: <20200708093203.347bad78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200708154634.9565-1-frank-w@public-files.de>
References: <20200708154634.9565-1-frank-w@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jul 2020 17:46:34 +0200 Frank Wunderlich wrote:
> From: Ren=C3=A9 van Dorst <opensource@vdorst.com>
>=20
> in recent Kernel-Versions there are warnings about incorrect MTU-Size
> like these:
>=20
> mt7530 mdio-bus:00: nonfatal error -95 setting MTU on port x
> eth0: mtu greater than device maximum
> mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA =
overhead
>=20
> Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
>=20
> Fixes: bfcb813203 ("net: dsa: configure the MTU for switch ports")
> Fixes: 72579e14a1 ("net: dsa: don't fail to probe if we couldn't set the =
MTU")
> Fixes: 7a4c53bee3 ("net: report invalid mtu value via netlink extack")

Fixes tag: Fixes: bfcb813203 ("net: dsa: configure the MTU for switch ports=
")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
Fixes tag: Fixes: 72579e14a1 ("net: dsa: don't fail to probe if we couldn't=
 set the MTU")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
Fixes tag: Fixes: 7a4c53bee3 ("net: report invalid mtu value via netlink ex=
tack")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
