Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487A0204AB2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731821AbgFWHKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbgFWHJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:09:15 -0400
Received: from mail.kernel.org (unknown [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2520620772;
        Tue, 23 Jun 2020 07:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592896155;
        bh=Pgg7EmmtP5K/WKopCPIexNPopGp7jVe01m1h+U9P27k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmvvQS/3jU7HrLJSo8gV4zYVJbTVSclJSNrOhjlZfraFl86M3G5dpt3L1GIbiuPgF
         IoXbXHu8UdF2V/8jrFM+mG7eKNwSbVha1qxovImDb06UQBTlwSeE5iE7nc0I0Jkejh
         Z+VDayVa2f5NIzTGDfSOgoyke9FLq/XY03NC9QdU=
Received: from mchehab by mail.kernel.org with local (Exim 4.93)
        (envelope-from <mchehab@kernel.org>)
        id 1jnd3R-003qj0-3a; Tue, 23 Jun 2020 09:09:13 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH v2 05/15] net: pylink.h: add kernel-doc descriptions for new fields at phylink_config
Date:   Tue, 23 Jun 2020 09:09:01 +0200
Message-Id: <34970f447ff86415a6cef10a785fbef81c2819a7.1592895969.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592895969.git.mchehab+huawei@kernel.org>
References: <cover.1592895969.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some fields were moved from struct phylink into phylink_config.
Update the kernel-doc markups for the config struct accordingly

Fixes: 5c05c1dbb177 ("net: phylink, dsa: eliminate phylink_fixed_state_cb()")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/phylink.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cc5b452a184e..02ff1419d4be 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -62,6 +62,10 @@ enum phylink_op_type {
  * @dev: a pointer to a struct device associated with the MAC
  * @type: operation type of PHYLINK instance
  * @pcs_poll: MAC PCS cannot provide link change interrupt
+ * @poll_fixed_state: if true, starts link_poll,
+ *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @get_fixed_state: callback to execute to determine the fixed link state,
+ *		     if MAC link is at %MLO_AN_FIXED mode.
  */
 struct phylink_config {
 	struct device *dev;
-- 
2.26.2

