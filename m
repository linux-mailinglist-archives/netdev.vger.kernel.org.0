Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D6422925C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgGVHke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 03:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGVHkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 03:40:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A92C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 00:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IZQjCJEe8/CqFbvx3hCLFoPsZbhwsMGkb4YageFLDTY=; b=KL1g0j2M/cbjTbeqyZR3swwi89
        XjpB3gcVA1i07SvuIO6Qnp/B97XPexffOKK/cR7JRAWA1rLIZcLGw045JWFgbbMqkUEcTVy7NSj1L
        2YghdDvIU7gx8hgUvl7IYFXhjzDaVzeoiM9sAXWLsEjXBvzmzj6GsOIq20SBQLJXVAHEOL6zR6Oje
        VNZoS7CNZcztsptTY/f7ZRDeb3mh1vNTxb711Kx41PTtXC3PrPw72KnfIDEVdcTXSTBd7771aXe2G
        9LTJrG8iCr9S7z6CSRJstWCaVSveMVcKI87wxIdKSXRgA3sYMiKTEi1xP8qXIgZPtk3J4fdSxGzes
        FYJ75iJQ==;
Received: from [2001:4bb8:18c:2acc:e75:d48f:65ef:e944] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jy9Ma-0000Lv-IS; Wed, 22 Jul 2020 07:40:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: explicitly include <linux/compat.h> in net/core/sock.c
Date:   Wed, 22 Jul 2020 09:40:27 +0200
Message-Id: <20200722074027.224124-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The buildbot found a config where the header isn't already implicitly
pulled in, so add an explicit include as well.

Fixes: 8c918ffbbad4 ("net: remove compat_sock_common_{get,set}sockopt")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/core/sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index d828bfe1c47dfa..6da54eac2b3456 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -113,6 +113,7 @@
 #include <linux/static_key.h>
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
+#include <linux/compat.h>
 
 #include <linux/uaccess.h>
 
-- 
2.27.0

