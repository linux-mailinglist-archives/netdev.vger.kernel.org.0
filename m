Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784891723D7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgB0QqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:46:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20192 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730033AbgB0QqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582821980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=358Vnk4CWTRZaVQrJkbFfTGl3klRgzHDoM1RTAPVi14=;
        b=PKaQxRV3qwSuag3Oy7S73Wvo/bFA8FuFWwPAFigdhXYXfU9oG/cjLDPPVxKLOdYtwXLeLL
        WWQ1YDQM+BC1O9l1TJWYofJObDAJOAZ+IjWtJgNt6VDACqua80L4NdlESX0PRyIzKC8bUb
        y7MhuvlIDkKDtHKbzSu/g/XkVyvZZQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-Z4P_8cgFOiqBq-0GyvcaIw-1; Thu, 27 Feb 2020 11:46:13 -0500
X-MC-Unique: Z4P_8cgFOiqBq-0GyvcaIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 870FB14E6;
        Thu, 27 Feb 2020 16:46:12 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.36.118.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B885F92994;
        Thu, 27 Feb 2020 16:46:07 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] man: ip.8: Add missing vrf subcommand description
Date:   Thu, 27 Feb 2020 17:45:43 +0100
Message-Id: <acd21cee80dfcb99c131059a8e393b6a62de0d64.1582821904.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description to the vrf subcommand and a reference to the
dedicated man page.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/ip.8 | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/man/man8/ip.8 b/man/man8/ip.8
index 1661aa678f7b2..1613f790a14b2 100644
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
- macsec " }"
+ macsec " | " vrf " }"
 .sp
=20
 .ti -8
@@ -312,6 +312,10 @@ readability.
 .B tuntap
 - manage TUN/TAP devices.
=20
+.TP
+.B vrf
+- manage virtual routing and forwarding devices.
+
 .TP
 .B xfrm
 - manage IPSec policies.
@@ -410,6 +414,7 @@ was written by Alexey N. Kuznetsov and added in Linux=
 2.2.
 .BR ip-tcp_metrics (8),
 .BR ip-token (8),
 .BR ip-tunnel (8),
+.BR ip-vrf (8),
 .BR ip-xfrm (8)
 .br
 .RB "IP Command reference " ip-cref.ps
--=20
2.24.1

