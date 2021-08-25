Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC8F3F76AC
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 15:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbhHYN7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 09:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhHYN73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 09:59:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA761C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 06:58:43 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629899921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f6qp5ppAOy8fTswg3+6+xDo2xQOAHGHPsq6rNrT6Sf4=;
        b=BCgnMJzuoNYNGP5n1F0o5N6LBw/D8DiSbuxYo2tuYC4uZEy/MRLRRpxFkFx3duRsuGzxXR
        LxF5SKTPWzQU7CrRsq1MJXKJGspBAi1ilGbathMOy4azLK9kFmMl8G6HSuG7hFWXgZd6rp
        QrKJj5V0BsNDyCKX2sga6dUz07MY2vHnHTpulFrhKqO+WUBmITZ8RUPL6oHHJM/qFyW1HG
        xzGdq+0t4XbUXkAeCmXNcMKMZf49Li9sY2nQeRNEeRhn0P9ElMz8rOsykxPB06P6i4Stcl
        WXUF9O7TeWC9X2tUv0KlWGqLbP59YXIR242Frn7nkB4duTzsP8OHJ8DFbphwSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629899921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f6qp5ppAOy8fTswg3+6+xDo2xQOAHGHPsq6rNrT6Sf4=;
        b=SOI+rcR4PS/CggB+X4EoIsCmVimT/FFeWnxuLqJBLkTMPTqZHQPwKjqE0znah9WCfl+Ye3
        eNiQNouXMnYRaxCA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net 0/2] net: dsa: hellcreek: 802.1Qbv Fixes
Date:   Wed, 25 Aug 2021 15:58:11 +0200
Message-Id: <20210825135813.73436-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while using TAPRIO offloading on the Hirschmann hellcreek switch, I've noticed
two issues in the current implementation:

1. The gate control list is incorrectly programmed
2. The admin base time is not set properly

Fix it.

Thanks,
Kurt

Kurt Kanzenbach (2):
  net: dsa: hellcreek: Fix incorrect setting of GCL
  net: dsa: hellcreek: Adjust schedule look ahead window

 drivers/net/dsa/hirschmann/hellcreek.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.30.2

