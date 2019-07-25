Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290C275AF2
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 00:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfGYWwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 18:52:40 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:35894 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfGYWwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 18:52:40 -0400
Received: by mail-pf1-f201.google.com with SMTP id e20so31875275pfd.3
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 15:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yqXwkVRCVEANuJ47HJ+E6Vsq3E4n5B4/T1nK9NocYRQ=;
        b=vFWXwEJgfcYJW2Z2d2kcb92ptDT613MLhkWQQtVEV9XAcdSJ3qLuFaNrkdDkxNefhj
         r99ew5Ry+jiNnG0LqYp/+KKu2zOyx9NXSQDgk/hhVnBfhfdgO3cDMlvKsx27Y6vkiAzS
         jt/kho5moQTYELheBZyBmza7kUOHajk46P1sWGZtij1J2WHZN+ubOzgnoEWVDrZVwXP4
         CiSDMhanyKhuTgyv7eBxIxdF57urSItnBrv5JA2BH8VFvoXeiGgtQ5W3ImlaMeCLc+u2
         ECuxkL5rzUO+bM+xd08dFWiKMi1kwBsZsh4lbs4E9UAkmM7SnvTzyj2IrEVC6UWLZwWc
         dyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yqXwkVRCVEANuJ47HJ+E6Vsq3E4n5B4/T1nK9NocYRQ=;
        b=j4GYIJJFsLGFcvlUJwAR4VDhxzy03l9y42Cr4ICJbOTKrD3PKy/Wpg+2QYs+CYQk/e
         uNGSZNl9a6feWcHdR07R2xjRyDaLhY6GfPdB/NgrLfkak9TkeIdcEBIY00c0+tQdlxfy
         VxVtsreyAe7RCvXmvMhkix95Fa6D7WChgvcn4A0LKY7mBzckdOEN7xyzzYKKi/Yldpro
         2wSkTvZr68txabr76lk7MNsZHAKWsWcbhpwYhmLg78K1kx4J1yR1EhGnzegpGMKwhTXO
         PIhdCYo5Da4k2sJ/0IQ58FgN/EtHhvy9mFJOdFHpmlbrUEF+w7hpeQSfWlcgqMO1RSZn
         UL4g==
X-Gm-Message-State: APjAAAUkqz43kTD6gnYLe/yw8kG22PCvec5zRukXyMG8x8hL+AfJnPmF
        LFm9fgjNt6mLLYdCNKnT4Qk8ZAJI+CghkqTrSKpLCwOm4Nx8E7JzQvzjjl1RqDle9IEC1KG0ArW
        eq1QEKiV2em98dVI8srRsrSIVDRkUElaUIDMUq4jmWt5cJVvlpuW/UQ==
X-Google-Smtp-Source: APXvYqyIZReguwb8LDkNnn2uypGrrLWGu6eLxB+9ZkE346+t3Fny64svX5TyqmErlGRPhuEnCNfIEz8=
X-Received: by 2002:a63:505a:: with SMTP id q26mr86045668pgl.18.1564095159124;
 Thu, 25 Jul 2019 15:52:39 -0700 (PDT)
Date:   Thu, 25 Jul 2019 15:52:26 -0700
In-Reply-To: <20190725225231.195090-1-sdf@google.com>
Message-Id: <20190725225231.195090-3-sdf@google.com>
Mime-Version: 1.0
References: <20190725225231.195090-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next v3 2/7] bpf/flow_dissector: document flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe what each input flag does and who uses it.

Acked-by: Petar Penkov <ppenkov@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/prog_flow_dissector.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
index ed343abe541e..a78bf036cadd 100644
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
+* ``BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG`` - tells BPF flow dissector to
+  continue parsing first fragment; the default expected behavior is that
+  flow dissector returns as soon as it finds out that the packet is fragmented;
+  used by ``eth_get_headlen`` to estimate length of all headers for GRO.
+* ``BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL`` - tells BPF flow dissector to
+  stop parsing as soon as it reaches IPv6 flow label; used by
+  ``___skb_get_hash`` and ``__skb_get_hash_symmetric`` to get flow hash.
+* ``BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP`` - tells BPF flow dissector to stop
+  parsing as soon as it reaches encapsulated headers; used by routing
+  infrastructure.
+
+
 Reference Implementation
 ========================
 
-- 
2.22.0.709.g102302147b-goog

