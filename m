Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202871509DC
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgBCPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:34:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727201AbgBCPe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580744065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1dVNMmi9+IrW73Rlj89dIAp6HaWx65TNxJYOXYg8pqk=;
        b=Zz5eCXbGWX2B0DC2E4lFZx/tkHQC14Xr1AXBoI/icd1cMU00c8x6FHQmsehQLqhTi92Jo/
        EpWfOpFEhapgkyWKD+Jz616ujbVb6hVogKA4glEdjoz9PWuqPojS7oQ9WuNnowOoqAG15w
        STBsAAqnONhsdpxhXU+92R4E9p2kmk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-EAYj6Hn-PfWcXSke2nEjHA-1; Mon, 03 Feb 2020 10:34:21 -0500
X-MC-Unique: EAYj6Hn-PfWcXSke2nEjHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED54410E1C04;
        Mon,  3 Feb 2020 15:34:19 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8794760BE0;
        Mon,  3 Feb 2020 15:34:18 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Roman Mashak <mrv@mojatatu.com>, Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net 2/2] tc-testing: add missing 'nsPlugin' to basic.json
Date:   Mon,  3 Feb 2020 16:29:30 +0100
Message-Id: <5211afb18c18b0fb9da633d364874125ac64bae6.1580740848.git.dcaratti@redhat.com>
In-Reply-To: <cover.1580740848.git.dcaratti@redhat.com>
References: <cover.1580740848.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

since tdc tests for cls_basic need $DEV1, use 'nsPlugin' so that the
following command can be run without errors:

 [root@f31 tc-testing]# ./tdc.py -c basic

Fixes: 4717b05328ba ("tc-testing: Introduced tdc tests for basic filter")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../tc-testing/tc-tests/filters/basic.json    | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.js=
on b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index 2e361cea63bc..98a20faf3198 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -6,6 +6,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -25,6 +28,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -44,6 +50,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -63,6 +72,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -82,6 +94,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -101,6 +116,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -120,6 +138,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -139,6 +160,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -158,6 +182,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -177,6 +204,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -196,6 +226,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -215,6 +248,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -234,6 +270,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -253,6 +292,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -272,6 +314,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -291,6 +336,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -310,6 +358,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
--=20
2.24.1

