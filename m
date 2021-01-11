Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927AF2F0C83
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbhAKF3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbhAKF3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C5D22A84;
        Mon, 11 Jan 2021 05:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342886;
        bh=8n1buGqP5y0s2TCt4RW1zjkRRvXQwDf2s6jx4JQZH3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvYinCC0j41LAtpwH5OeDN4BkSZiHg44J2YCDO1fM45mxjGqoqMVC7PebgRASpijx
         HgogGULqCoU6u13MXBhYsBl3OVr+TiVsf+55lHLHlp+FVNdOPEhxFlog6e9NDqcfP2
         tmrjuepxHBogSXnlmyqJOcbED/9aJyroZsKrFLIl2kAKDz/43mPTfIccLuIp8LZ75K
         f9QYCWXNqG9ylNWGTw4wHENwMYNtN1TqIW9xxyAXKHPBLtlesjoWAh9rlVyTjswTuF
         NfV3HYh0ZCA5GF1Lf6mFxpjGEYQznTasLp70EbOKl6kdbA1/8mFZxuADoFHMoBBNYW
         YpvJvSwbBG8kQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org
Subject: [PATCH net 8/9] MAINTAINERS: dccp: move Gerrit Renker to CREDITS
Date:   Sun, 10 Jan 2021 21:27:58 -0800
Message-Id: <20210111052759.2144758-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
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
index a5d69857f85a..17736ec96ec4 100644
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

