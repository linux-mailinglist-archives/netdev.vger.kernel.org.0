Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB414E9DD
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 10:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgAaJAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 04:00:04 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:52532 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgAaJAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 04:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1580461202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=15/OI/xJJYxtK7XOfs9IFESyt4OHQIbNCxIjdFy0prI=;
        b=rbveVXt7C49gWZDLjvt01gct5Pj2y2uyalqgiCa1xFfVbccW1ebMy/OztQLArr19x2bAVg
        0k6nrPu4xPKD9bHoDLyy0GhdNSn+FdJRHgfdLMfeAcYME7VzNF18uw4wFDVF+BfH2N3uLS
        OtbNlaEEBqaB7ge2ZMAXCQMaLBM8Yh0=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, info@alten.se,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH] MAINTAINERS: Orphan HSR network protocol
Date:   Fri, 31 Jan 2020 09:59:19 +0100
Message-Id: <20200131085919.18023-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current maintainer Arvid Brodin <arvid.brodin@alten.se> hasn't
contributed to the kernel since 2015-02-27. His company mail address is
also bouncing and the company confirmed (2020-01-31) that no Arvid Brodin
is working for them:

> Vi har dessvärre ingen  Arvid Brodin som arbetar på ALTEN.

A MIA person cannot be the maintainer. It is better to mark is as orphaned
until some other person can jump in and take over the responsibility for
HSR.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b32153bed5a..79ddd9d8592f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7666,9 +7666,8 @@ S:	Orphan
 F:	drivers/net/usb/hso.c
 
 HSR NETWORK PROTOCOL
-M:	Arvid Brodin <arvid.brodin@alten.se>
 L:	netdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	net/hsr/
 
 HT16K33 LED CONTROLLER DRIVER
-- 
2.20.1

