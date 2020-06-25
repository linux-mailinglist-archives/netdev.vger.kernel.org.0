Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A26E20A5B8
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405815AbgFYTZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:25:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60878 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403792AbgFYTZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:25:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joXUX-002FOD-9a; Thu, 25 Jun 2020 21:24:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v3 6/6] ethtool.8.in: Add --json option
Date:   Thu, 25 Jun 2020 21:24:46 +0200
Message-Id: <20200625192446.535754-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625192446.535754-1-andrew@lunn.ch>
References: <20200625192446.535754-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the --json option, which the --cable-test and
--cable-test-tdr options support.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool.8.in | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 60ca37c..689822e 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -137,6 +137,9 @@ ethtool \- query or control network driver and hardware settings
 .BN --debug
 .I args
 .HP
+.B ethtool [--json]
+.I args
+.HP
 .B ethtool \-\-monitor
 [
 .I command
@@ -476,6 +479,11 @@ lB	l.
 0x01  Parser information
 .TE
 .TP
+.BI \-\-json
+Output results in JavaScript Object Notation (JSON). Only a subset of
+options support this. Those which do not will continue to output
+plain text in the presence of this option.
+.TP
 .B \-a \-\-show\-pause
 Queries the specified Ethernet device for pause parameter information.
 .TP
-- 
2.27.0

