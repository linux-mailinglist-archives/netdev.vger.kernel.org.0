Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02041CE780
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEKVeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725895AbgEKVeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:34:10 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD37C061A0C;
        Mon, 11 May 2020 14:34:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x77so5341898pfc.0;
        Mon, 11 May 2020 14:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXCysljLfLXX410q/6YrEuNh3qGEuRfM8YNbcTjsua4=;
        b=nWzNmvBU+sA+7DdNALZrh5mspbr0Y5vKHKodfOkPjLrdOUvb8TKOOIGckyMqbCMyrO
         k3mWuzrYolK+27+wfsTRBsqu9ScekAzpyFgQgPZMyrHHvg0PZ+Z71cLSEvKlvRfVh3wM
         ItqbcjlKJdconjzhlVEf2RMO2EpIno4jxSF5la8iZNIfcTO14gpgkkzPDKDaQEQHcPYX
         b+r0nCDXYqa11fq08hyECPwsGE06+u4+mUwOwITDJQoFwbHAqXbZkLkh8wMAIoBYI9fE
         EtcEm0awMOaiIcsvhnhNFTsBPctKZZ9RGTSO1Wu6yxSfOSKoGrzpRZ0oV1v+khXK0eFG
         vnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXCysljLfLXX410q/6YrEuNh3qGEuRfM8YNbcTjsua4=;
        b=gy6XMsZJ7J5xPkpJvr1Sah1bVHI7o6ffeCqPT8YoNuupdtgQxNSQIgHDMy25FzM9Ng
         umFhYevW9WVS0wNq4Z4ZZ5aEEctHpEEZzOpb01DtiEYkdhapXpzylGt22NSiTSN0CNw+
         +aZc3zdbRz1eCexx3+DeOLQHQFEqMBXWIKPagRqpgNzPubgXDVw8wHUHPERsdsyM9Pw7
         fmroQPBssc4/jUKQHg8EP/EVbXcHYKBzPfBnOxflGOL9U2YmIFkytG68Y0nVeG/ZePQo
         A56eT/iBSun31jGc+gG+GKg/xaboAUFFXU7CaT2EEbBtl/0oNUliEL1UQskoSC+4qRw7
         EnvA==
X-Gm-Message-State: AGi0PubhW+iECLoOmDgdob7NmQM0v5oLQ67azZsy7uWeK5NN3I20zpV/
        zJe+NlKNttSScTgfyY/SK0zAFqc0
X-Google-Smtp-Source: APiQypJx4fWNNQJzXlqv7c4r75k2Ax5UXOPYZb0usCL1VF0QvKCgVSNIQDCxzpa2PtgLqoVlqsV85w==
X-Received: by 2002:a63:1a01:: with SMTP id a1mr15493278pga.87.1589232849175;
        Mon, 11 May 2020 14:34:09 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id f6sm10340071pfd.175.2020.05.11.14.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 14:34:08 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] libiptc.c: pragma disable a gcc compiler warning
Date:   Mon, 11 May 2020 14:34:04 -0700
Message-Id: <20200511213404.248715-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Fixes:
  In file included from libip4tc.c:113:
  In function ‘iptcc_compile_chain’,
      inlined from ‘iptcc_compile_table’ at libiptc.c:1246:13,
      inlined from ‘iptc_commit’ at libiptc.c:2575:8,
      inlined from ‘iptc_commit’ at libiptc.c:2513:1:
  libiptc.c:1172:2: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
   1172 |  memcpy(&foot->e.counters, &c->counters, sizeof(STRUCT_COUNTERS));
        |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  In file included from ../include/libiptc/libiptc.h:12,
                   from libip4tc.c:29:
  libiptc.c: In function ‘iptc_commit’:
  ../include/linux/netfilter_ipv4/ip_tables.h:202:19: note: at offset 0 to object ‘entries’ with size 0 declared here
    202 |  struct ipt_entry entries[0];
        |                   ^~~~~~~

Which was found via compilation on Fedora 32.

Test: builds without warnings
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 libiptc/libiptc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 58882015..1a92b267 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1169,7 +1169,10 @@ static int iptcc_compile_chain(struct xtc_handle *h, STRUCT_REPLACE *repl, struc
 	else
 		foot->target.verdict = RETURN;
 	/* set policy-counters */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wstringop-overflow"
 	memcpy(&foot->e.counters, &c->counters, sizeof(STRUCT_COUNTERS));
+#pragma GCC diagnostic pop
 
 	return 0;
 }
-- 
2.26.2.645.ge9eca65c58-goog

