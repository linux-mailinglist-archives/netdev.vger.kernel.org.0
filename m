Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60042B6884
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgKQPU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:20:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728430AbgKQPU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 10:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605626425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w/3365W+5YPdveY2z8dANCO+24TWinqEY1FQBLfd2v4=;
        b=Z5nAkpVkuheM40i63dPdKdRHZy4KWW63r55iilcU2T2ZZhjTaJeJB7hm8e397yVUWdRT8u
        BS9JdpkABYFfgLjx+fhOtShNyrKiIoi1UQilN10JyjU68LVGRnIxq4I3XqNP4O+q1lwD4x
        E/w/YDXYKn1QXkXlHc0p3sVlhpcT1R4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-NXSn_9vaN9y1uUNFrW1dJw-1; Tue, 17 Nov 2020 10:20:23 -0500
X-MC-Unique: NXSn_9vaN9y1uUNFrW1dJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90B48803646;
        Tue, 17 Nov 2020 15:20:22 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E9C455765;
        Tue, 17 Nov 2020 15:20:21 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v4 1/6] ethtool: add ETHTOOL_COALESCE_ALL_PARAMS define
Date:   Tue, 17 Nov 2020 16:20:10 +0100
Message-Id: <20201117152015.142089-2-acardace@redhat.com>
In-Reply-To: <20201117152015.142089-1-acardace@redhat.com>
References: <20201117152015.142089-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

