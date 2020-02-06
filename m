Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8112715477A
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBFPSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38044 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6ghnrczUbiTxVWJAgmJQ5rpf59adJVvftfVrvzy86wk=; b=frauZgFucusqMgiArZDApGhtfa
        iZUYDSrEwmCEWMYdy3zoKtJgn72t2H0/GPy0Dit8qSTkJYjLL9QqEm1G46Jzw8H70ahX6x+O+wyRw
        yGomEMR/XsqKbeN0ZAbaiUMFUF3RtJlIrxenwZyzXo+etyPNIOL5P7k0ehHDzgtiZu12Coc/eP1zp
        zhQ9IVg/Ecr7WneylKF4QmCo5bZHW2c5l6hrz/hYN2Hez36JxrzBJ7vxmXU+SAYOYdNAvGFuveO1Q
        iAMML9u0HbulAq4nydakboMkrxzG78vFYDeUv/B3GMP71QgdIc6IFSPZZTdfGciIcVF0YHnML5OHc
        UVHoaj5g==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jH-3n; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oWU-VE; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 26/28] docs: networking: convert generic_netlink.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:46 +0100
Message-Id: <9ced7880be7805770ae9a44693c5e0132372a0b2.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not much to be done here:
- add SPDX header;
- add a document title;
- add to networking/index.rst.


Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{generic_netlink.txt => generic_netlink.rst} | 6 ++++++
 Documentation/networking/index.rst                          | 1 +
 2 files changed, 7 insertions(+)
 rename Documentation/networking/{generic_netlink.txt => generic_netlink.rst} (64%)

diff --git a/Documentation/networking/generic_netlink.txt b/Documentation/networking/generic_netlink.rst
similarity index 64%
rename from Documentation/networking/generic_netlink.txt
rename to Documentation/networking/generic_netlink.rst
index 3e071115ca90..59e04ccf80c1 100644
--- a/Documentation/networking/generic_netlink.txt
+++ b/Documentation/networking/generic_netlink.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============
+Generic Netlink
+===============
+
 A wiki document on how to use Generic Netlink can be found here:
 
  * http://www.linuxfoundation.org/collaborate/workgroups/networking/generic_netlink_howto
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 1f47d74fd33e..bc2ee843df03 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -58,6 +58,7 @@ Contents:
    fore200e
    framerelay
    generic-hdlc
+   generic_netlink
 
 .. only::  subproject and html
 
-- 
2.24.1

