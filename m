Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61271502F07
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348750AbiDOTLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348551AbiDOTLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DB7DBD1D;
        Fri, 15 Apr 2022 12:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70AC9B82EF1;
        Fri, 15 Apr 2022 19:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DE7C385A5;
        Fri, 15 Apr 2022 19:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650049724;
        bh=dvZpqVTi0jdBV+n0QdZhgd89O8shNTR194n0OIslFEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo9SN5UB5HN+TQ8PDoWan0KcngRkeZPACjXnATfZw2QPo8YV8IFEsKTgTqaUHb4Wq
         buYSTHLuV8dWUQ+yssZu4Cu0uOcBv0mjwVsDVHIh1maofvqLvYAAAy1RVEFK9yCXo+
         dPGdBtMn+DALp8LeFcJxFbSsAfDVa+Yze68PW2g0l28eXMzTI2kK5VoUBifIrHOtwZ
         1WOf86Z5OYIWDhVv4bhoKtsirQ9OaUxjNMN4e/90dC6L7vUMwinM6ndR4799Tqlo2s
         Geiv9PhbOsZgFOoijb1U7+dWqsYEaovac2mSFv5v7ZmqCiWLmIaVi+7wvIiA7CI4f6
         lLjJ23uF8IhFQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Chas Williams <3chas3@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7/7] alpha: remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions
Date:   Fri, 15 Apr 2022 14:08:17 -0500
Message-Id: <20220415190817.842864-8-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415190817.842864-1-helgaas@kernel.org>
References: <20220415190817.842864-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/alpha/include/asm/io.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index c9cb554fbe54..338dd24400bd 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -14,10 +14,6 @@
    the implementation we have here matches that interface.  */
 #include <asm-generic/iomap.h>
 
-/* We don't use IO slowdowns on the Alpha, but.. */
-#define __SLOW_DOWN_IO	do { } while (0)
-#define SLOW_DOWN_IO	do { } while (0)
-
 /*
  * Virtual -> physical identity mapping starts at this offset
  */
-- 
2.25.1

