Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60485CFDB7
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfJHPfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:35:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56212 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfJHPfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Wsq40FnxdCINz5OBcdN9mKp/qTsJ6wah9UUjtIMh6QQ=; b=kXN8Yuo6PkuWXFOItscYd6orH
        oAs4gEX+QASk980sxyyMvi2bDWKT1QurPPYzv8hHuGoKP0huBmeKLLn0THkfjaPqJaQ/lbBcaWyJq
        izxKQ+y7vFJda7W1cKvMf0tVmB4F97kGA7gxYPw7LdQTTzi6MKnGQi9LTT4xtAerrfVUiGlOQUuaQ
        l7c5q324V6tcWm1LeIbxEUN4KM63Iq10Wh8lf+SeAC20VoPpmqfKpXtwHQJ3vvYtjihFwzXmep9ET
        Xy8WgqL5XzGzPp6Qs3PrwlaYpC2lilG5OkgCNPW3NTht0CxvgDtkVM/ET5BssR+D6NXA1cmHUCNc0
        vkthnT12g==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHrWh-0005EG-Ma; Tue, 08 Oct 2019 15:35:51 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Shannon Nelson <snelson@pensando.io>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -net] Doc: networking/device_drivers/pensando: fix ionic.rst
 warnings
Message-ID: <b93b6492-0ab8-46a6-1e1d-56f9cb627b0f@infradead.org>
Date:   Tue, 8 Oct 2019 08:35:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix documentation build warnings for Pensando ionic:

Documentation/networking/device_drivers/pensando/ionic.rst:39: WARNING: Unexpected indentation.
Documentation/networking/device_drivers/pensando/ionic.rst:43: WARNING: Unexpected indentation.

Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Shannon Nelson <snelson@pensando.io>
---
 Documentation/networking/device_drivers/pensando/ionic.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20191008.orig/Documentation/networking/device_drivers/pensando/ionic.rst
+++ linux-next-20191008/Documentation/networking/device_drivers/pensando/ionic.rst
@@ -36,8 +36,10 @@ Support
 =======
 For general Linux networking support, please use the netdev mailing
 list, which is monitored by Pensando personnel::
+
   netdev@vger.kernel.org
 
 For more specific support needs, please use the Pensando driver support
 email::
-	drivers@pensando.io
+
+  drivers@pensando.io

