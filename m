Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236A92DF480
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 09:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgLTIvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 03:51:09 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42189 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbgLTIvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 03:51:08 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 851F0440581;
        Sun, 20 Dec 2020 10:50:24 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v2] docs: netdev-FAQ: fix question headers formatting
Date:   Sun, 20 Dec 2020 10:49:47 +0200
Message-Id: <f76078ba5547744f2ec178984c32fbc7dcd29a2b.1608454187.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Join adjacent questions to a single question line. This fixes the
formatting of questions that were not part of the heading.

Also, drop Q: and A: prefixes. We don't need them now that questions and
answers are visually separated.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: Address comments from Jakub Kicinski:

  * Join adjacent questions

  * Drop Q:/A: prefixes
---
 Documentation/networking/netdev-FAQ.rst | 126 +++++++++++-------------
 1 file changed, 59 insertions(+), 67 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 4b9ed5874d5a..aa6fdb4fcae9 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -6,9 +6,9 @@
 netdev FAQ
 ==========
 
-Q: What is netdev?
-------------------
-A: It is a mailing list for all network-related Linux stuff.  This
+What is netdev?
+---------------
+It is a mailing list for all network-related Linux stuff.  This
 includes anything found under net/ (i.e. core code like IPv6) and
 drivers/net (i.e. hardware specific drivers) in the Linux source tree.
 
@@ -25,9 +25,9 @@ Aside from subsystems like that mentioned above, all network-related
 Linux development (i.e. RFC, review, comments, etc.) takes place on
 netdev.
 
-Q: How do the changes posted to netdev make their way into Linux?
------------------------------------------------------------------
-A: There are always two trees (git repositories) in play.  Both are
+How do the changes posted to netdev make their way into Linux?
+--------------------------------------------------------------
+There are always two trees (git repositories) in play.  Both are
 driven by David Miller, the main network maintainer.  There is the
 ``net`` tree, and the ``net-next`` tree.  As you can probably guess from
 the names, the ``net`` tree is for fixes to existing code already in the
@@ -37,9 +37,9 @@ for the future release.  You can find the trees here:
 - https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 - https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 
-Q: How often do changes from these trees make it to the mainline Linus tree?
-----------------------------------------------------------------------------
-A: To understand this, you need to know a bit of background information on
+How often do changes from these trees make it to the mainline Linus tree?
+-------------------------------------------------------------------------
+To understand this, you need to know a bit of background information on
 the cadence of Linux development.  Each new release starts off with a
 two week "merge window" where the main maintainers feed their new stuff
 to Linus for merging into the mainline tree.  After the two weeks, the
@@ -81,7 +81,8 @@ focus for ``net`` is on stabilization and bug fixes.
 
 Finally, the vX.Y gets released, and the whole cycle starts over.
 
-Q: So where are we now in this cycle?
+So where are we now in this cycle?
+----------------------------------
 
 Load the mainline (Linus) page here:
 
@@ -91,9 +92,9 @@ and note the top of the "tags" section.  If it is rc1, it is early in
 the dev cycle.  If it was tagged rc7 a week ago, then a release is
 probably imminent.
 
-Q: How do I indicate which tree (net vs. net-next) my patch should be in?
--------------------------------------------------------------------------
-A: Firstly, think whether you have a bug fix or new "next-like" content.
+How do I indicate which tree (net vs. net-next) my patch should be in?
+----------------------------------------------------------------------
+Firstly, think whether you have a bug fix or new "next-like" content.
 Then once decided, assuming that you use git, use the prefix flag, i.e.
 ::
 
@@ -105,48 +106,45 @@ in the above is just the subject text of the outgoing e-mail, and you
 can manually change it yourself with whatever MUA you are comfortable
 with.
 
-Q: I sent a patch and I'm wondering what happened to it?
---------------------------------------------------------
-Q: How can I tell whether it got merged?
-A: Start by looking at the main patchworks queue for netdev:
+I sent a patch and I'm wondering what happened to it - How can I tell whether it got merged?
+--------------------------------------------------------------------------------------------
+Start by looking at the main patchworks queue for netdev:
 
   https://patchwork.kernel.org/project/netdevbpf/list/
 
 The "State" field will tell you exactly where things are at with your
 patch.
 
-Q: The above only says "Under Review".  How can I find out more?
-----------------------------------------------------------------
-A: Generally speaking, the patches get triaged quickly (in less than
+The above only says "Under Review".  How can I find out more?
+-------------------------------------------------------------
+Generally speaking, the patches get triaged quickly (in less than
 48h).  So be patient.  Asking the maintainer for status updates on your
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
-Q: I submitted multiple versions of the patch series
-----------------------------------------------------
-Q: should I directly update patchwork for the previous versions of these
-patch series?
-A: No, please don't interfere with the patch status on patchwork, leave
+I submitted multiple versions of the patch series. Should I directly update patchwork for the previous versions of these patch series?
+--------------------------------------------------------------------------------------------------------------------------------------
+No, please don't interfere with the patch status on patchwork, leave
 it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
 
-Q: I made changes to only a few patches in a patch series should I resend only those changed?
----------------------------------------------------------------------------------------------
-A: No, please resend the entire patch series and make sure you do number your
+I made changes to only a few patches in a patch series should I resend only those changed?
+------------------------------------------------------------------------------------------
+No, please resend the entire patch series and make sure you do number your
 patches such that it is clear this is the latest and greatest set of patches
 that can be applied.
 
-Q: I submitted multiple versions of a patch series and it looks like a version other than the last one has been accepted, what should I do?
--------------------------------------------------------------------------------------------------------------------------------------------
-A: There is no revert possible, once it is pushed out, it stays like that.
+I submitted multiple versions of a patch series and it looks like a version other than the last one has been accepted, what should I do?
+----------------------------------------------------------------------------------------------------------------------------------------
+There is no revert possible, once it is pushed out, it stays like that.
 Please send incremental versions on top of what has been merged in order to fix
 the patches the way they would look like if your latest patch series was to be
 merged.
 
-Q: How can I tell what patches are queued up for backporting to the various stable releases?
---------------------------------------------------------------------------------------------
-A: Normally Greg Kroah-Hartman collects stable commits himself, but for
+How can I tell what patches are queued up for backporting to the various stable releases?
+-----------------------------------------------------------------------------------------
+Normally Greg Kroah-Hartman collects stable commits himself, but for
 networking, Dave collects up patches he deems critical for the
 networking subsystem, and then hands them off to Greg.
 
@@ -169,11 +167,9 @@ simply clone the repo, and then git grep the mainline commit ID, e.g.
   releases/3.9.8/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
   stable/stable-queue$
 
-Q: I see a network patch and I think it should be backported to stable.
------------------------------------------------------------------------
-Q: Should I request it via stable@vger.kernel.org like the references in
-the kernel's Documentation/process/stable-kernel-rules.rst file say?
-A: No, not for networking.  Check the stable queues as per above first
+I see a network patch and I think it should be backported to stable. Should I request it via stable@vger.kernel.org like the references in the kernel's Documentation/process/stable-kernel-rules.rst file say?
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+No, not for networking.  Check the stable queues as per above first
 to see if it is already queued.  If not, then send a mail to netdev,
 listing the upstream commit ID and why you think it should be a stable
 candidate.
@@ -190,11 +186,9 @@ mainline, the better the odds that it is an OK candidate for stable.  So
 scrambling to request a commit be added the day after it appears should
 be avoided.
 
-Q: I have created a network patch and I think it should be backported to stable.
---------------------------------------------------------------------------------
-Q: Should I add a Cc: stable@vger.kernel.org like the references in the
-kernel's Documentation/ directory say?
-A: No.  See above answer.  In short, if you think it really belongs in
+I have created a network patch and I think it should be backported to stable. Should I add a Cc: stable@vger.kernel.org like the references in the kernel's Documentation/ directory say?
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+No.  See above answer.  In short, if you think it really belongs in
 stable, then ensure you write a decent commit log that describes who
 gets impacted by the bug fix and how it manifests itself, and when the
 bug was introduced.  If you do that properly, then the commit will get
@@ -207,18 +201,18 @@ marker line as described in
 :ref:`Documentation/process/submitting-patches.rst <the_canonical_patch_format>`
 to temporarily embed that information into the patch that you send.
 
-Q: Are all networking bug fixes backported to all stable releases?
-------------------------------------------------------------------
-A: Due to capacity, Dave could only take care of the backports for the
+Are all networking bug fixes backported to all stable releases?
+---------------------------------------------------------------
+Due to capacity, Dave could only take care of the backports for the
 last two stable releases. For earlier stable releases, each stable
 branch maintainer is supposed to take care of them. If you find any
 patch is missing from an earlier stable branch, please notify
 stable@vger.kernel.org with either a commit ID or a formal patch
 backported, and CC Dave and other relevant networking developers.
 
-Q: Is the comment style convention different for the networking content?
-------------------------------------------------------------------------
-A: Yes, in a largely trivial way.  Instead of this::
+Is the comment style convention different for the networking content?
+---------------------------------------------------------------------
+Yes, in a largely trivial way.  Instead of this::
 
   /*
    * foobar blah blah blah
@@ -231,32 +225,30 @@ it is requested that you make it look like this::
    * another line of text
    */
 
-Q: I am working in existing code that has the former comment style and not the latter.
---------------------------------------------------------------------------------------
-Q: Should I submit new code in the former style or the latter?
-A: Make it the latter style, so that eventually all code in the domain
+I am working in existing code that has the former comment style and not the latter. Should I submit new code in the former style or the latter?
+-----------------------------------------------------------------------------------------------------------------------------------------------
+Make it the latter style, so that eventually all code in the domain
 of netdev is of this format.
 
-Q: I found a bug that might have possible security implications or similar.
----------------------------------------------------------------------------
-Q: Should I mail the main netdev maintainer off-list?**
-A: No. The current netdev maintainer has consistently requested that
+I found a bug that might have possible security implications or similar. Should I mail the main netdev maintainer off-list?
+---------------------------------------------------------------------------------------------------------------------------
+No. The current netdev maintainer has consistently requested that
 people use the mailing lists and not reach out directly.  If you aren't
 OK with that, then perhaps consider mailing security@kernel.org or
 reading about http://oss-security.openwall.org/wiki/mailing-lists/distros
 as possible alternative mechanisms.
 
-Q: What level of testing is expected before I submit my change?
----------------------------------------------------------------
-A: If your changes are against ``net-next``, the expectation is that you
+What level of testing is expected before I submit my change?
+------------------------------------------------------------
+If your changes are against ``net-next``, the expectation is that you
 have tested by layering your changes on top of ``net-next``.  Ideally
 you will have done run-time testing specific to your change, but at a
 minimum, your changes should survive an ``allyesconfig`` and an
 ``allmodconfig`` build without new warnings or failures.
 
-Q: How do I post corresponding changes to user space components?
-----------------------------------------------------------------
-A: User space code exercising kernel features should be posted
+How do I post corresponding changes to user space components?
+-------------------------------------------------------------
+User space code exercising kernel features should be posted
 alongside kernel patches. This gives reviewers a chance to see
 how any new interface is used and how well it works.
 
@@ -280,9 +272,9 @@ to the mailing list, e.g.::
 Posting as one thread is discouraged because it confuses patchwork
 (as of patchwork 2.2.2).
 
-Q: Any other tips to help ensure my net/net-next patch gets OK'd?
------------------------------------------------------------------
-A: Attention to detail.  Re-read your own work as if you were the
+Any other tips to help ensure my net/net-next patch gets OK'd?
+--------------------------------------------------------------
+Attention to detail.  Re-read your own work as if you were the
 reviewer.  You can start with using ``checkpatch.pl``, perhaps even with
 the ``--strict`` flag.  But do not be mindlessly robotic in doing so.
 If your change is a bug fix, make sure your commit log indicates the
-- 
2.29.2

