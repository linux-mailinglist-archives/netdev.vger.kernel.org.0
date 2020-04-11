Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3C91A58A0
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgDKXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbgDKXKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6718C20757;
        Sat, 11 Apr 2020 23:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646618;
        bh=MWpLAvZyJRrYn5ZnqL48jiIVByF7JkVVIj1AX7DmTvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdNgMsUr2pdU0pV6L713hwYbdZ3W2eBytYmhdO6s54P1FY9cZNDsWmAiKdhCchSlK
         FFE6bdR23QWx+mzUYYPS1F0bCH7cwVUXzckloIjxWrvgWhB4kHGqe9aYrRQ6sywe0p
         3mG58eKyVWFdCBi9kZH7nTjJfUEtYw8Yh5Zd+QJg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 028/108] net: rmnet: add missing module alias
Date:   Sat, 11 Apr 2020 19:08:23 -0400
Message-Id: <20200411230943.24951-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
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

