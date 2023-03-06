Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DDB6ACE5D
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCFToW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjCFToO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:44:14 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FF6D516
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 11:44:10 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n5so6584727pfv.11
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 11:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678131850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uDamLz1R1M2EvlCJNJ9a8cQq3vVkOtXVUA0EYL8IVDk=;
        b=l6BrC34U1QJuFxxEt/uXf+VQiB2RO3q/GbyPWKUcJbbKo538Lpc27O3P7G7QbDFSzO
         AjceZvW1po++YXDHMleqc9pz1p5PIdfyYvHBp+NzBQWKlktPcoLp4gVR+HO2YyBEc4t/
         vp6yDnBAc2kMJy2Q9hg+7g9i1D6W75I7jE1r8Ab+QyZdnqX+HwnxJYTArQZ+auUQJ6Po
         FfKGfhOFC3GOdTiIzOsM0DkQm4xvPZVWocRKwu1S5DCO9IeiIMkfWp3PUREJNMSL+yCG
         w6Kib62DTx07mO5rO+XBYxhoijtWjOfOTzl5OYgjQXdk97DkAEEyDPPPC1NbWP28/XN4
         bfPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678131850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDamLz1R1M2EvlCJNJ9a8cQq3vVkOtXVUA0EYL8IVDk=;
        b=57n/aHJeR5lfbSEjsDdva5L14T5fYiIdT9OgmPpKdsooflYGSobIHyByCmNY2tRWmS
         j/30OT8iiZ5LTSicv5VsonnXBDWUS7Br4h45+FbUyMmbgnsKiN5YUBvRcQtORRC7HWxE
         fs9qqJ/V1s17KbWgHQQ5O6CxgS9JU71yXDiW88cMYHMezX4nVd8UFLLEdU4ftnhHjEVF
         Q2yIT314eJ4HNDqIPTv1ghTrKgOaHUZekgTFtXPtVKlkwN0PilUXnmBbPsCF7te9UCRK
         OpSXFLkXANMVuHGEtHT5e1QNkIL3ZyI6jsbhaDrklzx23XaTfm8OOUk7USRwDfGcBGkF
         G5+w==
X-Gm-Message-State: AO0yUKU0O6UDZOowzsNKxqMUf2YT7rBzZOZz2gMthx7TrXBbCgnZSkS4
        W4zjzlaQn/K55UUWtYX5h6jAJtqXWXjMZggGo4tOPQ==
X-Google-Smtp-Source: AK7set8G6+bZt/ulnZE8eovXbH7LJXT+4Z6a97J84Zfh+olPY/BYH08s7EWreofbR+uPjJVplf3LNw==
X-Received: by 2002:aa7:95a8:0:b0:5a8:5e6d:28d7 with SMTP id a8-20020aa795a8000000b005a85e6d28d7mr9800158pfk.0.1678131849879;
        Mon, 06 Mar 2023 11:44:09 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w8-20020aa78588000000b00593906a8843sm6799652pfn.176.2023.03.06.11.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 11:44:09 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net] mailmap: update entries for Stephen Hemminger
Date:   Mon,  6 Mar 2023 11:44:05 -0800
Message-Id: <20230306194405.108236-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Map all my old email addresses to current address.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 .mailmap | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index a872c9683958..0ce99a1fa24f 100644
--- a/.mailmap
+++ b/.mailmap
@@ -409,7 +409,10 @@ Shuah Khan <shuah@kernel.org> <shuah.kh@samsung.com>
 Simon Arlott <simon@octiron.net> <simon@fire.lp0.eu>
 Simon Kelley <simon@thekelleys.org.uk>
 Stéphane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
-Stephen Hemminger <shemminger@osdl.org>
+Stephen Hemminger <stephen@networkplumber.org> <shemminger@linux-foundation.org>
+Stephen Hemminger <stephen@networkplumber.org> <shemminger@osdl.org>
+Stephen Hemminger <stephen@networkplumber.org> <sthemmin@microsoft.com>
+Stephen Hemminger <stephen@networkplumber.org> <sthemmin@vyatta.com>
 Steve Wise <larrystevenwise@gmail.com> <swise@chelsio.com>
 Steve Wise <larrystevenwise@gmail.com> <swise@opengridcomputing.com>
 Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
-- 
2.39.2

