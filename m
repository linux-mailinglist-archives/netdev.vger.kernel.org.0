Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3052F339A59
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 01:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhCMAMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 19:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbhCMAM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 19:12:28 -0500
X-Greylist: delayed 477 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 Mar 2021 16:12:28 PST
Received: from mx-rz-3.rrze.uni-erlangen.de (mx-rz-3.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C5EC061574;
        Fri, 12 Mar 2021 16:12:28 -0800 (PST)
Received: from mx-rz-smart.rrze.uni-erlangen.de (mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mx-rz-3.rrze.uni-erlangen.de (Postfix) with ESMTPS id 4Dy2wq1kk2z1yt7;
        Sat, 13 Mar 2021 01:04:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fau.de; s=fau-2013;
        t=1615593867; bh=tiGbR5+qvcpdxRonVzk7L9PAmwGj3wphduFp/u6WEp4=;
        h=From:To:Cc:Subject:Date:From:To:CC:Subject;
        b=ieACjZTFOTsl6iO5+6niaLUHxy4CirypW+vNOB1zlAtHQvVrnXP3i/7aQ0/ViNQnP
         1nKDdxFmJBjqrbJt7gJ7TLpyAN23NZYYEGtDw6ygVDhVUeYdvcOm1a4T++a2Xb2KLI
         f8w7up4CIiQP6ioBtl5PNCpevT0Dw6LKMwFPYZDQnQhagvoQ5Y8kTokNuHhBcLkz/a
         +IpyGGWTne0vlqfHl1fndopxkgp7/r8Dj+NtJqLwdEVzOuQhOvCcSOpdYXdPLP4qR+
         wfnEPT6rpse2pciZIIG/lqDLaSNgbmlxgmMAuR89nux03t4yX3rydy16ZoIVQr2K+h
         tuXPYBHNsuTbw==
X-Virus-Scanned: amavisd-new at boeck2.rrze.uni-erlangen.de (RRZE)
X-RRZE-Flag: Not-Spam
X-RRZE-Submit-IP: 2003:ca:a71f:a300:732f:3ac2:88f:1036
Received: from ruediger.fritz.box (p200300caa71fa300732f3ac2088f1036.dip0.t-ipconnect.de [IPv6:2003:ca:a71f:a300:732f:3ac2:88f:1036])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: U2FsdGVkX19P3QusNdvRDN2n6xXjFJrDEC7jJHp69BM=)
        by smtp-auth.uni-erlangen.de (Postfix) with ESMTPSA id 4Dy2wh5vCfz1y8r;
        Sat, 13 Mar 2021 01:04:20 +0100 (CET)
From:   Eva Dengler <eva.dengler@fau.de>
To:     linux-doc@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Eva Dengler <eva.dengler@fau.de>
Subject: [PATCH] devlink: fix typo in documentation
Date:   Sat, 13 Mar 2021 01:04:13 +0100
Message-Id: <20210313000413.138212-1-eva.dengler@fau.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes three spelling typos in devlink-dpipe.rst and
devlink-port.rst.

Signed-off-by: Eva Dengler <eva.dengler@fau.de>
---
 Documentation/networking/devlink/devlink-dpipe.rst | 2 +-
 Documentation/networking/devlink/devlink-port.rst  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-dpipe.rst b/Documentation/networking/devlink/devlink-dpipe.rst
index 468fe1001b74..af37f250df43 100644
--- a/Documentation/networking/devlink/devlink-dpipe.rst
+++ b/Documentation/networking/devlink/devlink-dpipe.rst
@@ -52,7 +52,7 @@ purposes as a standard complementary tool. The system's view from
 ``devlink-dpipe`` should change according to the changes done by the
 standard configuration tools.
 
-For example, it’s quiet common to  implement Access Control Lists (ACL)
+For example, it’s quite common to  implement Access Control Lists (ACL)
 using Ternary Content Addressable Memory (TCAM). The TCAM memory can be
 divided into TCAM regions. Complex TC filters can have multiple rules with
 different priorities and different lookup keys. On the other hand hardware
diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index e99b41599465..ab790e7980b8 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -151,7 +151,7 @@ representor netdevice.
 -------------
 A subfunction devlink port is created but it is not active yet. That means the
 entities are created on devlink side, the e-switch port representor is created,
-but the subfunction device itself it not created. A user might use e-switch port
+but the subfunction device itself is not created. A user might use e-switch port
 representor to do settings, putting it into bridge, adding TC rules, etc. A user
 might as well configure the hardware address (such as MAC address) of the
 subfunction while subfunction is inactive.
@@ -173,7 +173,7 @@ Terms and Definitions
    * - Term
      - Definitions
    * - ``PCI device``
-     - A physical PCI device having one or more PCI bus consists of one or
+     - A physical PCI device having one or more PCI buses consists of one or
        more PCI controllers.
    * - ``PCI controller``
      -  A controller consists of potentially multiple physical functions,
-- 
2.26.2

