Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6AA204A9D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgFWHJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731529AbgFWHJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:09:20 -0400
Received: from mail.kernel.org (unknown [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DA9F20772;
        Tue, 23 Jun 2020 07:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592896160;
        bh=AdrAwSAK0lsqTglvzyNK5zcGxe7pt9a3EYo6kOlR0Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvuoNRAhXE3PBzB4/MqvN6RVUw6YJyHrt9DIc1eqQWcD2x+pomzIh6HzAa+v3r5Ay
         A1nsqO2SzyZmmooOPjvGWHW93b9DOc6rEorHEQbTgLJX4k5CtpDdIcz6lFKR0Buaz1
         e7BaaRFvaRDpV1dnPsiteAq8nHqRrRjCaMU3agps=
Received: from mchehab by mail.kernel.org with local (Exim 4.93)
        (envelope-from <mchehab@kernel.org>)
        id 1jnd3R-003qim-0F; Tue, 23 Jun 2020 09:09:13 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 02/15] net: dev: add a missing kernel-doc annotation
Date:   Tue, 23 Jun 2020 09:08:58 +0200
Message-Id: <6e22325bb9bd4cc2249c3768b0e3ad75933445f8.1592895969.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592895969.git.mchehab+huawei@kernel.org>
References: <cover.1592895969.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev argument was not listed at kernel-doc markup:

	./net/core/dev.c:7878: warning: Function parameter or member 'dev' not described in 'netdev_get_xmit_slave'

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3a46b86cbd67..cc57347b11c5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7908,6 +7908,7 @@ EXPORT_SYMBOL(netdev_bonding_info_change);
 
 /**
  * netdev_get_xmit_slave - Get the xmit slave of master device
+ * @dev: device
  * @skb: The packet
  * @all_slaves: assume all the slaves are active
  *
-- 
2.26.2

