Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22711173EAA
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB1Rgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:36:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35360 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgB1Rgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:36:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582911412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dBZXPDMOr7ILdt8SeM4+Ucu/+RHG2lQTp5Yja9jMYEw=;
        b=b6CEtz5lzuHUxUkSFIKCmnvLSDzR3S4uGyAcOd411LM00rb5M2Nz32FI3KvIklob5ceVnI
        ZKZUzLV3XQBfYAthdyWVntP4nCRLV4I6K7L4Oh0bJLratScryd0Z/zM3bHH2AuIg2ln1tP
        J7N1rfLHGWLMk/lgW1xUKrD5NeUAyuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-G705ZPzAOYKrj5a8Ci8shQ-1; Fri, 28 Feb 2020 12:36:50 -0500
X-MC-Unique: G705ZPzAOYKrj5a8Ci8shQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E788B107ACC9;
        Fri, 28 Feb 2020 17:36:49 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.36.118.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F6C15C21A;
        Fri, 28 Feb 2020 17:36:48 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 2/2] man: rdma-statistic: Add filter description
Date:   Fri, 28 Feb 2020 18:36:25 +0100
Message-Id: <47dbeb5ef715c89c941d0449e29d20da5f4612dc.1582910855.git.aclaudi@redhat.com>
In-Reply-To: <cover.1582910855.git.aclaudi@redhat.com>
References: <cover.1582910855.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for filters on rdma statistics show command.
Also add a filter description on the help message of the command.
Additionally, fix some whitespace issue in the man page.

Reported-by: Zhaojuan Guo <zguo@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/rdma-statistic.8 | 16 ++++++++++++----
 rdma/stat.c               |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
index e3f4b51b15524..7de495c919928 100644
--- a/man/man8/rdma-statistic.8
+++ b/man/man8/rdma-statistic.8
@@ -9,7 +9,7 @@ rdma-statistic \- RDMA statistic counter configuration
 .B rdma
 .RI "[ " OPTIONS " ]"
 .B statistic
-.RI  " { " COMMAND " | "
+.RI  "{ " COMMAND " | "
 .BR help " }"
 .sp
=20
@@ -23,6 +23,7 @@ rdma-statistic \- RDMA statistic counter configuration
 .RI "[ " OBJECT " ]"
 .B show link
 .RI "[ " DEV/PORT_INDX " ]"
+.RI "[ " FILTER_NAME " " FILTER_VALUE " ]"
=20
 .ti -8
 .B rdma statistic
@@ -34,7 +35,7 @@ rdma-statistic \- RDMA statistic counter configuration
 .IR OBJECT
 .B set
 .IR COUNTER_SCOPE
-.RI "[ " DEV/PORT_INDEX "]"
+.RI "[ " DEV/PORT_INDEX " ]"
 .B auto
 .RI "{ " CRITERIA " | "
 .BR off " }"
@@ -44,7 +45,7 @@ rdma-statistic \- RDMA statistic counter configuration
 .IR OBJECT
 .B bind
 .IR COUNTER_SCOPE
-.RI "[ " DEV/PORT_INDEX "]"
+.RI "[ " DEV/PORT_INDEX " ]"
 .RI "[ " OBJECT-ID " ]"
 .RI "[ " COUNTER-ID " ]"
=20
@@ -53,7 +54,7 @@ rdma-statistic \- RDMA statistic counter configuration
 .IR OBJECT
 .B unbind
 .IR COUNTER_SCOPE
-.RI "[ " DEV/PORT_INDEX "]"
+.RI "[ " DEV/PORT_INDEX " ]"
 .RI "[ " COUNTER-ID " ]"
 .RI "[ " OBJECT-ID " ]"
=20
@@ -69,6 +70,10 @@ rdma-statistic \- RDMA statistic counter configuration
 .IR CRITERIA " :=3D "
 .RB "{ " type " }"
=20
+.ti -8
+.IR FILTER_NAME " :=3D "
+.RB "{ " cntn " | " lqpn " | " pid " }"
+
 .SH "DESCRIPTION"
 .SS rdma statistic [object] show - Queries the specified RDMA device for=
 RDMA and driver-specific statistics. Show the default hw counters if obj=
ect is not specified
=20
@@ -79,6 +84,9 @@ rdma-statistic \- RDMA statistic counter configuration
 .I "PORT_INDEX"
 - specifies counters on this RDMA port to show.
=20
+.I "FILTER_NAME
+- specifies a filter to show only the results matching it.
+
 .SS rdma statistic <object> set - configure counter statistic auto-mode =
for a specific device/port
 In auto mode all objects belong to one category are bind automatically t=
o a single counter set. Not applicable for MR's.
=20
diff --git a/rdma/stat.c b/rdma/stat.c
index 2f57528700bc4..8d4b7a11681b3 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -23,6 +23,7 @@ static int stat_help(struct rd *rd)
 	pr_out("where  OBJECT: =3D { qp }\n");
 	pr_out("       CRITERIA : =3D { type }\n");
 	pr_out("       COUNTER_SCOPE: =3D { link | dev }\n");
+	pr_out("       FILTER_NAME: =3D { cntn | lqpn | pid }\n");
 	pr_out("Examples:\n");
 	pr_out("       %s statistic qp show\n", rd->filename);
 	pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
--=20
2.24.1

