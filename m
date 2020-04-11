Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDCB1A4E8D
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 09:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgDKHaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 03:30:09 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:23173 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgDKHaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 03:30:09 -0400
Received: from localhost.localdomain ([93.22.135.18])
        by mwinf5d37 with ME
        id RKW6220070Pz5GD03KW6Eh; Sat, 11 Apr 2020 09:30:08 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 11 Apr 2020 09:30:08 +0200
X-ME-IP: 93.22.135.18
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     elder@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] soc: qcom: ipa: Add a missing '\n' in a log message
Date:   Sat, 11 Apr 2020 09:30:04 +0200
Message-Id: <20200411073004.8404-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Message logged by 'dev_xxx()' or 'pr_xxx()' should end with a '\n'.

Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ipa/ipa_modem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 55c9329a4b1d..ed10818dd99f 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -297,14 +297,13 @@ static void ipa_modem_crashed(struct ipa *ipa)
 
 	ret = ipa_endpoint_modem_exception_reset_all(ipa);
 	if (ret)
-		dev_err(dev, "error %d resetting exception endpoint",
-			ret);
+		dev_err(dev, "error %d resetting exception endpoint\n", ret);
 
 	ipa_endpoint_modem_pause_all(ipa, false);
 
 	ret = ipa_modem_stop(ipa);
 	if (ret)
-		dev_err(dev, "error %d stopping modem", ret);
+		dev_err(dev, "error %d stopping modem\n", ret);
 
 	/* Now prepare for the next modem boot */
 	ret = ipa_mem_zero_modem(ipa);
-- 
2.20.1

