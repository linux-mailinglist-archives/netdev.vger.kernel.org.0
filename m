Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615E92459DF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgHPWZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgHPWZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:25:57 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566FEC061786;
        Sun, 16 Aug 2020 15:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=OSxe+pZvmEww30D4JRIZnsmQ22mNO++VFvLLKUgIkxc=; b=k+BkthooarZnaRtAqSB8WbCBH0
        vcVQoZWkaEAkwwOdk8ufZi8HGkhZ9k/SImNOkRBiPa+DSorowM2E1biinymJy1h02XNfOcjdKzqYd
        pLpJ9ad69s22I5BPCNI5UayS2LK0zEd6D/ca2vhCYsrHn/UxZ/9Krp1T/ugKFkZ4soH1NFRDjVvhs
        IiJtPXSTzf8Lty8S8GZw452YhbHVGfzQO1MCIWLMz2v0GGqq96H8sRbjKfnA8vHSbydCxZtflBhNR
        cHImWfuUwnrTyZshJdS34s489oBdHnZslyLNaqL6Uk1427XMj79XB28Z0Q1V/RUZybMTvcGYu54ZI
        O+3uWkzg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7R69-0002PA-MQ; Sun, 16 Aug 2020 22:25:54 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] phylink: <linux/phylink.h>: fix function prototype kernel-doc warning
Date:   Sun, 16 Aug 2020 15:25:49 -0700
Message-Id: <20200816222549.379-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a kernel-doc warning for the pcs_config() function prototype:

../include/linux/phylink.h:406: warning: Excess function parameter 'permit_pause_to_mac' description in 'pcs_config'

Fixes: 7137e18f6f88 ("net: phylink: add struct phylink_pcs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 include/linux/phylink.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lnx-59-rc1.orig/include/linux/phylink.h
+++ lnx-59-rc1/include/linux/phylink.h
@@ -402,7 +402,8 @@ void pcs_get_state(struct phylink_pcs *p
  * For most 10GBASE-R, there is no advertisement.
  */
 int pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-	       phy_interface_t interface, const unsigned long *advertising);
+	       phy_interface_t interface, const unsigned long *advertising,
+	       bool permit_pause_to_mac);
 
 /**
  * pcs_an_restart() - restart 802.3z BaseX autonegotiation
