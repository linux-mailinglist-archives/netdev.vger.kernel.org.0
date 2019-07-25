Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D90A752AF
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389088AbfGYPdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:33:52 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:51906 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389058AbfGYPdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:33:51 -0400
Received: by mail-pg1-f202.google.com with SMTP id n23so19087490pgf.18
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3XbTWLRwhAiceZDqvAg53SxI5TZhBv0wWnTV5f6ZWpg=;
        b=dt7Fyk8+3nkOtpq+ABH4X03prQxT2jVZTjXOu26LKAUorYfFXPUtf4Ga4R4An4+QjG
         nFEeh/gkSzoltiMGhEqQJU59mI9wBqex62CDWTPmY8lslLMqnhD2x1zQRbuZ22pFWjeM
         N5gipQVPdGvFEAQbEFbgt4KZ0xpzQcnhFNZr/GC8M960zYBoAIKayPZ66FI/KV9TzIDb
         7s7ayLv9rkUnQgUr36J5AclM/w83bawrgRsmGIr4te5UZrAE4vrToqnuKZES4WXTfwqm
         gjLRiC9gtNcCHaN14tnkR72BxE0zidXSBB5uEo2+DQpBMEpWn3m/wR5oAtyyKwK6Y1Lv
         kcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3XbTWLRwhAiceZDqvAg53SxI5TZhBv0wWnTV5f6ZWpg=;
        b=ii6Bt+vLOhOOkkyvA8sJnk6mBCIYrVZaGu7enGzKNr5VzCMOkFAISJuGS3LBjzPMuu
         xMRcB9Lvd/NMc6f1R8f0fXlMzOjrmtub0F0gMj8jBptu3MtXFV46PZKxXOysHyf1hsLp
         rl/2+759P59THkEF4BGpxii5P8sazIyepPMn2gBvde8V0e+BHUDvBEYmodq1gOpGzHOG
         cST3aHdsK4DUjKUJiNRd5xHBEqIQYsdLxT1czwkYiMZw1ntOkPsXBgNQdj5/5SiKPZtf
         hg+wj3TlFdTNZhtNSvZS1Z3B3eCZ/AJdkVyfFBe3RcRnUMxDlue5yUbsuRA/jwyRKRHL
         IYBg==
X-Gm-Message-State: APjAAAUbo9UGvNCyjMA0ogpdn5r7+Z2afUoZzISmrO4mZBcMU3ER6PWU
        MOveWnQo5AMqIsA+uhAfhPMJG2yTrJ/3gyxMkpjz5IrMshSXQk4IMuJpuPPcOO063fZSMOjYAFm
        rDz+8ExEkJ0zwhuhkavuzKz4PIKRvarWtazibml6LIVs4PkcxNIofWQ==
X-Google-Smtp-Source: APXvYqwLFBkyn38D1qFrEAeYPuAcbFMlbnSs7YTkekejpPm/cNmDJoNnuQp4f4Y9BUhti4M24n36n1c=
X-Received: by 2002:a65:6552:: with SMTP id a18mr77689946pgw.208.1564068829986;
 Thu, 25 Jul 2019 08:33:49 -0700 (PDT)
Date:   Thu, 25 Jul 2019 08:33:37 -0700
In-Reply-To: <20190725153342.3571-1-sdf@google.com>
Message-Id: <20190725153342.3571-3-sdf@google.com>
Mime-Version: 1.0
References: <20190725153342.3571-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next v2 2/7] bpf/flow_dissector: document flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe what each input flag does and who uses it.

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

