Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB7E1F2F54
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgFIAtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:49:35 -0400
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:63515 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgFIAtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 20:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=715; q=dns/txt; s=iport;
  t=1591663770; x=1592873370;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rJkYfRfAyvOonSiExGaIKerNlhNWhgco50MgMia7avw=;
  b=P7EyFLKIh5OFzVYj/5w48Ulop2i36ijN1HMxIxOPKm4yMvskyD5tEMnK
   oAqZmwCDxd7/3In3MHEee/MiIFee1aMlEhXmRSsJms368++kMBTIv0rLb
   B49UnlbVw5nSWeIn94dbEg432g2afJBZWuZcBNEYlPE5Pkf0hFF6Iy16N
   8=;
X-IronPort-AV: E=Sophos;i="5.73,490,1583193600"; 
   d="scan'208";a="769577426"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 09 Jun 2020 00:42:19 +0000
Received: from 240m5avmarch.cisco.com (240m5avmarch.cisco.com [10.193.164.12])
        (authenticated bits=0)
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPSA id 0590g7nJ009323
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 9 Jun 2020 00:42:19 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     netdev@vger.kernel.org, edumazet@google.com, linville@tuxdriver.com
Cc:     govind.varadar@gmail.com,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: [PATCH ethtool 2/2] man: add man page for ETHTOOL_GTUNABLE and ETHTOOL_STUNABLE
Date:   Mon,  8 Jun 2020 10:52:55 -0700
Message-Id: <20200608175255.3353-2-gvaradar@cisco.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200608175255.3353-1-gvaradar@cisco.com>
References: <20200608175255.3353-1-gvaradar@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.193.164.12, 240m5avmarch.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
---
 ethtool.8.in | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 4c5b6c5..da0564e 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -390,6 +390,18 @@ ethtool \- query or control network driver and hardware settings
 .RB [ fast-link-down ]
 .RB [ energy-detect-power-down ]
 .HP
+.B ethtool \-b|\-\-get\-tunable
+.I devname
+.RB [ rx-copybreak ]
+.RB [ tx-copybreak ]
+.RB [ pfc-prevention-tout ]
+.HP
+.B ethtool \-B|\-\-set\-tunable
+.I devname
+.BN rx\-copybreak
+.BN tx\-copybreak
+.BN pfc\-prevention\-tout
+.HP
 .B ethtool \-\-reset
 .I devname
 .BN flags
-- 
2.27.0

