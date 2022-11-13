Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD186271DA
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbiKMS7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiKMS7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:59:16 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745C663F3;
        Sun, 13 Nov 2022 10:59:00 -0800 (PST)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id CC0DC84F4D;
        Sun, 13 Nov 2022 19:58:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668365938;
        bh=K02xgPMPp0tELhn4S/cdkxAEO+g1DFFRdpK8FZ087aM=;
        h=From:To:Cc:Subject:Date:From;
        b=oQ4dasOfARHuDlUnPjTVKqjSbKeNnVZb/DbuV9AmI31FCaWcwAeYcYw9dqihmgoiH
         rh2UJkJQ9QzKrdP9nw5Hqih1o+ZMXykv1U8Pj7F0ToxNmKFG9X6Hzvcj0TENwDNtGJ
         QxkwyrCTNLo55gqf0ckuq9+mD6If+i/Jcfdx18aH0OzBNBqoArWL6xpTZKcYwggNgR
         23PEPkX4zkv2W1hkS7tQeEkQ0XoTZLEnAmQ6jcGQpC6iFLtoMewYsul70C7hg7STC0
         tYT4Y6QaztnRZ9yWsLzOVlhMrWAnpz6OmtUjmvzAAu0eVj2D2goeB8XmJmiKg9dKTU
         vy6Mc48pzoD+Q==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] wifi: rsi: Mark driver as orphan
Date:   Sun, 13 Nov 2022 19:58:38 +0100
Message-Id: <20221113185838.11643-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither Redpine Signals nor Silicon Labs seem to care about proper
maintenance of this driver, nor is there any help, documentation or
feedback on patches. The driver suffers from various problems and
subtle bugs. Mark it as orphaned.

Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 MAINTAINERS | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b23dfb9b9cfe3..722820b581a94 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17584,10 +17584,8 @@ S:	Maintained
 F:	drivers/net/wireless/realtek/rtw89/
 
 REDPINE WIRELESS DRIVER
-M:	Amitkumar Karwar <amitkarwar@gmail.com>
-M:	Siva Rebbagondla <siva8118@gmail.com>
 L:	linux-wireless@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/rsi/
 
 REGISTER MAP ABSTRACTION
-- 
2.35.1

