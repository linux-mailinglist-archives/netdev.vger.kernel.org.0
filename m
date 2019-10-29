Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31F8E8DCA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390872AbfJ2RM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:12:28 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43137 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390744AbfJ2RM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:12:27 -0400
Received: by mail-lf1-f66.google.com with SMTP id j5so4755923lfh.10
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 10:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJj2qY+wWadbp/frvkYUfZeoO8SyUDjf00hUMJMOl7o=;
        b=lWtSj2dAww3gvfuDK3RYsh/OlRzFTAkge7Sj3Ryz5YhurvSdFtXA5hzU2G9RdDPSUt
         wSuthKyHG3i2blExm1jDoTkCg1BqMPVj8iHAXKR+HlgQSqBDcgoQ17H/dIlRVgSkQZnb
         wbSStVGmy9SfehbZqzlTQbBjK7V5jn54YcgZ8chvO+IkBjNwv9NwCOjtRR3lDneGzf8U
         bvUEJxqNu4e5G1zGIvklYFFQWUJ6Z9QrsSTrkSSbQrZj+Z4kedlRS9LzBIVAVfyoMs3S
         dgNrhad2rT/sKT2epekUJBrJT4Pss2XYy2neyrOCjojAPb8gjSug3DmVlwHwssQ7eOkR
         dzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJj2qY+wWadbp/frvkYUfZeoO8SyUDjf00hUMJMOl7o=;
        b=oh8wyD6YMoS1cTSxTopKxSZTQGd4VR2rBaoshdnjYObHARCvdyCFHYWNvXq8ot4a6/
         +Q/oYPLRwE0kzxotMpcn+WiPc6BdlsJCxEce7tmt2dcyZVGkuWCmA/vb/qlWnlsohVGI
         caaxjio9l2/mCB9XfEHjxif5y0zhm+5XBeTQz2UYM8J/fjSI7f/KLbWE4wg6Qyca0q6e
         91lCCeQ/FE5FPM6NdeRnE5yBXInFuDerzW7Yfma3mtgrqa8mH4IOk2Rw1qUw/CWZhgjX
         Nfc5XufgiVf9Iqg7/XkxmMz37HKIinquznkwA62QB9S3ENiy4gigtgVFeofL6mlJKl1p
         PQ5w==
X-Gm-Message-State: APjAAAX8wwgxNxwQe5crjTT2vjOtqBQYccyXiSRcUZsGVKjcpxbBriAy
        vHy8mLD/6+wzhUVCg1PEZ9aHCw==
X-Google-Smtp-Source: APXvYqzvww1Km84Vyks1zXg7FGvX0slqjz6NHlTnlhfFO5LDoV2zyC5m2lOrxdQKGcNdpemCORO0UQ==
X-Received: by 2002:a19:ec02:: with SMTP id b2mr3100657lfa.121.1572369145424;
        Tue, 29 Oct 2019 10:12:25 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e9sm6577492ljo.71.2019.10.29.10.12.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 10:12:24 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com, corbet@lwn.net,
        linux-doc@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] Documentation: netdev-FAQ: make all questions into headings
Date:   Tue, 29 Oct 2019 10:12:15 -0700
Message-Id: <20191029171215.6861-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure all questions are headings. Some questions are
currently on multiple lines, and the continuation lines
appear as part of the answer when rendered. One question
was also missing an underline completely.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/netdev-FAQ.rst | 35 +++++++++----------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 642fa963be3c..633d558743b2 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -82,7 +82,7 @@ focus for ``net`` is on stabilization and bug fixes.
 Finally, the vX.Y gets released, and the whole cycle starts over.
 
 Q: So where are we now in this cycle?
-
+-------------------------------------
 Load the mainline (Linus) page here:
 
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
@@ -105,9 +105,8 @@ in the above is just the subject text of the outgoing e-mail, and you
 can manually change it yourself with whatever MUA you are comfortable
 with.
 
-Q: I sent a patch and I'm wondering what happened to it?
---------------------------------------------------------
-Q: How can I tell whether it got merged?
+Q: I sent a patch and I'm wondering what happened to it? How can I tell whether it got merged?
+----------------------------------------------------------------------------------------------
 A: Start by looking at the main patchworks queue for netdev:
 
   http://patchwork.ozlabs.org/project/netdev/list/
@@ -122,10 +121,8 @@ A: Generally speaking, the patches get triaged quickly (in less than
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
-Q: I submitted multiple versions of the patch series
-----------------------------------------------------
-Q: should I directly update patchwork for the previous versions of these
-patch series?
+Q: I submitted multiple versions of the patch series should I directly update patchwork for the previous versions of these patch series?
+----------------------------------------------------------------------------------------------------------------------------------------
 A: No, please don't interfere with the patch status on patchwork, leave
 it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
@@ -169,10 +166,8 @@ simply clone the repo, and then git grep the mainline commit ID, e.g.
   releases/3.9.8/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
   stable/stable-queue$
 
-Q: I see a network patch and I think it should be backported to stable.
------------------------------------------------------------------------
-Q: Should I request it via stable@vger.kernel.org like the references in
-the kernel's Documentation/process/stable-kernel-rules.rst file say?
+Q: I see a network patch and I think it should be backported to stable. Should I request it via stable@vger.kernel.org like the references in the kernel's Documentation/process/stable-kernel-rules.rst file say?
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 A: No, not for networking.  Check the stable queues as per above first
 to see if it is already queued.  If not, then send a mail to netdev,
 listing the upstream commit ID and why you think it should be a stable
@@ -190,10 +185,8 @@ mainline, the better the odds that it is an OK candidate for stable.  So
 scrambling to request a commit be added the day after it appears should
 be avoided.
 
-Q: I have created a network patch and I think it should be backported to stable.
---------------------------------------------------------------------------------
-Q: Should I add a Cc: stable@vger.kernel.org like the references in the
-kernel's Documentation/ directory say?
+Q: I have created a network patch and I think it should be backported to stable. Should I add a Cc: stable@vger.kernel.org like the references in the kernel's Documentation/ directory say?
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 A: No.  See above answer.  In short, if you think it really belongs in
 stable, then ensure you write a decent commit log that describes who
 gets impacted by the bug fix and how it manifests itself, and when the
@@ -231,15 +224,13 @@ Q: Is the comment style convention different for the networking content?
    * another line of text
    */
 
-Q: I am working in existing code that has the former comment style and not the latter.
---------------------------------------------------------------------------------------
-Q: Should I submit new code in the former style or the latter?
+Q: I am working in existing code that has the former comment style and not the latter. Should I submit new code in the former style or the latter?
+--------------------------------------------------------------------------------------------------------------------------------------------------
 A: Make it the latter style, so that eventually all code in the domain
 of netdev is of this format.
 
-Q: I found a bug that might have possible security implications or similar.
----------------------------------------------------------------------------
-Q: Should I mail the main netdev maintainer off-list?**
+Q: I found a bug that might have possible security implications or similar. Should I mail the main netdev maintainer off-list?
+------------------------------------------------------------------------------------------------------------------------------
 A: No. The current netdev maintainer has consistently requested that
 people use the mailing lists and not reach out directly.  If you aren't
 OK with that, then perhaps consider mailing security@kernel.org or
-- 
2.23.0

