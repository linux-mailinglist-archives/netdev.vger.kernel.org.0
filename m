Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AD62B82F6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgKRRSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:18:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbgKRRSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w/3365W+5YPdveY2z8dANCO+24TWinqEY1FQBLfd2v4=;
        b=O6fAUw6EN57sU2duFEXdVJR+OmaUmOJEvJ7/62T/82zhc64HbC4I7/W+mtlY6uzgTl8G8P
        drhFZqvznHFjErVE1Ockp8whR2iZGSeACOohXM92RoQPK2XtlYc2O2G8edQimidZGFqFlp
        eAhXdtF2cE6/6eV9thxluIVzYgXX2n8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-j25L1XHwM0CtOb5wLQ8J4g-1; Wed, 18 Nov 2020 12:18:36 -0500
X-MC-Unique: j25L1XHwM0CtOb5wLQ8J4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AC741005D5A;
        Wed, 18 Nov 2020 17:18:35 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF95F60843;
        Wed, 18 Nov 2020 17:18:33 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v5 1/6] ethtool: add ETHTOOL_COALESCE_ALL_PARAMS define
Date:   Wed, 18 Nov 2020 18:18:22 +0100
Message-Id: <20201118171827.48143-2-acardace@redhat.com>
In-Reply-To: <20201118171827.48143-1-acardace@redhat.com>
References: <20201118171827.48143-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bitmask represents all existing coalesce parameters.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/ethtool.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6408b446051f..e3da25b51ae4 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -215,6 +215,7 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
 #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(21, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
-- 
2.28.0

