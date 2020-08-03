Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2980423A3AD
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHCL5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:41796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbgHCL5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0E571AC5E
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:28 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B863160754; Mon,  3 Aug 2020 13:57:12 +0200 (CEST)
Message-Id: <a0b45029b9a6dfed847566f13adced7c3d0f576a.1596451857.git.mkubecek@suse.cz>
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 3/7] igc: mark unused callback parameter
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:12 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark info parameter of igc_dump_regs() as unused to get rid of gcc warning.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 igc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/igc.c b/igc.c
index 2c4abcef1e15..1550ac0c1c2b 100644
--- a/igc.c
+++ b/igc.c
@@ -94,7 +94,8 @@ static const char *bit_to_prio(u32 val)
 	return val ? "low" : "high";
 }
 
-int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int igc_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	u32 reg;
 	int offset, i;
-- 
2.28.0

