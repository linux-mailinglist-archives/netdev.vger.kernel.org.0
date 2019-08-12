Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98748A92E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfHLVUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:20:17 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33072 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfHLVUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:20:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id v38so11965970qtb.0
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linode-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=DQ4mMXTZgl1WVV5uHkxStemoDQNoVfeoGM36kj7uXFo=;
        b=IudWYI67/pUsUBXltWcn/CyTVN0ZBzPivh9m8rJK910Q8dqV4hiUTW+a76lIMzvxtp
         3kWu0rLwqT71P5syq6yOutngz+UBjbx4sRjfs/g6BjVldJtz73U5eK91Zh4RHXWRA8lO
         CMy3vwVqtGQ2S0f01rO488qJ3BevZeLqjg2KlaC5ZixekRE4kkKSQYLscDLvaKFqUbar
         SzFTNjbMfRuIP/aetd1hcs/MGna04omLLslGArlXoNVPM8mnLSKRDzoDtEO7ZMzU/zQJ
         yFQfUdYmifAnWTdtaj3F4moa0wmwM0YJNrrnfu0RJ/mll0M86zMKpsKZtrV95z2LL87a
         7K1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=DQ4mMXTZgl1WVV5uHkxStemoDQNoVfeoGM36kj7uXFo=;
        b=Bv6V3ipFe7UUMr4KIZ+cjDnL5GHmMrILtUq9ABCBrbkRMY40L/ngBPPWQVLkfwoNzy
         50uSVOvOa2NGYgmkbh8H0YzTL2D2llrCNo49cwzlbswFnsCOAEn5lULdcTOYY3OUO9Q9
         CTz6QfsimFQDxzsljb7LpwExB1ZoeOAzLMo5YFVpyMrXznka2OhB5oejBTal6oYY8fZY
         Fi/qFXnOhOl5edc/X+EVn2a+jfWUBD2wvr1WzOOuzi09y15OVMCDUKioTKS6BnOrsuC5
         Jdos5tMXgFbCM5mLAIppiDEcPPufn4A4ZPyKiEc0DIddZvN8UQyroIA6SZDQZaevLR25
         ncSg==
X-Gm-Message-State: APjAAAVU6qMcxqomCUPwS14onfnVHsWyvQpv2r360hLMnbR5W767sEeO
        ODGkP9ef7zyv7Af0ashLaWFYzomO2A3IQRdI1zd7aeF3dr44yXMD0+OvsZ2g4SwU0Xc1aJPESzK
        2rt/4TOXznWYwUzKaLLkCx8jsxQwttIxW3WAxe6PlIUfW/h7QOn8/VpJoexH6BC1AZsEsAJ4=
X-Google-Smtp-Source: APXvYqzQg1EVwkwsAsGkkXLFYR558dkrZLzS5slAy0MGKmAYlex62608UxTWNPThyWL0DheAA4d1DQ==
X-Received: by 2002:ad4:438c:: with SMTP id s12mr9433165qvr.17.1565644815541;
        Mon, 12 Aug 2019 14:20:15 -0700 (PDT)
Received: from Todds-MacBook-Pro.local ([172.104.2.4])
        by smtp.gmail.com with ESMTPSA id p38sm6226254qtc.76.2019.08.12.14.20.14
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:20:14 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   Todd Seidelmann <tseidelmann@linode.com>
Subject: [PATCH net] netfilter: ebtables: Fix argument order to ADD_COUNTER
Message-ID: <00a6c489-dc5b-d66f-f06d-b8785acb50e7@linode.com>
Date:   Mon, 12 Aug 2019 17:20:13 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ordering of arguments to the x_tables ADD_COUNTER macro
appears to be wrong in ebtables (cf. ip_tables.c, ip6_tables.c,
and arp_tables.c).

This causes data corruption in the ebtables userspace tools
because they get incorrect packet & byte counts from the kernel.
---
  net/bridge/netfilter/ebtables.c | 8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c 
b/net/bridge/netfilter/ebtables.c
index c8177a8..4096d8a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -221,7 +221,7 @@ unsigned int ebt_do_table(struct sk_buff *skb,
              return NF_DROP;
          }

-        ADD_COUNTER(*(counter_base + i), 1, skb->len);
+        ADD_COUNTER(*(counter_base + i), skb->len, 1);

          /* these should only watch: not modify, nor tell us
           * what to do with the packet
@@ -959,8 +959,8 @@ static void get_counters(const struct ebt_counter 
*oldcounters,
              continue;
          counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
          for (i = 0; i < nentries; i++)
-            ADD_COUNTER(counters[i], counter_base[i].pcnt,
-                    counter_base[i].bcnt);
+            ADD_COUNTER(counters[i], counter_base[i].bcnt,
+                    counter_base[i].pcnt);
      }
  }

@@ -1280,7 +1280,7 @@ static int do_update_counters(struct net *net, 
const char *name,

      /* we add to the counters of the first cpu */
      for (i = 0; i < num_counters; i++)
-        ADD_COUNTER(t->private->counters[i], tmp[i].pcnt, tmp[i].bcnt);
+        ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);

      write_unlock_bh(&t->lock);
      ret = 0;
--
1.8.3.1

