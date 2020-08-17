Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E922B2468E0
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgHQO4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:56:07 -0400
Received: from mail.intenta.de ([178.249.25.132]:41296 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729154AbgHQOzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=IvoLRB1cL9VslVAHQ0cclitr5CrqX9r7frXG63FKJlI=;
        b=Wht+Dt0tUyl5KWuZxrWIHbUDrYqA0+VPsmsu06ZywH3IQR/B028LzZHhJoHtI8fKGCZjijpX/MBXzAOuN0A7+lJX4zQeJNeJpRKdFANjKzCf0ViScVbAER8eb5d8QenqL6S4MbBiEB2xB9z3uAw+VfUPgj2HJbeFES9lcqIZCVpgVy26gNj/YvoxmTDPiRWKm8E20m+YDkPx0OwSW11TkKaytjD8NzGhNtXsXDGvzF9yNWRuCRczzaY37fObeY10N+sEm0u3yFV2ysfj6EuseV0akZyk6NIrS2QjKx5KZnWaneGmsUTp6WzeaCE6a3cQ/5q2A7YRolEuo9mQ+E80pQ==;
Date:   Mon, 17 Aug 2020 16:55:20 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 0/6] net: dsa: microchip: delete dead code
Message-ID: <cover.1597675604.git.helmut.grohne@intenta.de>
References: <20200725174130.GL1472201@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200725174130.GL1472201@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn asked me to turn my dead code removal RFC patch into a real
one splitting it per member. This is what this v2 series does. Some
parts of the RFC patch are already applied via:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b20a6b29a811bee0e44b64958d415eb50436154c

All other structure members are read at least once.

Helmut

Helmut Grohne (6):
  net: dsa: microchip: delete unused member ksz_port.phy
  net: dsa: microchip: delete unused member ksz_port.sgmii
  net: dsa: microchip: delete unused member ksz_port.force
  net: dsa: microchip: delete unused member ksz_device.last_port
  net: dsa: microchip: delete unused member ksz_device.regs_size
  net: dsa: microchip: delete unused member ksz_device.overrides

 drivers/net/dsa/microchip/ksz8795.c    | 2 --
 drivers/net/dsa/microchip/ksz9477.c    | 8 --------
 drivers/net/dsa/microchip/ksz_common.h | 6 ------
 3 files changed, 16 deletions(-)

-- 
2.20.1

