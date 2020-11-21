Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC69E2BBEC3
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 12:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgKULpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 06:45:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45858 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgKULpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 06:45:18 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605959117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2320IgWlYpfEIWjAe5nJQymTAKqBpdn4OBTAl0cAfEA=;
        b=ynCpt6iBQKZtaQOMwQQHf1921lmq65FmHqits66VtOmY9/1KW9U8d/hUCK1bNpCWolLNdo
        lSyR2ZJCD7czi4BBaBUpYjvvjoQPxVfNHD4XojTCKVzNZWynd0kUDrJZTNx2IoTWJCMrQK
        1j0PB63BYQZe8fZciqweQYAs8yBerDir2DWsgrRA7Vx571GePWwKKFoybbI38P+7Vz8KzP
        9YYpIx6AcX82Svou7Ygwnt7S9T+qDcRQnLg9TCLlYdJw8eGLYga5ZOiES8QNCHUMMzFlAa
        imR0LBd1iLqarvgDTFO65sVG3GMXe0k/5VudyNqdSWCh//U21KtJvUF8wE7uOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605959117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2320IgWlYpfEIWjAe5nJQymTAKqBpdn4OBTAl0cAfEA=;
        b=pAzShuxgFAFCbKxieZolDV12AC0NwBONxfULL5iRiLdT1UmCf/ugO2KaVRJsjFWh62Yab2
        BFSOOUcp5RRMhgBw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 0/2] net: dsa: hellcreek: Minor cleanups
Date:   Sat, 21 Nov 2020 12:44:53 +0100
Message-Id: <20201121114455.22422-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

fix two minor issues in the hellcreek driver.

Thanks,
Kurt

Kurt Kanzenbach (2):
  net: dsa: tag_hellcreek: Cleanup includes
  net: dsa: hellcreek: Don't print error message on defer

 drivers/net/dsa/hirschmann/hellcreek.c | 2 +-
 net/dsa/tag_hellcreek.c                | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.20.1

