Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8A117EEF9
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 04:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCJDMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 23:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgCJDMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 23:12:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1592465A;
        Tue, 10 Mar 2020 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583809930;
        bh=HI1YO13ABHcaYYUg2TXAC0EMupelyV2oS/FjSavUlxA=;
        h=From:To:Cc:Subject:Date:From;
        b=ZPN2SGiEpl5gE22X07lSwRqwxhN0n5FOhsS1mcVyxZGVb4lhJ2XAhnKbvGkfYWOFV
         JmEvGfLuyMEf5E94FXJXDnqSEmX3KhZahtMIVKSLQvnpSx0zh9Eb98kbCAUQRsmSnt
         5cvnfJsADz32YJFtWMD092xcv3AYeK3yWrRnogpk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, leedom@chelsio.com, vishal@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: update cxgb4vf maintainer to Vishal
Date:   Mon,  9 Mar 2020 20:11:42 -0700
Message-Id: <20200310031142.1866719-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Casey Leedomn <leedom@chelsio.com> is bouncing,
Vishal indicated he's happy to take the role.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b1935c2ae118..6693ce1b9e21 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4571,7 +4571,7 @@ F:	drivers/infiniband/hw/cxgb4/
 F:	include/uapi/rdma/cxgb4-abi.h
 
 CXGB4VF ETHERNET DRIVER (CXGB4VF)
-M:	Casey Leedom <leedom@chelsio.com>
+M:	Vishal Kulkarni <vishal@gmail.com>
 L:	netdev@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
-- 
2.24.1

