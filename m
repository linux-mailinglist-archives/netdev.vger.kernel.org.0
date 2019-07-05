Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DD660637
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfGEM6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:58:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGEM6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 08:58:02 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4164130842AC;
        Fri,  5 Jul 2019 12:58:02 +0000 (UTC)
Received: from [192.168.41.206] (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7F4E806AE;
        Fri,  5 Jul 2019 12:57:56 +0000 (UTC)
Subject: [PATCH net-next V2] MAINTAINERS: Add page_pool maintainer entry
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Fri, 05 Jul 2019 14:57:55 +0200
Message-ID: <156233140902.25371.7033961410347587264.stgit@carbon>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 05 Jul 2019 12:58:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this release cycle the number of NIC drivers using page_pool
will likely reach 4 drivers.  It is about time to add a maintainer
entry.  Add myself and Ilias.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
V2: Ilias also volunteered to co-maintain over IRC

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 449e7cdb3303..22655aa84a46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11902,6 +11902,14 @@ F:	kernel/padata.c
 F:	include/linux/padata.h
 F:	Documentation/padata.txt
 
+PAGE POOL
+M:	Jesper Dangaard Brouer <hawk@kernel.org>
+M:	Ilias Apalodimas <ilias.apalodimas@linaro.org>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	net/core/page_pool.c
+F:	include/net/page_pool.h
+
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
 L:	platform-driver-x86@vger.kernel.org

