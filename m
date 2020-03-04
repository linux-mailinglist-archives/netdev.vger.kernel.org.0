Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD72C1797B0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgCDSR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:17:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729675AbgCDSR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:17:59 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 343522467E;
        Wed,  4 Mar 2020 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583345878;
        bh=Q68bG4j+XCVSvOsQe91knWwYkHnGqVeK49YeFokifMg=;
        h=From:To:Cc:Subject:Date:From;
        b=SQlE75I6cp2rILD/rgWp84uB6QwOjyQKk0p5JBxXku6D8bEQ+C1WBD6AN2d9xyXnt
         lFPd8IGonVG1jDsUintIKiZ6fhLBfkLMJjNEebKMec2F6jZeRT822jT6L5OH3MBeX4
         d87Juktz5PgcRgk3gaq+aLy+stiNHSimXhtloxT8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, benve@cisco.com, _govind@gmx.com,
        pkaustub@cisco.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: remove bouncing pkaustub@cisco.com from enic
Date:   Wed,  4 Mar 2020 10:17:53 -0800
Message-Id: <20200304181753.723315-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pkaustub@cisco.com is bouncing, remove it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Parvi, Christian, Govindarajulu - please speak up if
a different address can be used instead of removing!
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f27f40d22bb..b1935c2ae118 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4073,7 +4073,6 @@ F:	drivers/scsi/snic/
 CISCO VIC ETHERNET NIC DRIVER
 M:	Christian Benvenuti <benve@cisco.com>
 M:	Govindarajulu Varadarajan <_govind@gmx.com>
-M:	Parvi Kaustubhi <pkaustub@cisco.com>
 S:	Supported
 F:	drivers/net/ethernet/cisco/enic/
 
-- 
2.24.1

