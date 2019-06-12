Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558FA42E1F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388591AbfFLRxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:53:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388122AbfFLRxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I4JuIzfBUKUzNhsVN5Ij21Ostvd2xi3sgD9JCY82Obs=; b=Uy/YnzP945rTVuULQmRk4bjreI
        Zt4OZUdCtWZQ2W3LbDJJp9kzXuuAY7eYMvHBVFL5lSMtjXj3uvLzEnvc57Y4/iG0O4KnM4fQ/RGX7
        0iEX7D8kBivnici32NUshPCs9skghoA6FY20DI9biYD+kn3o0NZKgtBS1YRxy9ED1qDFcFwfXGkO9
        bscV903PoVjYnjCgrhWiV+argE3HESuiszTdF9TygMFH6hKghXLlwqwtTRbjyVkMcskmS2GqBHc7M
        tpIEhy8Avhvs5HXJ3xxn/yGYiRHXw1PD/gDT2RHWdUgbXK/IuwsO/dbT5Y/DFYZCVzxd/24L7mirJ
        0chrKflw==;
Received: from 201.86.169.251.dynamic.adsl.gvt.net.br ([201.86.169.251] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hb7Qs-0002Dh-Qr; Wed, 12 Jun 2019 17:53:11 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hb7Qq-0001gq-ET; Wed, 12 Jun 2019 14:53:08 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v4 16/28] docs: netlabel: convert docs to ReST and rename to *.rst
Date:   Wed, 12 Jun 2019 14:52:52 -0300
Message-Id: <873f41ab07225b8f6cef5d13cc19a387227817ec.1560361364.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560361364.git.mchehab+samsung@kernel.org>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert netlabel documentation to ReST.

This was trivial: just add proper title markups.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Acked-by: Paul Moore <paul@paul-moore.com>
---
 .../{cipso_ipv4.txt => cipso_ipv4.rst}        | 19 +++++++++++------
 Documentation/netlabel/draft_ietf.rst         |  5 +++++
 Documentation/netlabel/index.rst              | 21 +++++++++++++++++++
 .../{introduction.txt => introduction.rst}    | 16 +++++++++-----
 .../{lsm_interface.txt => lsm_interface.rst}  | 16 +++++++++-----
 5 files changed, 61 insertions(+), 16 deletions(-)
 rename Documentation/netlabel/{cipso_ipv4.txt => cipso_ipv4.rst} (87%)
 create mode 100644 Documentation/netlabel/draft_ietf.rst
 create mode 100644 Documentation/netlabel/index.rst
 rename Documentation/netlabel/{introduction.txt => introduction.rst} (91%)
 rename Documentation/netlabel/{lsm_interface.txt => lsm_interface.rst} (88%)

diff --git a/Documentation/netlabel/cipso_ipv4.txt b/Documentation/netlabel/cipso_ipv4.rst
similarity index 87%
rename from Documentation/netlabel/cipso_ipv4.txt
rename to Documentation/netlabel/cipso_ipv4.rst
index a6075481fd60..cbd3f3231221 100644
--- a/Documentation/netlabel/cipso_ipv4.txt
+++ b/Documentation/netlabel/cipso_ipv4.rst
@@ -1,10 +1,13 @@
+===================================
 NetLabel CIPSO/IPv4 Protocol Engine
-==============================================================================
+===================================
+
 Paul Moore, paul.moore@hp.com
 
 May 17, 2006
 
- * Overview
+Overview
+========
 
 The NetLabel CIPSO/IPv4 protocol engine is based on the IETF Commercial
 IP Security Option (CIPSO) draft from July 16, 1992.  A copy of this
@@ -13,7 +16,8 @@ draft can be found in this directory
 it to an RFC standard it has become a de-facto standard for labeled
 networking and is used in many trusted operating systems.
 
- * Outbound Packet Processing
+Outbound Packet Processing
+==========================
 
 The CIPSO/IPv4 protocol engine applies the CIPSO IP option to packets by
 adding the CIPSO label to the socket.  This causes all packets leaving the
@@ -24,7 +28,8 @@ label by using the NetLabel security module API; if the NetLabel "domain" is
 configured to use CIPSO for packet labeling then a CIPSO IP option will be
 generated and attached to the socket.
 
- * Inbound Packet Processing
+Inbound Packet Processing
+=========================
 
 The CIPSO/IPv4 protocol engine validates every CIPSO IP option it finds at the
 IP layer without any special handling required by the LSM.  However, in order
@@ -33,7 +38,8 @@ NetLabel security module API to extract the security attributes of the packet.
 This is typically done at the socket layer using the 'socket_sock_rcv_skb()'
 LSM hook.
 
- * Label Translation
+Label Translation
+=================
 
 The CIPSO/IPv4 protocol engine contains a mechanism to translate CIPSO security
 attributes such as sensitivity level and category to values which are
@@ -42,7 +48,8 @@ Domain Of Interpretation (DOI) definition and are configured through the
 NetLabel user space communication layer.  Each DOI definition can have a
 different security attribute mapping table.
 
- * Label Translation Cache
+Label Translation Cache
+=======================
 
 The NetLabel system provides a framework for caching security attribute
 mappings from the network labels to the corresponding LSM identifiers.  The
diff --git a/Documentation/netlabel/draft_ietf.rst b/Documentation/netlabel/draft_ietf.rst
new file mode 100644
index 000000000000..5ed39ab8234b
--- /dev/null
+++ b/Documentation/netlabel/draft_ietf.rst
@@ -0,0 +1,5 @@
+Draft IETF CIPSO IP Security
+----------------------------
+
+ .. include:: draft-ietf-cipso-ipsecurity-01.txt
+    :literal:
diff --git a/Documentation/netlabel/index.rst b/Documentation/netlabel/index.rst
new file mode 100644
index 000000000000..47f1e0e5acd1
--- /dev/null
+++ b/Documentation/netlabel/index.rst
@@ -0,0 +1,21 @@
+:orphan:
+
+========
+NetLabel
+========
+
+.. toctree::
+    :maxdepth: 1
+
+    introduction
+    cipso_ipv4
+    lsm_interface
+
+    draft_ietf
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/netlabel/introduction.txt b/Documentation/netlabel/introduction.rst
similarity index 91%
rename from Documentation/netlabel/introduction.txt
rename to Documentation/netlabel/introduction.rst
index 3caf77bcff0f..9333bbb0adc1 100644
--- a/Documentation/netlabel/introduction.txt
+++ b/Documentation/netlabel/introduction.rst
@@ -1,10 +1,13 @@
+=====================
 NetLabel Introduction
-==============================================================================
+=====================
+
 Paul Moore, paul.moore@hp.com
 
 August 2, 2006
 
- * Overview
+Overview
+========
 
 NetLabel is a mechanism which can be used by kernel security modules to attach
 security attributes to outgoing network packets generated from user space
@@ -12,7 +15,8 @@ applications and read security attributes from incoming network packets.  It
 is composed of three main components, the protocol engines, the communication
 layer, and the kernel security module API.
 
- * Protocol Engines
+Protocol Engines
+================
 
 The protocol engines are responsible for both applying and retrieving the
 network packet's security attributes.  If any translation between the network
@@ -24,7 +28,8 @@ the NetLabel kernel security module API described below.
 Detailed information about each NetLabel protocol engine can be found in this
 directory.
 
- * Communication Layer
+Communication Layer
+===================
 
 The communication layer exists to allow NetLabel configuration and monitoring
 from user space.  The NetLabel communication layer uses a message based
@@ -33,7 +38,8 @@ formatting of these NetLabel messages as well as the Generic NETLINK family
 names can be found in the 'net/netlabel/' directory as comments in the
 header files as well as in 'include/net/netlabel.h'.
 
- * Security Module API
+Security Module API
+===================
 
 The purpose of the NetLabel security module API is to provide a protocol
 independent interface to the underlying NetLabel protocol engines.  In addition
diff --git a/Documentation/netlabel/lsm_interface.txt b/Documentation/netlabel/lsm_interface.rst
similarity index 88%
rename from Documentation/netlabel/lsm_interface.txt
rename to Documentation/netlabel/lsm_interface.rst
index 638c74f7de7f..026fc267f798 100644
--- a/Documentation/netlabel/lsm_interface.txt
+++ b/Documentation/netlabel/lsm_interface.rst
@@ -1,10 +1,13 @@
+========================================
 NetLabel Linux Security Module Interface
-==============================================================================
+========================================
+
 Paul Moore, paul.moore@hp.com
 
 May 17, 2006
 
- * Overview
+Overview
+========
 
 NetLabel is a mechanism which can set and retrieve security attributes from
 network packets.  It is intended to be used by LSM developers who want to make
@@ -12,7 +15,8 @@ use of a common code base for several different packet labeling protocols.
 The NetLabel security module API is defined in 'include/net/netlabel.h' but a
 brief overview is given below.
 
- * NetLabel Security Attributes
+NetLabel Security Attributes
+============================
 
 Since NetLabel supports multiple different packet labeling protocols and LSMs
 it uses the concept of security attributes to refer to the packet's security
@@ -24,7 +28,8 @@ configuration.  It is up to the LSM developer to translate the NetLabel
 security attributes into whatever security identifiers are in use for their
 particular LSM.
 
- * NetLabel LSM Protocol Operations
+NetLabel LSM Protocol Operations
+================================
 
 These are the functions which allow the LSM developer to manipulate the labels
 on outgoing packets as well as read the labels on incoming packets.  Functions
@@ -32,7 +37,8 @@ exist to operate both on sockets as well as the sk_buffs directly.  These high
 level functions are translated into low level protocol operations based on how
 the administrator has configured the NetLabel subsystem.
 
- * NetLabel Label Mapping Cache Operations
+NetLabel Label Mapping Cache Operations
+=======================================
 
 Depending on the exact configuration, translation between the network packet
 label and the internal LSM security identifier can be time consuming.  The
-- 
2.21.0

