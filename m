Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E820811FE89
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfLPGoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:13 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37355 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfLPGoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id c23so4038455plz.4
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GNOs1/KDJOd0yffVnfMRy0F3QXemxl25bzzNSyu2EEI=;
        b=QhayTDrPgAncjuVK/tBhsZT/pqBvW1mHh84IMQ3WpnzKXFExji92mz4y5i3lIku6UR
         ATQjRxYXOOCLiMhAOnrq6b/Jw0jiBIERw/H3DdUjZj5/ns0n9ISpNAn5Y6YMvb5P54Vo
         ZkNsTCUr3sTWnvSYBgr6736HQs0FDsZeLtAcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GNOs1/KDJOd0yffVnfMRy0F3QXemxl25bzzNSyu2EEI=;
        b=nDuFuGxtDA7wwimYIyFyLIMNKAM1+Hr2hYio+6qy9elK9flnQSm/9sk4Z8y/x1SnzP
         KBAsI+7cn657doVxqezzfpU9kMVMJaf8nPm3Sa7u7gRkyT6G02/lzaCQtVT0NgPNyNsY
         jNaooK1ct0d+nrTdsy0T5zHspI4+1e2Nt/amjqEhq82VP7Utwc9/0ikkiQ8czM0nutxt
         44BX57VowXMAOKGFn+zRAhP3lWHMY5KVgGz4bIRlkUf0NStKbzDcxhj1bIzd2FM5V0VW
         kX8siqerh4EGzW6Hg4ebdc/dePYm2YddWZI0ujeJS6RNF1+w6KNaU5if7PPeSbV83wbn
         S3WQ==
X-Gm-Message-State: APjAAAWsef6oDiPIboNFRXRK5W80Mg4h1oGERkGn3PxJWR+PNjARnD0n
        TwPssywDaX3jaSieFcKhigVTePhEGhc=
X-Google-Smtp-Source: APXvYqzhN9/F893oRTlmr1BmpzuNGYZFwm95Yr0zXWHCCeXDEaGR8v65UFqnr1JtVKwa1uKxwdNkBw==
X-Received: by 2002:a17:90a:36af:: with SMTP id t44mr15719651pjb.25.1576478651866;
        Sun, 15 Dec 2019 22:44:11 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:11 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 4/8] bridge: Fix src_vni argument in man page
Date:   Mon, 16 Dec 2019 15:43:40 +0900
Message-Id: <20191216064344.1470824-5-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"SRC VNI" is only one argument and should appear as such. Moreover, this
argument to the src_vni option is documented under three forms: "SRC_VNI",
"SRC VNI" and "VNI" in different places. Consistenly use the simplest form,
"VNI".

Fixes: c5b176e5ba1f ("bridge: fdb: add support for src_vni option")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 man/man8/bridge.8 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 10f6cf0e..1804f0b4 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -71,7 +71,7 @@ bridge \- show / manipulate bridge addresses and devices
 .B dst
 .IR IPADDR " ] [ "
 .B src_vni
-.IR SRC_VNI " ] ["
+.IR VNI " ] ["
 .B vni
 .IR VNI " ] ["
 .B port
@@ -498,7 +498,7 @@ the IP address of the destination
 VXLAN tunnel endpoint where the Ethernet MAC ADDRESS resides.
 
 .TP
-.BI src_vni " SRC VNI"
+.BI src_vni " VNI"
 the src VNI Network Identifier (or VXLAN Segment ID)
 this entry belongs to. Used only when the vxlan device is in
 external or collect metadata mode. If omitted the value specified at
-- 
2.24.0

