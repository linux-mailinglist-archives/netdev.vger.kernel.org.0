Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074262029E2
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 11:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgFUJ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 05:56:01 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:59153 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbgFUJ4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 05:56:00 -0400
Date:   Sun, 21 Jun 2020 09:55:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592733358; bh=4x5eYCNzPCn1hGiRUA0mGdrzZBJAKSMD6fuK9bbi8gs=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=SHcM/akZ6jU8Rc1wYNuBrFencBhtyVevqKROnLYW9gNudfjSmM99t2J+8dcP5c3/S
         38V+Whpxl+pHeNwhwo5hhvnHy24o2/a+2BIcl/racfWFjKgrtuKfAhCKwCDXVA4eOT
         g52PBCXWktyJawCTKLu9yao7G7Wo+ASzFPdkibsxd4RYsCgALD2Mgw5ZkyGXOjxqJX
         pa3DfU5wT0kAi6Qn5pWrrUOA06DY8DyI9JGD4p8K0AcJq4Z4DobZyzR1YjV/ede+hB
         AT5XtwPZZYWw9Mimf3gLP8/NsYo626Al49CrB7IPoH0xrVv27PTI62OHbQrAwJQIKM
         kxTezvumuiCEw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net 0/3] net: ethtool: netdev_features_strings[] cleanup
Message-ID: <HPTrw9hrtm3e5151oH8oQfbr0HWTlzQ1n68bZn1hfd6yag38Tem57b4eTH-bhlaJgBxyhZb9U-qFFOafJoQqxcY-VX5fh5ZktTrnWhYeNB0=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This little series adds the last forgotten feature string for
NETIF_F_GSO_TUNNEL_REMCSUM and attempts to prevent such losses
in future.

Patches 2-3 seem more like net-next candidates rather than net-fixes,
but for me it seems a bit more suitable to pull it during "quiet" RC
windows, so any new related code could start from this base.

I was thinking about some kind of static assertion to have an early
prevention mechanism for this, but the existing of 2 intended holes
(former NO_CSUM and UFO) makes this problematic, at least at first
sight.

v2:
 - fix the "Fixes:" tag in the first patch;
 - no functional changes.

Alexander Lobakin (3):
  net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
  net: ethtool: fix indentation of netdev_features_strings
  net: ethtool: sync netdev_features_strings order with enum
    netdev_features

 net/ethtool/common.c | 133 ++++++++++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 59 deletions(-)

--=20
2.27.0


