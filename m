Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003EE2DB266
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgLORT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:19:26 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:39062 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgLORT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 12:19:26 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id C66614409D4;
        Tue, 15 Dec 2020 19:18:43 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH net] docs: netdev-FAQ: add missing underlines to questions
Date:   Tue, 15 Dec 2020 19:18:19 +0200
Message-Id: <ccd6e8b9f1d87b683a0759e8954d03310cb0c09f.1608052699.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Documentation/networking/netdev-FAQ.rst | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 4b9ed5874d5a..4ef90fe26640 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -82,6 +82,7 @@ focus for ``net`` is on stabilization and bug fixes.
 Finally, the vX.Y gets released, and the whole cycle starts over.
 
 Q: So where are we now in this cycle?
+-------------------------------------
 
 Load the mainline (Linus) page here:
 
@@ -108,6 +109,7 @@ with.
 Q: I sent a patch and I'm wondering what happened to it?
 --------------------------------------------------------
 Q: How can I tell whether it got merged?
+----------------------------------------
 A: Start by looking at the main patchworks queue for netdev:
 
   https://patchwork.kernel.org/project/netdevbpf/list/
@@ -124,8 +126,8 @@ bottom of the priority list.
 
 Q: I submitted multiple versions of the patch series
 ----------------------------------------------------
-Q: should I directly update patchwork for the previous versions of these
-patch series?
+Q: should I directly update patchwork for the previous versions of these patch series?
+--------------------------------------------------------------------------------------
 A: No, please don't interfere with the patch status on patchwork, leave
 it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
@@ -171,8 +173,8 @@ simply clone the repo, and then git grep the mainline commit ID, e.g.
 
 Q: I see a network patch and I think it should be backported to stable.
 -----------------------------------------------------------------------
-Q: Should I request it via stable@vger.kernel.org like the references in
-the kernel's Documentation/process/stable-kernel-rules.rst file say?
+Q: Should I request it via stable@vger.kernel.org like the references in the kernel's Documentation/process/stable-kernel-rules.rst file say?
+---------------------------------------------------------------------------------------------------------------------------------------------
 A: No, not for networking.  Check the stable queues as per above first
 to see if it is already queued.  If not, then send a mail to netdev,
 listing the upstream commit ID and why you think it should be a stable
@@ -192,8 +194,8 @@ be avoided.
 
 Q: I have created a network patch and I think it should be backported to stable.
 --------------------------------------------------------------------------------
-Q: Should I add a Cc: stable@vger.kernel.org like the references in the
-kernel's Documentation/ directory say?
+Q: Should I add a Cc: stable@vger.kernel.org like the references in the kernel's Documentation/ directory say?
+--------------------------------------------------------------------------------------------------------------
 A: No.  See above answer.  In short, if you think it really belongs in
 stable, then ensure you write a decent commit log that describes who
 gets impacted by the bug fix and how it manifests itself, and when the
@@ -234,12 +236,14 @@ it is requested that you make it look like this::
 Q: I am working in existing code that has the former comment style and not the latter.
 --------------------------------------------------------------------------------------
 Q: Should I submit new code in the former style or the latter?
+--------------------------------------------------------------
 A: Make it the latter style, so that eventually all code in the domain
 of netdev is of this format.
 
 Q: I found a bug that might have possible security implications or similar.
 ---------------------------------------------------------------------------
-Q: Should I mail the main netdev maintainer off-list?**
+Q: Should I mail the main netdev maintainer off-list?
+-----------------------------------------------------
 A: No. The current netdev maintainer has consistently requested that
 people use the mailing lists and not reach out directly.  If you aren't
 OK with that, then perhaps consider mailing security@kernel.org or
-- 
2.29.2

