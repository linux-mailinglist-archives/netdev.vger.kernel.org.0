Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BBE2C74EF
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbgK1Vtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbgK0Tuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 14:50:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606506615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=D0OEsjTfxMqFMhB+/LyY+jMVTgPWufB5Fsh8HmQS8Ic=;
        b=XzQPv35NwJH5uUAut8rXe0DviCj9ZojNyswmynRXd7KR74KUDXVgLN1yFZDxEk9zcTebiF
        AFr4dB5UL/b03KxQbjdiQul73EvSZjxrcTO4GAxpSPsz53LfkMkIC9IUoW1SCKyhPoEFRm
        C1a09Ot/MzcXZcJmKVB35wA+2vpYz2Y=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-ymt6T9xFPDyD2DWtEYHr4A-1; Fri, 27 Nov 2020 14:37:34 -0500
X-MC-Unique: ymt6T9xFPDyD2DWtEYHr4A-1
Received: by mail-qv1-f69.google.com with SMTP id c35so3019254qva.3
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 11:37:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D0OEsjTfxMqFMhB+/LyY+jMVTgPWufB5Fsh8HmQS8Ic=;
        b=DOkKDxd2uF2+Uqx7PPIUW2hOYWiuJbg3zocRj4zAVYFvnPPguL622KMXGY/lQleSTV
         vTw+yOOStbcXbGkHSGZ9CFAtnGuRu2Ampuy4MPhcH/IkiN9Nrogo5WXVxvn5ADJLWwG0
         weS5sbcuUNtI9BIHn8lgmKrUtNT9xm2T48KUxTOf2S7F9TLmjq/Cnw1/+fH8/U9D2JY/
         9bV2CwKQsU1+k7a6BjU1IkBjyCBG4UF79O4XhZs26BOgUE9E6S5z1R1x80KvpnH/8nU7
         XQ7Y/SILwG4ReiDvWvQHvOoQ1r49JkiUi3/TA1JcLAby1BNclgE7dWDYPi4rikZWY9tc
         H/AQ==
X-Gm-Message-State: AOAM533hy+BayGVZlxMDgvchIbe59WKHYHqzy/N1/MlED1cKbNSEywOf
        Z5AER0PYwf9A2HogYGrOKR/woFge9/oDGF9PDBNQzrkPWR0UQFI9QF6EXPlnzy9VO9stzpoNWV4
        T1kxWiNqi5KuJ8x5K
X-Received: by 2002:a05:620a:11a4:: with SMTP id c4mr10274489qkk.8.1606505853160;
        Fri, 27 Nov 2020 11:37:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6uM7SBGwqmsudiKO/+tm/yXrc9q7QmiVxYTb6LM/G0g5REpKZV4lvXkCCThByWIkgggqM3g==
X-Received: by 2002:a05:620a:11a4:: with SMTP id c4mr10274470qkk.8.1606505852952;
        Fri, 27 Nov 2020 11:37:32 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q7sm6821053qkb.22.2020.11.27.11.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:37:32 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, wenxu@ucloud.cn,
        pablo@netfilter.org, jiri@mellanox.com,
        herbert@gondor.apana.org.au, paulb@mellanox.com,
        john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: flow_offload: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 11:37:27 -0800
Message-Id: <20201127193727.2875003-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/core/flow_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index d4474c812b64..59ddfd3f3876 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -32,7 +32,7 @@ EXPORT_SYMBOL(flow_rule_alloc);
 	struct flow_dissector *__d = (__m)->dissector;				\
 										\
 	(__out)->key = skb_flow_dissector_target(__d, __type, (__m)->key);	\
-	(__out)->mask = skb_flow_dissector_target(__d, __type, (__m)->mask);	\
+	(__out)->mask = skb_flow_dissector_target(__d, __type, (__m)->mask)	\
 
 void flow_rule_match_meta(const struct flow_rule *rule,
 			  struct flow_match_meta *out)
-- 
2.18.4

