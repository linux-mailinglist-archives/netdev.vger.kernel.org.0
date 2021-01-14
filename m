Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41642F56AD
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbhANBu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727766AbhANBuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1127206C0;
        Thu, 14 Jan 2021 01:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610588968;
        bh=9KInFi5fXxIERSI2PINj/9fkEZrMhgJ/+LUafo/G4kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKAa6mSHHtSSwS7UfMr2S2/CcOTiNHkiKFFcF3sf3/gCzE3GgTeIfARFGYwqlh8Gg
         uqTntwg5I+UgL3lJ+QgAZHgUfz0mhS9JtwF43+xccUSZpdSpd0MYeN5Bhyjod5EVAL
         KhNCTPIzZJ0KVACowgePASz7wfkrA93lY3BfWAWpLyd9Q2GF3QpM//j94mj7AoSMF7
         9aIdiYGPGpmr8WpZPai/al0zfEtsCzwzSOwkole/VACZYOfb7wxV+XU6eAmePv2QqL
         2zGQVc19uY8L4D5QbpoZ1DV0PTAWZor4em9oSXMXX7KoY1xCH7yt0Af78/5dondUdb
         mJj1l7cDOIzdw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org
Subject: [PATCH net v2 7/7] MAINTAINERS: dccp: move Gerrit Renker to CREDITS
Date:   Wed, 13 Jan 2021 17:49:12 -0800
Message-Id: <20210114014912.2519931-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114014912.2519931-1-kuba@kernel.org>
References: <20210114014912.2519931-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As far as I can tell we haven't heard from Gerrit for roughly
5 years now. DCCP patch would really benefit from some review.
Gerrit was the last maintainer so mark this entry as orphaned.

Subsystem DCCP PROTOCOL
  Changes 38 / 166 (22%)
  (No activity)
  Top reviewers:
    [6]: kstewart@linuxfoundation.org
    [6]: allison@lohutok.net
    [5]: edumazet@google.com
  INACTIVE MAINTAINER Gerrit Renker <gerrit@erg.abdn.ac.uk>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Gerrit Renker <gerrit@erg.abdn.ac.uk>
CC: dccp@vger.kernel.org
---
 CREDITS     | 4 ++++
 MAINTAINERS | 3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index ce8eae8c5aa4..9add7e6a4fa0 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1288,6 +1288,10 @@ D: Major kbuild rework during the 2.5 cycle
 D: ISDN Maintainer
 S: USA
 
+N: Gerrit Renker
+E: gerrit@erg.abdn.ac.uk
+D: DCCP protocol support.
+
 N: Philip Gladstone
 E: philip@gladstonefamily.net
 D: Kernel / timekeeping stuff
diff --git a/MAINTAINERS b/MAINTAINERS
index 18e75e29c672..2a6dc5bfa08c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4920,9 +4920,8 @@ F:	Documentation/scsi/dc395x.rst
 F:	drivers/scsi/dc395x.*
 
 DCCP PROTOCOL
-M:	Gerrit Renker <gerrit@erg.abdn.ac.uk>
 L:	dccp@vger.kernel.org
-S:	Maintained
+S:	Orphan
 W:	http://www.linuxfoundation.org/collaborate/workgroups/networking/dccp
 F:	include/linux/dccp.h
 F:	include/linux/tfrc.h
-- 
2.26.2

