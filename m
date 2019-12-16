Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7982411FE88
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfLPGoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:11 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39721 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfLPGoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:11 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so3105067pga.6
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v+Ghy7hQa5OKBRuDo+cmfYhwEztPqpKLTm5YgMk1o7s=;
        b=EXPGkAved4xB99CF7ZvimTaSFGy6S74M8hhXaQZZwrc9t72U9dIrbSIIO3lKh0g2NS
         exTtTKEFC6WtqcElFgKrwqJqqOSYahpv7bZDgU5TaDdjRxNIkL/wlahNyMiLzIPhrsdv
         bHHiUxL8ByQU4VkeCCm3hV6Z38iDeROJRFrsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+Ghy7hQa5OKBRuDo+cmfYhwEztPqpKLTm5YgMk1o7s=;
        b=Sbj3QhWY9MqygD+kwe3CagN8gY1uMcB/NgGPB84qovs0aYzgnuwT7q5WhZ4W9+ch3x
         QFSV9ibzlJh+9Qu9lC+M9SfYa4H0eSoui8fnofUp/jSpcRaSDPaUD9ypQj/a+iM2KBnx
         1z0Obm55iSbWKgusO/teI8QdJ3FHxRcc8IAEdWPvheafC+OE4wW3kBSJVDX3JBveF80v
         hdjsQCommUlAR1Raj1gj9mGsrdSonzwFv3EjNyp9ZEnCIy6lSoJWQrG41jMlLuesPL9I
         fgqea9SUDPCvwp+FOTITi75rNE+l3zfnRtSjXVGSd0XcXxQEx+eq2KEXQxYYQcwwG7zg
         3aFg==
X-Gm-Message-State: APjAAAVLU6VGE3k2fuNnsSu34fyyl23P0JCiQnEWi4EN0DbLk8G0j49Z
        hV5blhcEqEp/fcpkXVbu4WD7ZKj7Yos=
X-Google-Smtp-Source: APXvYqy48UPQtDOLcMavLOetsLNwAFcqvZmk+Je5pkZkJmhqalQDkClBH+NNMgHHzw24vNx43CmQWA==
X-Received: by 2002:a63:2a06:: with SMTP id q6mr15684573pgq.92.1576478650034;
        Sun, 15 Dec 2019 22:44:10 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:09 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 3/8] bridge: Fix typo in error messages
Date:   Mon, 16 Dec 2019 15:43:39 +0900
Message-Id: <20191216064344.1470824-4-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 9eff0e5cc447 ("bridge: Add vlan configuration support")
Fixes: 7abf5de677e3 ("bridge: vlan: add support to display per-vlan statistics")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 6d33b0a9..6dc694b6 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -576,7 +576,7 @@ static int vlan_show(int argc, char **argv)
 					     (compress_vlans ?
 					      RTEXT_FILTER_BRVLAN_COMPRESSED :
 					      RTEXT_FILTER_BRVLAN)) < 0) {
-			perror("Cannont send dump request");
+			perror("Cannot send dump request");
 			exit(1);
 		}
 
@@ -601,7 +601,7 @@ static int vlan_show(int argc, char **argv)
 
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS);
 		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask) < 0) {
-			perror("Cannont send dump request");
+			perror("Cannot send dump request");
 			exit(1);
 		}
 
@@ -615,7 +615,7 @@ static int vlan_show(int argc, char **argv)
 
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS_SLAVE);
 		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask) < 0) {
-			perror("Cannont send slave dump request");
+			perror("Cannot send slave dump request");
 			exit(1);
 		}
 
-- 
2.24.0

