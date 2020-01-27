Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDB314A659
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgA0Okp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:40:45 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46012 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgA0Okp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:40:45 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so5238845pgk.12
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 06:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fXg3+U8k2zRsXD1EX+5izCO/mwJzePEvDGDPeAEiSJY=;
        b=lIeLn9ttr6SfKGpLR3C45tbct3Hze+t/BH9CSAFns4Wuuq4m1u7xrIENsMz5olcvn9
         8gw/J5e5e+DT1Oi6gN+eUCkug5xXL1m12TutDnl/gXIvCH4MkL9oeLKUErSIdeA3lrxn
         2wG2G1JHLtYSI/iDdxZXCwUG7CuvocSqP0yQUap4sksxcBs6MO+HZrcYuvKxNANHEStA
         yFit2F5KmWjJ2Yo0fwMbHXzYuOwcOke0/MCKivO18iDDIKD/4d/RdRe7XQhBqd56lx4E
         Eb0IV0LGKaVw9x2xbk6Q4x7rHyjt1Ca9gi+XFp77Homj5tgKpiqJrSm1r0LAYI5m0qfd
         evUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fXg3+U8k2zRsXD1EX+5izCO/mwJzePEvDGDPeAEiSJY=;
        b=BC5+Q9Bk4+nEXVMLyH2/dt7jP5bSac3wLcnuLuI0MKQ+KRHb0P6oopX5VL9UWVX7CT
         p+pscMgUz1W/WMKP8zHnJAcMXWAiRLJ5mCi9/hkKRpx7jMLAp2HDEXcJUxghjHKsi84o
         wJ1GwNGPGeA17dWZaZGoovCBaPH6pl52yQ/xrGnjGqAXggsChAPM6nfHZ7pxzMCMPq06
         Yb6ZK6WUwrL3S/1yFzQoWDHbFhejk2HvsroTmGlYm2xVx84ym4jWGxGClT7uNxIB4tr7
         4w12ZMBubdibpd0g4Rb039VDVio1+E/D/6gfTjm+FwgktEfyQhuxNQWHZhGz+WPpytdo
         K8mw==
X-Gm-Message-State: APjAAAWkAOK8iI1JKmWdYx0sp1SNOEmMTOgQbospUVFGspSrmKBBP1kj
        05nMG8il3hr12h9cHYvevmNU8EBJ1+Q=
X-Google-Smtp-Source: APXvYqzXcX5Y0ATnHPtHD/C95yzJIYZcpgaHu+C9RiPpiedEhPhJp35AfdVVIzNEcw1AAteapPf4Hg==
X-Received: by 2002:aa7:85d9:: with SMTP id z25mr16753099pfn.223.1580136044761;
        Mon, 27 Jan 2020 06:40:44 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z5sm17084300pfq.3.2020.01.27.06.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 06:40:43 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] netem: change mailing list
Date:   Mon, 27 Jan 2020 06:40:36 -0800
Message-Id: <20200127144036.7395-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old netem mailing list was inactive and recently was targeted by
spammers. Switch to just using netdev mailing list which is where all
the real change happens.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 56765f542244..a052af56d72c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11387,7 +11387,7 @@ F:	Documentation/networking/net_failover.rst
 
 NETEM NETWORK EMULATOR
 M:	Stephen Hemminger <stephen@networkplumber.org>
-L:	netem@lists.linux-foundation.org (moderated for non-subscribers)
+L:	netdev@vger.kernel.org
 S:	Maintained
 F:	net/sched/sch_netem.c
 
-- 
2.20.1

