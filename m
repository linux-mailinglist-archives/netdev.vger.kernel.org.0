Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B8E177461
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgCCKgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:36:36 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:38407 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgCCKgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:36:35 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 660E3FF80F;
        Tue,  3 Mar 2020 10:36:33 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     dsahern@gmail.com, sd@queasysnail.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next v2 3/4] man: document the ip macsec offload command
Date:   Tue,  3 Mar 2020 11:36:18 +0100
Message-Id: <20200303103619.818985-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303103619.818985-1-antoine.tenart@bootlin.com>
References: <20200303103619.818985-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description of the `ip macsec offload` command used to select the
offloading mode on a macsec interface when the underlying device
supports it.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 man/man8/ip-macsec.8 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index 2179b33683d5..d5f9d240bf12 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -53,6 +53,9 @@ ip-macsec \- MACsec device configuration
 .BI "ip macsec del " DEV " rx " SCI " sa"
 .RI "{ " 0..3 " }"
 
+.BI "ip macsec offload " DEV
+.RB "{ " off " | " phy " }"
+
 .B ip macsec show
 .RI [ " DEV " ]
 
@@ -102,6 +105,10 @@ type.
 .SS Display MACsec configuration
 .nf
 # ip macsec show
+.PP
+.SS Configure offloading on an interface
+.nf
+# ip macsec offload macsec0 phy
 
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
-- 
2.24.1

