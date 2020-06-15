Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2CD1F8E4F
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 08:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgFOGrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 02:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbgFOGrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 02:47:12 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A628206E2;
        Mon, 15 Jun 2020 06:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592203631;
        bh=7qmR8GAEeT/HyWInRqjOFODKX4hWvVvEZ3KnPLaLfu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwhLzj2CBnvjvXd8yOqK6WSXkAS6EnviVDgsd6EdB1A/ItFFoagyKNAIclg5W5k/D
         hE+yIm6T394yPh6WlWvd016bTy88UT2Zv5k1nME3SE3ahKCjZ8GlWQ5TrsMWL1jppF
         nUZiWUsa9meKsvB5lCeHkVh6uc9h5hLtenyb0jEY=
Received: from mchehab by mail.kernel.org with local (Exim 4.93)
        (envelope-from <mchehab@kernel.org>)
        id 1jkith-009nm4-E1; Mon, 15 Jun 2020 08:47:09 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 02/29] net: dev: add a missing kernel-doc annotation
Date:   Mon, 15 Jun 2020 08:46:41 +0200
Message-Id: <bd7a3ba69612d73bb91b3602f486084b1f518145.1592203542.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592203542.git.mchehab+huawei@kernel.org>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
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
index 6bc2388141f6..972ce594dd47 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7898,6 +7898,7 @@ EXPORT_SYMBOL(netdev_bonding_info_change);
 
 /**
  * netdev_get_xmit_slave - Get the xmit slave of master device
+ * @dev: device
  * @skb: The packet
  * @all_slaves: assume all the slaves are active
  *
-- 
2.26.2

