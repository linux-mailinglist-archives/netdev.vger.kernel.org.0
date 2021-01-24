Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3FB301B7E
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 12:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbhAXLrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:47:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbhAXLrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:47:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OBhfql025134;
        Sun, 24 Jan 2021 03:44:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ve3lx0NYRS8hskaMsrlh4Bg04eUBEDqkOqO5VY0l3QQ=;
 b=ELW3fhmIu5NtDMCAI9uO9D91YIlAGtse13/GRgAgVOYQtnDB4++YDw6tHWMKWsYYEpR/
 AaqVLNJuaLarIPvFvcgaZISpWzcw6RurE99Dsa6BtXyFI2gkuwjeC7tZlscoyJZz3qEL
 sR9NXMjyE1dN4KDp9iNsFoDrOgWybOjWM9Co5lI5WAhoPetab+P1PzfRLVjUolIuW1Ym
 XiqQKDQvwt1bufjXgCcUZQ/sgT622GDCxk9WX583DSjkW0bdnnmSeIQzIak8ZhbdhKDD
 7eI83Vv8+lkMuInyqninzw/U4g3Ce7ei846FjfjA2MH9XaZSPrW9I0gQRHveFtAZjAvq wQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9ssy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 03:44:49 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:44:48 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:44:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jan 2021 03:44:47 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 61A4F3F7040;
        Sun, 24 Jan 2021 03:44:44 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v2 RFC net-next 01/18] doc: marvell: add cm3-mem device tree bindings description
Date:   Sun, 24 Jan 2021 13:43:50 +0200
Message-ID: <1611488647-12478-2-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_04:2021-01-22,2021-01-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 Documentation/devicetree/bindings/net/marvell-pp2.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/marvell-pp2.txt b/Documentation/devicetree/bindings/net/marvell-pp2.txt
index b783976..f9f8cc6 100644
--- a/Documentation/devicetree/bindings/net/marvell-pp2.txt
+++ b/Documentation/devicetree/bindings/net/marvell-pp2.txt
@@ -37,6 +37,7 @@ Required properties (port):
   GOP (Group Of Ports) point of view. This ID is used to index the
   per-port registers in the second register area.
 - phy-mode: See ethernet.txt file in the same directory
+- cm3-mem: phandle to CM3 SRAM definitions
 
 Optional properties (port):
 
-- 
1.9.1

