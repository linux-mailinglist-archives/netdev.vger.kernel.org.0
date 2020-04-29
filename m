Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5356C1BE4F8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgD2RSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 13:18:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726481AbgD2RSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 13:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6avqHSEb/cZhwd5OZz8U3buVE9ukc9RXfQodB0t543E=;
        b=FcCcsfU5oxKmXJtfLMxmJq2ZxzUKPSlL53wO5+bZqtpRoCCJkiroo21Z58GFuM5tSV9tBO
        6a3gQyHJBdpqAmPS7lf661Jsf6eaOIhksyxOM0EBMrRB3YwXramySPrzw0AcpDE6D/RZsB
        vuawJFYk0SIamFvflUjxQEvgsXfWJEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-yoeDv90SNLm5WzaQ-BP8BA-1; Wed, 29 Apr 2020 13:17:56 -0400
X-MC-Unique: yoeDv90SNLm5WzaQ-BP8BA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF37C107ACCA;
        Wed, 29 Apr 2020 17:17:55 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EBF45D76A;
        Wed, 29 Apr 2020 17:17:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Andrea Claudi <aclaudi@redhat.com>
Subject: [PATCH iproute2-next] man: ip.8: add reference to mptcp man-page
Date:   Wed, 29 Apr 2020 19:17:22 +0200
Message-Id: <bc8e7bce10677759e39fb8524f4f3e5a991313fe.1588180491.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While at it, additionally fix a mandoc warning in mptcp.8

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 man/man8/ip-mptcp.8 | 1 -
 man/man8/ip.8       | 7 ++++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index f6457e97..ef8409ea 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -2,7 +2,6 @@
 .SH "NAME"
 ip-mptcp \- MPTCP path manager configuration
 .SH "SYNOPSIS"
-.sp
 .ad l
 .in +8
 .ti -8
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index 1613f790..c9f7671e 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -22,7 +22,7 @@ ip \- show / manipulate routing, network devices, inter=
faces and tunnels
 .BR link " | " address " | " addrlabel " | " route " | " rule " | " neig=
h " | "\
  ntable " | " tunnel " | " tuntap " | " maddress " | "  mroute " | " mru=
le " | "\
  monitor " | " xfrm " | " netns " | "  l2tp " | "  tcp_metrics " | " tok=
en " | "\
- macsec " | " vrf " }"
+ macsec " | " vrf " | " mptcp " }"
 .sp
=20
 .ti -8
@@ -268,6 +268,10 @@ readability.
 .B monitor
 - watch for netlink messages.
=20
+.TP
+.B mptcp
+- manage MPTCP path manager.
+
 .TP
 .B mroute
 - multicast routing cache entry.
@@ -405,6 +409,7 @@ was written by Alexey N. Kuznetsov and added in Linux=
 2.2.
 .BR ip-link (8),
 .BR ip-maddress (8),
 .BR ip-monitor (8),
+.BR ip-mptcp (8),
 .BR ip-mroute (8),
 .BR ip-neighbour (8),
 .BR ip-netns (8),
--=20
2.21.1

