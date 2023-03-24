Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655686C7D53
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjCXLij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjCXLic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:32 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8AE1E1DF;
        Fri, 24 Mar 2023 04:38:29 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l27so1492973wrb.2;
        Fri, 24 Mar 2023 04:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fz33cl1Em+iCEUOiB+c8bhu29hBoUMGh0ZsVhdcIWf0=;
        b=YotdmO//d6dCF6trw9eN6gwtU071nfpffOfim2PfSbwu97ONGS/8uhE9Psi48LThoA
         rQn329mGz3XkVFcNhueaK+7AByXcqkzmoweV2y7DDCLQPaGTEstHCBkPC7cevo+zy5s5
         IlQpvztNlUtN7rBB+qzjX92/kWjsIEVvSCD5R0CuPKXWcr3TzRCQyZbwoyFKE7sfcxlf
         8JMgTxT/zpEZYjZdJvoO2K5AELpa1gBPMyOSkeYJUIGyZr19YkfZLFKUxXFl9CD5X8Ak
         8hgByrTstsDb5DVjNQ+YdNVFhgmvCDISKyXbpGBNgidKOkI8zkmSNgYadtS2czI0PxwZ
         /awQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fz33cl1Em+iCEUOiB+c8bhu29hBoUMGh0ZsVhdcIWf0=;
        b=OgivpWSOUwTzZTm04+baQQQvurJ8B7+8KBLBAx5dBkXQ/LFdOtC64WQIligoVS7kZk
         eklJRz9IWkZJ9WmpMPaGawO+hxZgmPRZo6dx0YZZFlp+fdB2FwBfPrZkCyuBoYjJNQIt
         renzJvDkLFngBF1iNx0ZTFsQyrjFemzIctHGY2Md/I6huXjpJxR3R4HotpEQ5gjloIZA
         hpsyvIwQeIhjTwRCAsduzkAKxIMFIMwI4BI/3fH5+g4vMq+anfhV/YWmh+NzfxK4eHcn
         ZtD2JORbvEWlcPRSILB13Lc3vgKrIVTOUwTunfYFtcV9s5X9RI/itKHLOtA+AMYjRo7W
         fF/Q==
X-Gm-Message-State: AAQBX9eGi/V86rXcIDL/f1tmJDkkb1KekvHhe1eBZ+NS8vZYfAmDCQt0
        kGxdDDNjt7Mm2TY5B1BGBMcJC1s9q5Knuw==
X-Google-Smtp-Source: AKy350b0u7S9+b2L7MdWO5XMOQe8stiDFPKup0ngyCE7NHB1A0IjMPfEy/ooYipXJuuM+3ViPZxnqQ==
X-Received: by 2002:a05:6000:c:b0:2c7:ae57:5acc with SMTP id h12-20020a056000000c00b002c7ae575accmr2003665wrx.26.1679657907689;
        Fri, 24 Mar 2023 04:38:27 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:27 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 4/7] tools: ynl: Add fixed-header support to ynl
Date:   Fri, 24 Mar 2023 11:37:31 +0000
Message-Id: <20230324113734.1473-5-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230324113734.1473-1-donald.hunter@gmail.com>
References: <20230324113734.1473-1-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for netlink families that add an optional fixed header structure
after the genetlink header and before any attributes. The fixed-header can be
specified on a per op basis, or once for all operations, which serves as a
default value that can be overridden.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml | 10 +++++++++
 tools/net/ynl/lib/nlspec.py                 | 21 ++++++++++++-------
 tools/net/ynl/lib/ynl.py                    | 23 +++++++++++++++++----
 3 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index d50c78b9f42d..3b8984122383 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -261,6 +261,13 @@ properties:
       async-enum:
         description: Name for the enum type with notifications/events.
         type: string
+      # Start genetlink-legacy
+      fixed-header: &fixed-header
+        description: |
+          Name of the structure defininig the optional fixed-length protocol header. This header is
+          placed in a message after the netlink and genetlink headers and before any attributes.
+        type: string
+      # End genetlink-legacy
       list:
         description: List of commands
         type: array
@@ -293,6 +300,9 @@ properties:
               type: array
               items:
                 enum: [ strict, dump ]
+            # Start genetlink-legacy
+            fixed-header: *fixed-header
+            # End genetlink-legacy
             do: &subop-type
               description: Main command handler.
               type: object
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index a08f6dda5b79..09dbb6c51ee9 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -258,16 +258,17 @@ class SpecOperation(SpecElement):
     Information about a single Netlink operation.
 
     Attributes:
-        value       numerical ID when serialized, None if req/rsp values differ
+        value           numerical ID when serialized, None if req/rsp values differ
 
-        req_value   numerical ID when serialized, user -> kernel
-        rsp_value   numerical ID when serialized, user <- kernel
-        is_call     bool, whether the operation is a call
-        is_async    bool, whether the operation is a notification
-        is_resv     bool, whether the operation does not exist (it's just a reserved ID)
-        attr_set    attribute set name
+        req_value       numerical ID when serialized, user -> kernel
+        rsp_value       numerical ID when serialized, user <- kernel
+        is_call         bool, whether the operation is a call
+        is_async        bool, whether the operation is a notification
+        is_resv         bool, whether the operation does not exist (it's just a reserved ID)
+        attr_set        attribute set name
+        fixed_header    string, optional name of fixed header struct
 
-        yaml        raw spec as loaded from the spec file
+        yaml            raw spec as loaded from the spec file
     """
     def __init__(self, family, yaml, req_value, rsp_value):
         super().__init__(family, yaml)
@@ -279,6 +280,7 @@ class SpecOperation(SpecElement):
         self.is_call = 'do' in yaml or 'dump' in yaml
         self.is_async = 'notify' in yaml or 'event' in yaml
         self.is_resv = not self.is_async and not self.is_call
+        self.fixed_header = self.yaml.get('fixed-header', family.fixed_header)
 
         # Added by resolve:
         self.attr_set = None
@@ -319,6 +321,7 @@ class SpecFamily(SpecElement):
         msgs_by_value  dict of all messages (indexed by name)
         ops        dict of all valid requests / responses
         consts     dict of all constants/enums
+        fixed_header  string, optional name of family default fixed header struct
     """
     def __init__(self, spec_path, schema_path=None):
         with open(spec_path, "r") as stream:
@@ -392,6 +395,7 @@ class SpecFamily(SpecElement):
         self._resolution_list.append(elem)
 
     def _dictify_ops_unified(self):
+        self.fixed_header = self.yaml['operations'].get('fixed-header')
         val = 1
         for elem in self.yaml['operations']['list']:
             if 'value' in elem:
@@ -403,6 +407,7 @@ class SpecFamily(SpecElement):
             self.msgs[op.name] = op
 
     def _dictify_ops_directional(self):
+        self.fixed_header = self.yaml['operations'].get('fixed-header')
         req_val = rsp_val = 1
         for elem in self.yaml['operations']['list']:
             if 'notify' in elem:
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index b2845a63f6af..5bf024022cfa 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -277,14 +277,22 @@ def _genl_load_families():
 
 
 class GenlMsg:
-    def __init__(self, nl_msg):
+    def __init__(self, nl_msg, fixed_header_members = []):
         self.nl = nl_msg
 
         self.hdr = nl_msg.raw[0:4]
-        self.raw = nl_msg.raw[4:]
+        offset = 4
 
         self.genl_cmd, self.genl_version, _ = struct.unpack("BBH", self.hdr)
 
+        self.fixed_header_attrs = dict()
+        for m in fixed_header_members:
+            format, size = NlAttr.type_formats[m.type]
+            decoded = struct.unpack_from(format, nl_msg.raw, offset)
+            offset += size
+            self.fixed_header_attrs[m.name] = decoded[0]
+
+        self.raw = nl_msg.raw[offset:]
         self.raw_attrs = NlAttrs(self.raw)
 
     def __repr__(self):
@@ -502,6 +510,13 @@ class YnlFamily(SpecFamily):
 
         req_seq = random.randint(1024, 65535)
         msg = _genl_msg(self.family.family_id, nl_flags, op.req_value, 1, req_seq)
+        fixed_header_members = []
+        if op.fixed_header:
+            fixed_header_members = self.consts[op.fixed_header].members
+            for m in fixed_header_members:
+                value = vals.pop(m.name)
+                format, _ = NlAttr.type_formats[m.type]
+                msg += struct.pack(format, value)
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value)
         msg = _genl_msg_finalize(msg)
@@ -528,7 +543,7 @@ class YnlFamily(SpecFamily):
                     done = True
                     break
 
-                gm = GenlMsg(nl_msg)
+                gm = GenlMsg(nl_msg, fixed_header_members)
                 # Check if this is a reply to our request
                 if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.rsp_value:
                     if gm.genl_cmd in self.async_msg_ids:
@@ -538,7 +553,7 @@ class YnlFamily(SpecFamily):
                         print('Unexpected message: ' + repr(gm))
                         continue
 
-                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
+                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name) | gm.fixed_header_attrs)
 
         if not rsp:
             return None
-- 
2.39.0

