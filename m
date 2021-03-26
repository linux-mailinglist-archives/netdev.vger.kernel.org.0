Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC1F34B01D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhCZUXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhCZUW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 16:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 154FE61A28;
        Fri, 26 Mar 2021 20:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616790149;
        bh=5rbU0oSiI3DGCF4AZPTkQe3dq+R6HKdIjaMFOAkufWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTq/kNR1Vk2EwD771vQW9MIgfovVY7Xs15uEEzHvb8Z+TndcOw4RtoLWVxzD0q2eq
         ygqYsIGRHqL96zmSIR3+eABsK94/sAtinpkE5lp37VF1o/EAuOyHM3NsItnAtiNT5n
         tiZCpU/DIqS1/tNoM1OE9GPWl1ROhdeFu66JlNxVZWjM7COzOBrVzRglB+Z48B45af
         7Y55dSY+B+CSQt5s2djzZ+XTt1rv413N3q5fx6fJCji6Hq08HlbHXVhm1NI4BRRAkV
         RXGn1OU9GM23DBPg1pZCIC+sO6Zo6QNwk0d+wg+QskwLkB9KD3h0gAsFnN4qWxSn4i
         EqLRY8qea0IEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] ethtool: document the enum values not defines
Date:   Fri, 26 Mar 2021 13:22:23 -0700
Message-Id: <20210326202223.302085-4-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326202223.302085-1-kuba@kernel.org>
References: <20210326202223.302085-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kdoc does not have good support for documenting defines,
and we can't abuse the enum documentation because it
generates warnings.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9a47c3efd8ca..868b513d4f54 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1414,16 +1414,16 @@ struct ethtool_fecparam {
 
 /**
  * enum ethtool_fec_config_bits - flags definition of ethtool_fec_configuration
- * @ETHTOOL_FEC_NONE: FEC mode configuration is not supported. Should not
- *		      be used together with other bits. GET only.
- * @ETHTOOL_FEC_AUTO: Select default/best FEC mode automatically, usually based
- *		      link mode and SFP parameters read from module's EEPROM.
- *		      This bit does _not_ mean autonegotiation.
- * @ETHTOOL_FEC_OFF: No FEC Mode
- * @ETHTOOL_FEC_RS: Reed-Solomon FEC Mode
- * @ETHTOOL_FEC_BASER: Base-R/Reed-Solomon FEC Mode
- * @ETHTOOL_FEC_LLRS: Low Latency Reed Solomon FEC Mode (25G/50G Ethernet
- *		      Consortium)
+ * @ETHTOOL_FEC_NONE_BIT: FEC mode configuration is not supported. Should not
+ *			be used together with other bits. GET only.
+ * @ETHTOOL_FEC_AUTO_BIT: Select default/best FEC mode automatically, usually
+ *			based link mode and SFP parameters read from module's
+ *			EEPROM. This bit does _not_ mean autonegotiation.
+ * @ETHTOOL_FEC_OFF_BIT: No FEC Mode
+ * @ETHTOOL_FEC_RS_BIT: Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_BASER_BIT: Base-R/Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_LLRS_BIT: Low Latency Reed Solomon FEC Mode (25G/50G Ethernet
+ *			Consortium)
  */
 enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_NONE_BIT,
-- 
2.30.2

