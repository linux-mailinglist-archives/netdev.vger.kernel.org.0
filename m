Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793AF2C0C11
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgKWNmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:42:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729809AbgKWNmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606138957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gqHAFRowaZu51kN+K74epswEgC/xCt4x8LFScZ0f79w=;
        b=VsoWZl4KrSjRYqKw/wWOistO9fUbO8JcI3Nx5Pr78F7jGHl0CowgGeEjuKkI3gn/18nA8W
        OPIfv2cUSMsyxIgPX7xkeO8Lztv6inqLwsN1NJSMj8+Q6Ml03pqfNSS78c41U2m/rOBZgP
        I0HAQQlLaquBPyHe9/6eYoP/HujBA04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-ZOIva3EROQKRwkg1RqgDPA-1; Mon, 23 Nov 2020 08:42:32 -0500
X-MC-Unique: ZOIva3EROQKRwkg1RqgDPA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3607107AFB2;
        Mon, 23 Nov 2020 13:42:31 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DA8010023AD;
        Mon, 23 Nov 2020 13:42:28 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B8DF132138453;
        Mon, 23 Nov 2020 14:42:26 +0100 (CET)
Subject: [PATCH net-next V2] MAINTAINERS: Update page pool entry
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 23 Nov 2020 14:42:26 +0100
Message-ID: <160613894639.2826716.14635284017814375894.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some file F: matches that is related to page_pool.

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f827f504251b..a607ff2156dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13177,7 +13177,9 @@ M:	Jesper Dangaard Brouer <hawk@kernel.org>
 M:	Ilias Apalodimas <ilias.apalodimas@linaro.org>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/networking/page_pool.rst
 F:	include/net/page_pool.h
+F:	include/trace/events/page_pool.h
 F:	net/core/page_pool.c
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER


