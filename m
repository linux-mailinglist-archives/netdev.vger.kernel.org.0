Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91621A5B3A
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgDKXEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbgDKXEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C880021744;
        Sat, 11 Apr 2020 23:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646274;
        bh=MWpLAvZyJRrYn5ZnqL48jiIVByF7JkVVIj1AX7DmTvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xeMNSHCxFIqRa0ae/ITb1b/QlDuBCaIQ2hxBlPgBm64PNgf6OGPRxtRqG+bfmZP74
         hOn4rIiQWEzdI6fMUsu6w7UqjNqDl18/HA+6WfXjW90mmBeN00OzvIdddPx7mNSNcG
         lgCOLjoSnxjK1ooTrBZYtX/F7d2L9LabWA0edaZQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 038/149] net: rmnet: add missing module alias
Date:   Sat, 11 Apr 2020 19:01:55 -0400
Message-Id: <20200411230347.22371-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit eed22a0685d651fc531bc63f215bb2a71d4b98e5 ]

In the current rmnet code, there is no module alias.
So, RTNL couldn't load rmnet module automatically.

Test commands:
    ip link add dummy0 type dummy
    modprobe -rv rmnet
    ip link add rmnet0 link dummy0 type rmnet  mux_id 1

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fbf4cbcf1a654..d846a0ccea8f0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -475,4 +475,5 @@ static void __exit rmnet_exit(void)
 
 module_init(rmnet_init)
 module_exit(rmnet_exit)
+MODULE_ALIAS_RTNL_LINK("rmnet");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1

