Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB9BE970
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 02:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388009AbfIZAUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 20:20:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52958 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfIZAUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 20:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mFkYL5V6GZ/pl5HSMZ3/1j4FQUKy0ZulXrEekG6HjRQ=; b=GAptIadRXzosNQyodOFsDv2vg
        164jptyICyO9DrFMIuXX3q6eVHkY2u5gdkv3otd1LHR/ZvHPxAT5DFkLZNFf5+ffcs41i15u6SOg/
        6l03Njw1lsdXoamSRehXtia5OtFEcSEGruiw6VthnfjZHFyC7jszmWUAGPnOIs7QNHNUCL2ALKxCD
        xt+eaHkrgmTBtmv16eioqhoCW0nor1qahNJtUvhBGTgdYkpm66s0jwy0mW2tPlPupdzJ8nGDRDijP
        /oOnhO7u0FiTPecURwU6EzmPBUxkj4Dve4JiNkcnBmTJ3f06tMEP1HDs/HYGMv1O0Nw+EmabItusJ
        xloKeTOcg==;
Received: from [2601:1c0:6280:3f0::9a1f]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDHWV-0005GK-DV; Thu, 26 Sep 2019 00:20:43 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] lib: dimlib: fix help text typos
Message-ID: <445cadc0-8b22-957f-47f6-2e6250124ae3@infradead.org>
Date:   Wed, 25 Sep 2019 17:20:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix help text typos for DIMLIB.

Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Uwe Kleine-König <uwe@kleine-koenig.org>
Cc: Tal Gilboa <talgi@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
---
Applies after Uwe's patch v2: dimlib: make DIMLIB a hidden symbol

 lib/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-53.orig/lib/Kconfig
+++ lnx-53/lib/Kconfig
@@ -558,7 +558,7 @@ config DIMLIB
 	bool
 	help
 	  Dynamic Interrupt Moderation library.
-	  Implements an algorithm for dynamically change CQ modertion values
+	  Implements an algorithm for dynamically changing CQ moderation values
 	  according to run time performance.
 
 #

