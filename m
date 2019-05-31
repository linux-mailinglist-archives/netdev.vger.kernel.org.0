Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25ABB31660
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfEaVFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:05:09 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:34639 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfEaVFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:05:09 -0400
Received: by mail-qt1-f201.google.com with SMTP id z8so1702941qti.1
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 14:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dNH5zkKuleD3tHY+iFrQBbXdXFT5hhDtxuQjuMEMixE=;
        b=hGXjCUb+rtdL8B0NZKWQycM+iIrbJ92auX+aPSsWuO91FWk4LHBcQniHiZA88Kl0ZM
         choHKERwnLCozcl+YDwrHkxLrV7ilR7JNUDNlUO5jd8Il2jzqLBalLSdY/CTj1M91v95
         4G7m7b09+VCDipHRgO3BHUSAFkzy+cHLdPU0mNmooYsEyfV/YauqDhfkrpW63DJziiK4
         EdnjhemK40LL0xSnQ75mYMBcR9Bgh69TyzfX/w6Q6k1Pvg/RH9wqV5g8u7pcP4OKUiZn
         4gIcsCZF4grw9UZbb1+coF2m9ezQWggd5YlP95QFPmLKsntTDLQKkdQgdOZYqq53iasj
         c6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dNH5zkKuleD3tHY+iFrQBbXdXFT5hhDtxuQjuMEMixE=;
        b=B/w/wt95B/SR6Bgf6AsiUezb5Ziz/8dQOcivfGSnYA9zSg5U6BS4GtHtvZtGnqwl8f
         rrRDS0mjiaY7F/Omc4DXFat8IZOb1zFfsVHEpuAX6TWvl8IQaI6YpLRghLfJw0lwTpIg
         fYUPHjdPhSOOoOsiVcvr0Agsz39BJi34qFTFVyZs7IGmCmn+znKRUBsGDy5B/7GzNxRp
         Kr0FkE06LzO0YChoCRTYul3iBXY1CguCOvQy/112jVs+T3iA/HcksR8vgx9czQhl3xVH
         61pC+9XBYQR5HAEIhSm7YlFL+4HY7c0aMIP15pQsSmaQg34hvc30qHiAIHwIc6kx23zc
         Tj/Q==
X-Gm-Message-State: APjAAAVfeip7iEwtdcdvRRw+ZM6qbiHT8K5BG0g/HkDhsEopsZw4YnKx
        4Teqqa5Jwv6/c7oBaKLLakG4g38BckDn6NIngVM/TtgT0hqoLJ1As+CHOqWfnU/UydYLJL13SIL
        ZpwnzrF4pt400171wcbwvImGiWE4HdG1I9RMNoq6h+ZMUoWoZ9mS8bg==
X-Google-Smtp-Source: APXvYqy6Zx1IDuZUelnU33WTmHSQuN/2MIsDeBIRyrto8xFX4taefYFYyq4iDEN0Tq8KBLLvV8ribbk=
X-Received: by 2002:ac8:28dd:: with SMTP id j29mr11525086qtj.34.1559336708418;
 Fri, 31 May 2019 14:05:08 -0700 (PDT)
Date:   Fri, 31 May 2019 14:05:06 -0700
Message-Id: <20190531210506.55260-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next] flow_dissector: remove unused FLOW_DISSECTOR_F_STOP_AT_L3
 flag
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This flag is not used by any caller, remove it.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/flow_dissector.h |  5 ++---
 net/core/flow_dissector.c    | 10 +---------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 7c5a8d9a8d2a..797e19c2fc40 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -229,9 +229,8 @@ enum flow_dissector_key_id {
 };
 
 #define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		BIT(0)
-#define FLOW_DISSECTOR_F_STOP_AT_L3		BIT(1)
-#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	BIT(2)
-#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		BIT(3)
+#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	BIT(1)
+#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		BIT(2)
 
 struct flow_dissector_key {
 	enum flow_dissector_key_id key_id;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index edd622956083..c0559af9e5e5 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -757,7 +757,7 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
  * @nhoff: network header offset, if @data is NULL use skb_network_offset(skb)
  * @hlen: packet header length, if @data is NULL use skb_headlen(skb)
  * @flags: flags that control the dissection process, e.g.
- *         FLOW_DISSECTOR_F_STOP_AT_L3.
+ *         FLOW_DISSECTOR_F_STOP_AT_ENCAP.
  *
  * The function will try to retrieve individual keys into target specified
  * by flow_dissector from either the skbuff or a raw buffer specified by the
@@ -922,11 +922,6 @@ bool __skb_flow_dissect(const struct net *net,
 		__skb_flow_dissect_ipv4(skb, flow_dissector,
 					target_container, data, iph);
 
-		if (flags & FLOW_DISSECTOR_F_STOP_AT_L3) {
-			fdret = FLOW_DISSECT_RET_OUT_GOOD;
-			break;
-		}
-
 		break;
 	}
 	case htons(ETH_P_IPV6): {
@@ -975,9 +970,6 @@ bool __skb_flow_dissect(const struct net *net,
 		__skb_flow_dissect_ipv6(skb, flow_dissector,
 					target_container, data, iph);
 
-		if (flags & FLOW_DISSECTOR_F_STOP_AT_L3)
-			fdret = FLOW_DISSECT_RET_OUT_GOOD;
-
 		break;
 	}
 	case htons(ETH_P_8021AD):
-- 
2.22.0.rc1.257.g3120a18244-goog

