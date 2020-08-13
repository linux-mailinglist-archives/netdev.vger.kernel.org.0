Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DE724337D
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 07:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgHMFK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 01:10:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52650 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgHMFK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 01:10:28 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <nivedita.singhvi@canonical.com>)
        id 1k65VS-0002ur-C4
        for netdev@vger.kernel.org; Thu, 13 Aug 2020 05:10:26 +0000
Received: by mail-pf1-f197.google.com with SMTP id d3so3518792pfh.17
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 22:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=n1UMW/XwDLCk0bTP2LRk7gihRWL3dL8wbI1eH8bwwTE=;
        b=I2I4ceIfse2AyZUjp8d5k/6IWfGQKySIoQB9WLhGFSTdJxJ01kXIEeR+Txw/j9G6BX
         vN/lQrGQfh6YzMbfXYVG6+p6BqaPGRH4ik2pbDMOk/+4lNUB6lW+FRvUW4A29EZRiUy1
         L8yb0dOJAjI5hKHIecJC1FIjdCqNH2h3yaWyU1RcoLQwbSrptzWvSB+BofhjSlpy4+ne
         pfJzRaB0W0VXoCxsiq4LXZTi1RcmWZNMGWUTAw5wg9nD0a43d7IeLDeS291JR/rJT3q+
         SmbTfEH0wVhIf1JbIwO9WehKibGoYsOZe03xpbXamAJngCBEm34SDNfdDVJWZCwgFjD2
         Si1Q==
X-Gm-Message-State: AOAM5324JOklIY51RX7Q0TmQ8tgOOc+VEBe+GAJjN0QTLJ+p2ztv7jhu
        7WoWXTQcJCtTgvH9FR0eIu7aZJJai5Fqp24li62ym6wSzMzrP1Tkpu4qw18NbQPzKopomjw0p4y
        n1BFOxG0Dpyb9nlJifxw8+7akV2a2A9WwWA==
X-Received: by 2002:a62:2e03:: with SMTP id u3mr2793718pfu.310.1597295424790;
        Wed, 12 Aug 2020 22:10:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRgbhVhVW0oA2xtZDicWuCp+h+MmgANy4IGDijt1+yB0TkMwdHokkl5gjlEyzOMb1Xc4Z1dg==
X-Received: by 2002:a62:2e03:: with SMTP id u3mr2793709pfu.310.1597295424481;
        Wed, 12 Aug 2020 22:10:24 -0700 (PDT)
Received: from localhost.localdomain ([2409:4042:2183:78e8:59e0:daa0:8f96:a8b8])
        by smtp.gmail.com with ESMTPSA id a17sm4195843pfk.29.2020.08.12.22.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 22:10:23 -0700 (PDT)
From:   Nivedita Singhvi <nivedita.singhvi@canonical.com>
To:     netdev@vger.kernel.org, jay.vosburgh@canonical.com,
        davem@davemloft.net
Subject: [PATCH] docs: networking: bonding.rst resources section cleanup 
Date:   Thu, 13 Aug 2020 10:40:05 +0530
Message-Id: <20200813051005.6450-1-nivedita.singhvi@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed obsolete resources from bonding.rst doc:
   - bonding-devel@lists.sourceforge.net hasn't been used since 2008
   - admin interface is 404
   - Donald Becker's domain/content no longer online

Signed-off-by: Nivedita Singhvi <nivedita.singhvi@canonical.com>
---
 Documentation/networking/bonding.rst | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 24168b0d16bd..adc314639085 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -2860,17 +2860,6 @@ version of the linux kernel, found on http://kernel.org
 The latest version of this document can be found in the latest kernel
 source (named Documentation/networking/bonding.rst).
 
-Discussions regarding the usage of the bonding driver take place on the
-bonding-devel mailing list, hosted at sourceforge.net. If you have questions or
-problems, post them to the list.  The list address is:
-
-bonding-devel@lists.sourceforge.net
-
-The administrative interface (to subscribe or unsubscribe) can
-be found at:
-
-https://lists.sourceforge.net/lists/listinfo/bonding-devel
-
 Discussions regarding the development of the bonding driver take place
 on the main Linux network mailing list, hosted at vger.kernel.org. The list
 address is:
@@ -2881,10 +2870,3 @@ The administrative interface (to subscribe or unsubscribe) can
 be found at:
 
 http://vger.kernel.org/vger-lists.html#netdev
-
-Donald Becker's Ethernet Drivers and diag programs may be found at :
-
- - http://web.archive.org/web/%2E/http://www.scyld.com/network/
-
-You will also find a lot of information regarding Ethernet, NWay, MII,
-etc. at www.scyld.com.
-- 
2.17.1

