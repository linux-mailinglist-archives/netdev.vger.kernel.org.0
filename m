Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111DFDBCB2
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbfJRFKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:10:10 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:43956 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfJRFKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:10:10 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2019 01:10:10 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 1D6C4CBE
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 04:53:12 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Wr_lib7aLP4E for <netdev@vger.kernel.org>;
        Thu, 17 Oct 2019 23:53:12 -0500 (CDT)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id EB8C3CBC
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 23:53:11 -0500 (CDT)
Received: by mail-io1-f72.google.com with SMTP id w8so6927895iod.21
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 21:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PiAvGPBAd5r/3XyVj4aUHP7AUeXoHl9s9vGj/rL2vBE=;
        b=SSAw+mF6f+5B+nirGSGu/AIgxkBVez4C2mLwuOn2tdvSW6D2qgygO+CJhg/4C5A4UY
         xWLJlB3gN5EseI5nGlOxXzBh17l243fYEsLjpBwMlbcyftv/av5pE+ARJqX4V6h3fEVb
         apUsF/OH+V+/oXLedtF3gnfl3I+r5VDk4FJpUI4VC2joMHaMKxpbl+T4BOTeZ1qvYq3J
         9sgaWLiyFSDyQPKt8y46jMtH/uo8saK+v/LqHHNuPDs3YPlY8kVkUpk3MQfwTOR5HcIa
         Tx4igdKciSEATWOcEVUnHHCFtyOgsKlDcT64tagQdJdLbSr4LvX88ddY8tEER3peRXg/
         7pGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PiAvGPBAd5r/3XyVj4aUHP7AUeXoHl9s9vGj/rL2vBE=;
        b=orGdO1vWLBIj00w8n5ItgIIlkDOMkFdy+VB+n6xLBPT9bdzzTdCU7BbzsSflAvJhPg
         rnglaZLsAO6KlyicbSVpbwe2w7fuAuFc7wVYO/FdcXMJAOP4cv9OQmMC6iBDMPvQ8Q36
         ZNgp2ZSuLCIQUFJRW8AP01OzUKFHRGuYbFSS5sXvZw3xlR1/fakV9FM8ZTQPOHNEfS1l
         qSKj6Sawv7yfn85vy1N+x1LyN0SCIKkId3bDlnmdwtBmTqgo5mE6UAxsfT8UnRABGFae
         gGw4MpkEOpL8OvTYRhpkXG+A621MXhG0aF8dsRM3AXGC8n5gnW5tCm2xfi3BHPGxQlfj
         IdGw==
X-Gm-Message-State: APjAAAXz6Qlr6OSRmKnsaSaoZGJXST+RK/pEnsnyBdAh7DKtwBgo5eHv
        XWZ3QPyEG7JFDAtnMbb2aUXztqJ1e6BtlFkrQH2AIZHKW8TrwjJwYs7D1FBlikslqKjfC3xEiK/
        Bz5/jZwfTgm4PNJhUcdIu
X-Received: by 2002:a92:48cf:: with SMTP id j76mr7837583ilg.246.1571374391564;
        Thu, 17 Oct 2019 21:53:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyC/JNn6/bb1kk/U+cLwblGbXmpbY/tAAsujMTaZdpNNs4/lNdEfWgzh72OP1sSvTEK7SUrdw==
X-Received: by 2002:a92:48cf:: with SMTP id j76mr7837569ilg.246.1571374391314;
        Thu, 17 Oct 2019 21:53:11 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id 197sm1639719ioc.78.2019.10.17.21.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:53:10 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/lib80211: scrubbing the buffer for key
Date:   Thu, 17 Oct 2019 23:53:05 -0500
Message-Id: <20191018045305.8108-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "key" is not scrubbed. As what peer modules do, the fixes zeros
out the key buffer.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 net/wireless/lib80211_crypt_wep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index dafc6f3571db..08e511aaa1ff 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -202,6 +202,7 @@ static int lib80211_wep_set_key(void *key, int len, u8 * seq, void *priv)
 	if (len < 0 || len > WEP_KEY_LEN)
 		return -1;
 
+	memset(wep, 0, sizeof(*wep));
 	memcpy(wep->key, key, len);
 	wep->key_len = len;
 
-- 
2.17.1

