Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386F12BA64F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgKTJg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:36:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727181AbgKTJg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605864987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=b8XNxdn/nhZpmTAEQGPiad2tfJbUVf3hCZe5Qyij1G8=;
        b=g0zlpPI368oVxh5LOrXblZU9QoLQMLDG7kHo1SBd6MpdKmpjxEP80FMnadQHtCFmE51BBD
        RGw4rHJykOQMfqdCkxGHoX7UNoWqXpMRpSx9YglTCxK3zAWX9SkLo5MeMrrUiIuKacRA4d
        wqTJ/V0maE/1Yr9z7DUEdqHraKFDuG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-_SmNCnV1Mgez4xta-TOQsg-1; Fri, 20 Nov 2020 04:36:25 -0500
X-MC-Unique: _SmNCnV1Mgez4xta-TOQsg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 007721842145;
        Fri, 20 Nov 2020 09:36:24 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53C385D9D0;
        Fri, 20 Nov 2020 09:36:20 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 39D5B3213845D;
        Fri, 20 Nov 2020 10:36:19 +0100 (CET)
Subject: [PATCH net-next] MAINTAINERS: Update page pool entry
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 20 Nov 2020 10:36:19 +0100
Message-ID: <160586497895.2808766.2902017028647296556.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some file F: matches that is related to page_pool.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f827f504251b..efcdc68a03b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13179,6 +13179,8 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	include/net/page_pool.h
 F:	net/core/page_pool.c
+F:	include/trace/events/page_pool.h
+F:	Documentation/networking/page_pool.rst
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Harald Welte <laforge@gnumonks.org>


