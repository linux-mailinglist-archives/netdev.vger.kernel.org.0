Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBCF173EA9
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgB1Rgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:36:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgB1Rgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:36:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582911410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fJB5cd3ehtsh40HrzBNEBjaw5V5/OEN82lgJ2MVFcQ=;
        b=ICUyr4eYFgz/rV2BXk2K8DiQYGXmp62zazRE2AEtjNpU5AQPe96nSIUfgFdUPQ39s1DtdR
        oLbAHGL0kgIjDmkVM/cvi2vyuioawZEesoLbXrlriv8AcKAsC+LKy8DjWQL9XF3y8bLtgC
        DikXV0ommj7VXPonO51Uv6bFz2Row/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-d6MUcgPFOiC_bGKLqbTVnQ-1; Fri, 28 Feb 2020 12:36:49 -0500
X-MC-Unique: d6MUcgPFOiC_bGKLqbTVnQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCE79107ACC5;
        Fri, 28 Feb 2020 17:36:47 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.36.118.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23BBF5C21A;
        Fri, 28 Feb 2020 17:36:44 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 1/2] man: rdma.8: Add missing resource subcommand description
Date:   Fri, 28 Feb 2020 18:36:24 +0100
Message-Id: <05db5e27c0f38c9fa9c812c7f9d4d5a354edf6e3.1582910855.git.aclaudi@redhat.com>
In-Reply-To: <cover.1582910855.git.aclaudi@redhat.com>
References: <cover.1582910855.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add resource subcommand in the OBJECT section and a short
description for it.

Reported-by: Zhaojuan Guo <zguo@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/rdma.8 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index ef29b1c633644..221bf3343bf4c 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -19,7 +19,7 @@ rdma \- RDMA tool
=20
 .ti -8
 .IR OBJECT " :=3D { "
-.BR dev " | " link " | " system " | " statistic " }"
+.BR dev " | " link " | " resource " | " system " | " statistic " }"
 .sp
=20
 .ti -8
@@ -70,6 +70,10 @@ Generate JSON output.
 .B link
 - RDMA port related.
=20
+.TP
+.B resource
+- RDMA resource configuration.
+
 .TP
 .B sys
 - RDMA subsystem related.
--=20
2.24.1

