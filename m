Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1642293086
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbgJSVcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:32:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:41570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgJSVcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:32:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2FF44AE07;
        Mon, 19 Oct 2020 21:32:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EAB8060563; Mon, 19 Oct 2020 23:32:49 +0200 (CEST)
Message-Id: <1e3546d7f774db109f77c465e3d1f838ab7d169d.1603142897.git.mkubecek@suse.cz>
In-Reply-To: <cover.1603142897.git.mkubecek@suse.cz>
References: <cover.1603142897.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 4/4] netlink: add message descriptions for pause stats
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 19 Oct 2020 23:32:49 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add message descriptions for pretty printing of new attributes used for pause
statistics.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/desc-ethtool.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index ee8fc4796987..96291b9bdd3b 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -180,12 +180,19 @@ static const struct pretty_nla_desc __coalesce_desc[] = {
 	NLATTR_DESC_U32(ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL),
 };
 
+static const struct pretty_nla_desc __pause_stats_desc[] = {
+	NLATTR_DESC_BINARY(ETHTOOL_A_PAUSE_STAT_PAD),
+	NLATTR_DESC_U64(ETHTOOL_A_PAUSE_STAT_TX_FRAMES),
+	NLATTR_DESC_U64(ETHTOOL_A_PAUSE_STAT_RX_FRAMES),
+};
+
 static const struct pretty_nla_desc __pause_desc[] = {
 	NLATTR_DESC_INVALID(ETHTOOL_A_PAUSE_UNSPEC),
 	NLATTR_DESC_NESTED(ETHTOOL_A_PAUSE_HEADER, header),
 	NLATTR_DESC_BOOL(ETHTOOL_A_PAUSE_AUTONEG),
 	NLATTR_DESC_BOOL(ETHTOOL_A_PAUSE_RX),
 	NLATTR_DESC_BOOL(ETHTOOL_A_PAUSE_TX),
+	NLATTR_DESC_NESTED(ETHTOOL_A_PAUSE_STATS, pause_stats),
 };
 
 static const struct pretty_nla_desc __eee_desc[] = {
-- 
2.28.0

