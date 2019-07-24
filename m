Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F6D73473
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfGXRA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:00:27 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:53080 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfGXRA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 13:00:27 -0400
Received: by mail-qt1-f201.google.com with SMTP id d26so42073796qte.19
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 10:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G+yYdG6igELhRZiNMxwdMomIHFGwkL0QZy6cMwmj/g0=;
        b=LrR4x2dgaJ21/SAfNkrVkwTHqN2jLKO4ke84XL/QsEdRV/5Sn1GpvkfhDTwZM0K1X9
         JhWNwkcwkNRuOI/zgGnPTp3mqrRRcTuFqusGJZxesYlhcOyeKI2nYbCFFMnn8C4SLnPs
         B6IYygzbcSuUQHp2cHN9VD4UmPNH94a1GLFK7bUMWxuvt5AsztWWd5tqNvSDHHdTF/SE
         ScootZE4fAReRxFaE7iorHjQHoZN8kdIXXoyV3soUb1srcYyBAqOzP2xZVeaHT4MlznN
         PfmxFcrABUCLVMLO2uKKRT3yeFi5q7DcfyhjI87KK7GaGzzOEAyHooXduZWJ/o+FAyWp
         30dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G+yYdG6igELhRZiNMxwdMomIHFGwkL0QZy6cMwmj/g0=;
        b=GOFKq7JJtj65ltuV9FnIyy5VPhxzF/e60RCTVYoG9/j4XxgIxza9dimVRBE4M4s0m+
         TdwAQdwWd96zmi+IqVAD6uE/YUDAvDdN8DtTgGRgV3VEWH0yomDdcvikxiAc7rRCvMNR
         w2O+57jeRq0hxihVfJ+l4FBbVKKCJp340LwCWya3D+kphd1qA21ls2BydIh2TxPRf0pl
         hlgwkxeXKLw4r6p5DUFh9gH2HWiw/qpg5ZVssU1V95mBXB8vHs5hN4zp2VTqeBSuHjJ3
         iIm2oL5exyQwWjLEIPVAFJWw2zDu9/8S1vCvsP5SkJYpyf64kuwGOUGhpT+uBuc1mKt7
         taSg==
X-Gm-Message-State: APjAAAXhmUM3wEWu3fzmPe2E1WstBrStfkxvt4qUIx+Wb7HVvJQoqwkD
        FWCSqV1qM7vOhROMmVnL/kbl+I9mHUGS/WagxUAHvTXcvPg/P2Wwdna04KLshgpa5WmxLYY0Wgm
        iuDWyv0AcoBauL8lSSlZ2HyEk56TmoyQSaURPe84ddYr9icvXysoqyw==
X-Google-Smtp-Source: APXvYqwQqtuORMLGmhbXfDXwexP3LHW5EmV8cQIZTi6c+q2rs3e5zxoanmB8xIL+tL72yYLiPWecakQ=
X-Received: by 2002:a37:dc45:: with SMTP id v66mr54180753qki.24.1563987626051;
 Wed, 24 Jul 2019 10:00:26 -0700 (PDT)
Date:   Wed, 24 Jul 2019 10:00:13 -0700
In-Reply-To: <20190724170018.96659-1-sdf@google.com>
Message-Id: <20190724170018.96659-3-sdf@google.com>
Mime-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 2/7] bpf/flow_dissector: document flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe what each input flag does and who uses it.

Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/prog_flow_dissector.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
index ed343abe541e..0f3f380b2ce4 100644
--- a/Documentation/bpf/prog_flow_dissector.rst
+++ b/Documentation/bpf/prog_flow_dissector.rst
@@ -26,6 +26,7 @@ and output arguments.
   * ``nhoff`` - initial offset of the networking header
   * ``thoff`` - initial offset of the transport header, initialized to nhoff
   * ``n_proto`` - L3 protocol type, parsed out of L2 header
+  * ``flags`` - optional flags
 
 Flow dissector BPF program should fill out the rest of the ``struct
 bpf_flow_keys`` fields. Input arguments ``nhoff/thoff/n_proto`` should be
@@ -101,6 +102,23 @@ can be called for both cases and would have to be written carefully to
 handle both cases.
 
 
+Flags
+=====
+
+``flow_keys->flags`` might contain optional input flags that work as follows:
+
+* ``FLOW_DISSECTOR_F_PARSE_1ST_FRAG`` - tells BPF flow dissector to continue
+  parsing first fragment; the default expected behavior is that flow dissector
+  returns as soon as it finds out that the packet is fragmented;
+  used by ``eth_get_headlen`` to estimate length of all headers for GRO.
+* ``FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL`` - tells BPF flow dissector to stop
+  parsing as soon as it reaches IPv6 flow label; used by ``___skb_get_hash``
+  and ``__skb_get_hash_symmetric`` to get flow hash.
+* ``FLOW_DISSECTOR_F_STOP_AT_ENCAP`` - tells BPF flow dissector to stop
+  parsing as soon as it reaches encapsulated headers; used by routing
+  infrastructure.
+
+
 Reference Implementation
 ========================
 
-- 
2.22.0.657.g960e92d24f-goog

