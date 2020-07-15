Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE52212B8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgGOQnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgGOQm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:42:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC48C08C5DD;
        Wed, 15 Jul 2020 09:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=/ouoRB7+nsyijg9BkaJBjydWt6dQzafFxJ2kXGh69KY=; b=CFNhVPJi1jHu4OVYfeEKjr24lP
        72L3RqZbhBzLVp9SeHAdUXv1xjBxkw/Yw+X1GCWK2QD+FPKJwHrGPpsOkmE0qrwe4JaN0HHIQhW9K
        aKKfjI9ZuIUq9wPFwAShsYyb8zYf9LUT++NcYAMAdv7gmkJQ1fuTjb3KaO5LdPyn1WCG6Na0FEcbO
        FVqK9vW/trEQR05KcyvX4wBYT8zfI8zLPCd8dtq/WrJWO//umwPrUHw+rDasXiCYcLXnQJ59ev2mu
        L/tdhD7iJgCVQf4XwFs/BXdAaz3inX/LZiMya7M9C1TEu05uOfZNaaIhsvNaSoUlQ/KX4JsG6EHzn
        XxyxyU1A==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUg-0000Bh-KQ; Wed, 15 Jul 2020 16:42:55 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 3/9 v2 net-next] net: wimax: fix duplicate words in comments
Date:   Wed, 15 Jul 2020 09:42:40 -0700
Message-Id: <20200715164246.9054-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164246.9054-1-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled words in two comments.
Fix a spello/typo.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
v2: move wireless patches to a separate patch series.

 include/linux/wimax/debug.h |    4 ++--
 include/net/wimax.h         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200714.orig/include/linux/wimax/debug.h
+++ linux-next-20200714/include/linux/wimax/debug.h
@@ -184,8 +184,8 @@ do {									\
 
 
 /*
- * CPP sintatic sugar to generate A_B like symbol names when one of
- * the arguments is a a preprocessor #define.
+ * CPP syntatic sugar to generate A_B like symbol names when one of
+ * the arguments is a preprocessor #define.
  */
 #define __D_PASTE__(varname, modulename) varname##_##modulename
 #define __D_PASTE(varname, modulename) (__D_PASTE__(varname, modulename))
--- linux-next-20200714.orig/include/net/wimax.h
+++ linux-next-20200714/include/net/wimax.h
@@ -28,7 +28,7 @@
  *
  * USAGE
  *
- * Embed a `struct wimax_dev` at the beginning of the the device's
+ * Embed a `struct wimax_dev` at the beginning of the device's
  * private structure, initialize and register it. For details, see
  * `struct wimax_dev`s documentation.
  *
