Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8902F4BD9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbhAMM4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:56:31 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:39232 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbhAMM4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:56:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EFEC99C0DC3;
        Wed, 13 Jan 2021 07:45:33 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id hVglsFfAEgpd; Wed, 13 Jan 2021 07:45:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 901A29C0DC9;
        Wed, 13 Jan 2021 07:45:33 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3H0fa3fAiHpI; Wed, 13 Jan 2021 07:45:33 -0500 (EST)
Received: from gdo-desktop.home (pop.92-184-98-96.mobile.abo.orange.fr [92.184.98.96])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 7EAE79C0DA5;
        Wed, 13 Jan 2021 07:45:31 -0500 (EST)
From:   Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/6] Fixes on Microchip KSZ8795 DSA switch driver
Date:   Wed, 13 Jan 2021 13:45:16 +0100
Message-Id: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patchset fixes various issues.
It mainly concerns VLANs support by fixing FID table management to
allow adding more than one VLAN.
It also fixes tag/untag behavior on ingress/egress packets.

Gilles DOFFE (6):
  net: dsa: ksz: fix FID management
  net: dsa: ksz: move tag/untag action
  net: dsa: ksz: insert tag on ks8795 ingress packets
  net: dsa: ksz: do not change tagging on del
  net: dsa: ksz: fix wrong pvid
  net: dsa: ksz: fix wrong read cast to u64

 drivers/net/dsa/microchip/ksz8795.c     | 71 +++++++++++++++++++++----
 drivers/net/dsa/microchip/ksz8795_reg.h |  1 +
 drivers/net/dsa/microchip/ksz_common.h  |  3 +-
 3 files changed, 63 insertions(+), 12 deletions(-)

--=20
2.25.1

