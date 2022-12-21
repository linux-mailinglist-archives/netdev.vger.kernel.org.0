Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29149653673
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiLUSkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiLUSkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:40:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA75026553
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 10:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74B9B618F2
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 18:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784FAC433F1;
        Wed, 21 Dec 2022 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671648010;
        bh=pf8BUCsc2p8esXoYgJOlHWt9gIBsqDleeMb/9WLSFEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evQ/5G7Iwqila1QqSCXDKJFTdXFuXymMZv9wR0L8nWxPhlJH28yHTkXFaLtJX252H
         rgwGLdz9cjWvmracE+elYdhaPWgJCHW8nAoIrNAteNxKckhyG6aIsN6rI7wEnAuzpf
         oWaaNBztpX0jaFgwRsPOxDhTpVsQvJCwA25F6h5ho360PdoJ9dR1QykY0AAw9QVefK
         gfumIBU2i0qXnm5xF4uR3JIjvXDSIwuHeJOxFWR3kAiZ+++cOuNOfbzQ7XLvfg/UWn
         nXUTBFALHMreaSrNDrTFBSLPnBm9VdTkuWV89qpTE8nryUDe/n55WXIhuAAifgQfvb
         dPEhgU71/Aa5A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        f.fainelli@gmail.com, andrew@lunn.ch, rdunlap@infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] docs: netdev: reshuffle sections in prep for de-FAQization
Date:   Wed, 21 Dec 2022 10:40:06 -0800
Message-Id: <20221221184007.1170384-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221184007.1170384-1-kuba@kernel.org>
References: <20221221184007.1170384-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent changes will reformat the doc away from FAQ.
To make that more readable perform the pure section moves now.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-netdev.rst | 186 ++++++++++----------
 1 file changed, 93 insertions(+), 93 deletions(-)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index 1fa5ab8754d3..8f22f8a3dcd1 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -44,17 +44,6 @@ mainline tree from Linus, and ``net-next`` is where the new code goes
 - https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 - https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 
-How do I indicate which tree (net vs. net-next) my patch should be in?
-----------------------------------------------------------------------
-To help maintainers and CI bots you should explicitly mark which tree
-your patch is targeting. Assuming that you use git, use the prefix
-flag::
-
-  git format-patch --subject-prefix='PATCH net-next' start..finish
-
-Use ``net`` instead of ``net-next`` (always lower case) in the above for
-bug-fix ``net`` content.
-
 How often do changes from these trees make it to the mainline Linus tree?
 -------------------------------------------------------------------------
 To understand this, you need to know a bit of background information on
@@ -127,15 +116,6 @@ patch. Patches are indexed by the ``Message-ID`` header of the emails
 which carried them so if you have trouble finding your patch append
 the value of ``Message-ID`` to the URL above.
 
-How long before my patch is accepted?
--------------------------------------
-Generally speaking, the patches get triaged quickly (in less than
-48h). But be patient, if your patch is active in patchwork (i.e. it's
-listed on the project's patch list) the chances it was missed are close to zero.
-Asking the maintainer for status updates on your
-patch is a good way to ensure your patch is ignored or pushed to the
-bottom of the priority list.
-
 Should I directly update patchwork state of my own patches?
 -----------------------------------------------------------
 It may be tempting to help the maintainers and update the state of your
@@ -145,19 +125,14 @@ it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
 
-How do I divide my work into patches?
+How long before my patch is accepted?
 -------------------------------------
-
-Put yourself in the shoes of the reviewer. Each patch is read separately
-and therefore should constitute a comprehensible step towards your stated
-goal.
-
-Avoid sending series longer than 15 patches. Larger series takes longer
-to review as reviewers will defer looking at it until they find a large
-chunk of time. A small series can be reviewed in a short time, so Maintainers
-just do it. As a result, a sequence of smaller series gets merged quicker and
-with better review coverage. Re-posting large series also increases the mailing
-list traffic.
+Generally speaking, the patches get triaged quickly (in less than
+48h). But be patient, if your patch is active in patchwork (i.e. it's
+listed on the project's patch list) the chances it was missed are close to zero.
+Asking the maintainer for status updates on your
+patch is a good way to ensure your patch is ignored or pushed to the
+bottom of the priority list.
 
 I made changes to only a few patches in a patch series should I resend only those changed?
 ------------------------------------------------------------------------------------------
@@ -165,17 +140,6 @@ No, please resend the entire patch series and make sure you do number your
 patches such that it is clear this is the latest and greatest set of patches
 that can be applied.
 
-I have received review feedback, when should I post a revised version of the patches?
--------------------------------------------------------------------------------------
-Allow at least 24 hours to pass between postings. This will ensure reviewers
-from all geographical locations have a chance to chime in. Do not wait
-too long (weeks) between postings either as it will make it harder for reviewers
-to recall all the context.
-
-Make sure you address all the feedback in your new posting. Do not post a new
-version of the code if the discussion about the previous version is still
-ongoing, unless directly instructed by a reviewer.
-
 I submitted multiple versions of a patch series and it looks like a version other than the last one has been accepted, what should I do?
 ----------------------------------------------------------------------------------------------------------------------------------------
 There is no revert possible, once it is pushed out, it stays like that.
@@ -191,6 +155,82 @@ the case today. Please follow the standard stable rules in
 :ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`,
 and make sure you include appropriate Fixes tags!
 
+I found a bug that might have possible security implications or similar. Should I mail the main netdev maintainer off-list?
+---------------------------------------------------------------------------------------------------------------------------
+No. The current netdev maintainer has consistently requested that
+people use the mailing lists and not reach out directly.  If you aren't
+OK with that, then perhaps consider mailing security@kernel.org or
+reading about http://oss-security.openwall.org/wiki/mailing-lists/distros
+as possible alternative mechanisms.
+
+How do I post corresponding changes to user space components?
+-------------------------------------------------------------
+User space code exercising kernel features should be posted
+alongside kernel patches. This gives reviewers a chance to see
+how any new interface is used and how well it works.
+
+When user space tools reside in the kernel repo itself all changes
+should generally come as one series. If series becomes too large
+or the user space project is not reviewed on netdev include a link
+to a public repo where user space patches can be seen.
+
+In case user space tooling lives in a separate repository but is
+reviewed on netdev  (e.g. patches to ``iproute2`` tools) kernel and
+user space patches should form separate series (threads) when posted
+to the mailing list, e.g.::
+
+  [PATCH net-next 0/3] net: some feature cover letter
+   └─ [PATCH net-next 1/3] net: some feature prep
+   └─ [PATCH net-next 2/3] net: some feature do it
+   └─ [PATCH net-next 3/3] selftest: net: some feature
+
+  [PATCH iproute2-next] ip: add support for some feature
+
+Posting as one thread is discouraged because it confuses patchwork
+(as of patchwork 2.2.2).
+
+Any other tips to help ensure my net/net-next patch gets OK'd?
+--------------------------------------------------------------
+Attention to detail.  Re-read your own work as if you were the
+reviewer.  You can start with using ``checkpatch.pl``, perhaps even with
+the ``--strict`` flag.  But do not be mindlessly robotic in doing so.
+If your change is a bug fix, make sure your commit log indicates the
+end-user visible symptom, the underlying reason as to why it happens,
+and then if necessary, explain why the fix proposed is the best way to
+get things done.  Don't mangle whitespace, and as is common, don't
+mis-indent function arguments that span multiple lines.  If it is your
+first patch, mail it to yourself so you can test apply it to an
+unpatched tree to confirm infrastructure didn't mangle it.
+
+Finally, go back and read
+:ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
+to be sure you are not repeating some common mistake documented there.
+
+How do I indicate which tree (net vs. net-next) my patch should be in?
+----------------------------------------------------------------------
+To help maintainers and CI bots you should explicitly mark which tree
+your patch is targeting. Assuming that you use git, use the prefix
+flag::
+
+  git format-patch --subject-prefix='PATCH net-next' start..finish
+
+Use ``net`` instead of ``net-next`` (always lower case) in the above for
+bug-fix ``net`` content.
+
+How do I divide my work into patches?
+-------------------------------------
+
+Put yourself in the shoes of the reviewer. Each patch is read separately
+and therefore should constitute a comprehensible step towards your stated
+goal.
+
+Avoid sending series longer than 15 patches. Larger series takes longer
+to review as reviewers will defer looking at it until they find a large
+chunk of time. A small series can be reviewed in a short time, so Maintainers
+just do it. As a result, a sequence of smaller series gets merged quicker and
+with better review coverage. Re-posting large series also increases the mailing
+list traffic.
+
 Is the comment style convention different for the networking content?
 ---------------------------------------------------------------------
 Yes, in a largely trivial way.  Instead of this::
@@ -224,13 +264,16 @@ I am working in existing code which uses non-standard formatting. Which formatti
 Make your code follow the most recent guidelines, so that eventually all code
 in the domain of netdev is in the preferred format.
 
-I found a bug that might have possible security implications or similar. Should I mail the main netdev maintainer off-list?
----------------------------------------------------------------------------------------------------------------------------
-No. The current netdev maintainer has consistently requested that
-people use the mailing lists and not reach out directly.  If you aren't
-OK with that, then perhaps consider mailing security@kernel.org or
-reading about http://oss-security.openwall.org/wiki/mailing-lists/distros
-as possible alternative mechanisms.
+I have received review feedback, when should I post a revised version of the patches?
+-------------------------------------------------------------------------------------
+Allow at least 24 hours to pass between postings. This will ensure reviewers
+from all geographical locations have a chance to chime in. Do not wait
+too long (weeks) between postings either as it will make it harder for reviewers
+to recall all the context.
+
+Make sure you address all the feedback in your new posting. Do not post a new
+version of the code if the discussion about the previous version is still
+ongoing, unless directly instructed by a reviewer.
 
 What level of testing is expected before I submit my change?
 ------------------------------------------------------------
@@ -244,32 +287,6 @@ and the patch series contains a set of kernel selftest for
 You are expected to test your changes on top of the relevant networking
 tree (``net`` or ``net-next``) and not e.g. a stable tree or ``linux-next``.
 
-How do I post corresponding changes to user space components?
--------------------------------------------------------------
-User space code exercising kernel features should be posted
-alongside kernel patches. This gives reviewers a chance to see
-how any new interface is used and how well it works.
-
-When user space tools reside in the kernel repo itself all changes
-should generally come as one series. If series becomes too large
-or the user space project is not reviewed on netdev include a link
-to a public repo where user space patches can be seen.
-
-In case user space tooling lives in a separate repository but is
-reviewed on netdev  (e.g. patches to ``iproute2`` tools) kernel and
-user space patches should form separate series (threads) when posted
-to the mailing list, e.g.::
-
-  [PATCH net-next 0/3] net: some feature cover letter
-   └─ [PATCH net-next 1/3] net: some feature prep
-   └─ [PATCH net-next 2/3] net: some feature do it
-   └─ [PATCH net-next 3/3] selftest: net: some feature
-
-  [PATCH iproute2-next] ip: add support for some feature
-
-Posting as one thread is discouraged because it confuses patchwork
-(as of patchwork 2.2.2).
-
 Can I reproduce the checks from patchwork on my local machine?
 --------------------------------------------------------------
 
@@ -303,23 +320,6 @@ it has a real, in-tree user. Mock-ups and tests based on ``netdevsim`` are
 strongly encouraged when adding new APIs, but ``netdevsim`` in itself
 is **not** considered a use case/user.
 
-Any other tips to help ensure my net/net-next patch gets OK'd?
---------------------------------------------------------------
-Attention to detail.  Re-read your own work as if you were the
-reviewer.  You can start with using ``checkpatch.pl``, perhaps even with
-the ``--strict`` flag.  But do not be mindlessly robotic in doing so.
-If your change is a bug fix, make sure your commit log indicates the
-end-user visible symptom, the underlying reason as to why it happens,
-and then if necessary, explain why the fix proposed is the best way to
-get things done.  Don't mangle whitespace, and as is common, don't
-mis-indent function arguments that span multiple lines.  If it is your
-first patch, mail it to yourself so you can test apply it to an
-unpatched tree to confirm infrastructure didn't mangle it.
-
-Finally, go back and read
-:ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
-to be sure you are not repeating some common mistake documented there.
-
 My company uses peer feedback in employee performance reviews. Can I ask netdev maintainers for feedback?
 ---------------------------------------------------------------------------------------------------------
 
-- 
2.38.1

