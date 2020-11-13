Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF5B2B290B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgKMXRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:17:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgKMXRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 18:17:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605309432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JFbVbmAuoqd0W2DgzTzcymTCV+6MrqXZCAfMvklgpPI=;
        b=QUIusnGJA4VEfU/YT9awWgKes9TNZDnqFgsWSa0djivMODlmGvaW3dwAHNG4rU78pNsw5k
        9q+dfElOyawN7ehsrw0LgwiPvmXXPUNMjjbTnedXsaN0LMR7ZS4aUUuWKvZCe/rIDgnLxo
        hk553AesehlxlZlEgwMRQ/nSqJrak9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-dQb-AMayMwui8DFuBco2sg-1; Fri, 13 Nov 2020 18:17:09 -0500
X-MC-Unique: dQb-AMayMwui8DFuBco2sg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1ACC80EF84;
        Fri, 13 Nov 2020 23:17:07 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A7435B4A3;
        Fri, 13 Nov 2020 23:17:06 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v3 1/4] ethtool: add ETHTOOL_COALESCE_ALL_PARAMS define
Date:   Sat, 14 Nov 2020 00:16:52 +0100
Message-Id: <20201113231655.139948-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bitmask represents all existing coalesce parameters.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
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

