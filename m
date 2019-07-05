Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED7D60620
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfGEMnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbfGEMnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 08:43:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B64823E6E7;
        Fri,  5 Jul 2019 12:43:04 +0000 (UTC)
Received: from [192.168.41.206] (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C83011B479;
        Fri,  5 Jul 2019 12:42:59 +0000 (UTC)
Subject: [PATCH net-next] MAINTAINERS: Add page_pool maintainer entry
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Fri, 05 Jul 2019 14:42:58 +0200
Message-ID: <156233057837.24836.8073599953416421093.stgit@carbon>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 05 Jul 2019 12:43:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this release cycle the number of NIC drivers using page_pool
will likely reach 4 drivers.  It is about time to add a maintainer
entry.  Add myself.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 449e7cdb3303..1a8e0a01bf03 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11902,6 +11902,13 @@ F:	kernel/padata.c
 F:	include/linux/padata.h
 F:	Documentation/padata.txt
 
+PAGE POOL
+M:	Jesper Dangaard Brouer <hawk@kernel.org>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	net/core/page_pool.c
+F:	include/net/page_pool.h
+
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
 L:	platform-driver-x86@vger.kernel.org

