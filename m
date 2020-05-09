Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDD91CBD90
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgEIEr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgEIEr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:47:28 -0400
Received: from omr2.cc.vt.edu (omr2.cc.ipv6.vt.edu [IPv6:2607:b400:92:8400:0:33:fb76:806e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33783C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 21:47:28 -0700 (PDT)
Received: from mr2.cc.vt.edu (mail.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id 0494lRfp001203
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 00:47:27 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        by mr2.cc.vt.edu (8.14.7/8.14.7) with ESMTP id 0494lMf9023967
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 00:47:27 -0400
Received: by mail-qt1-f199.google.com with SMTP id x56so4373727qtc.10
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 21:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=CieMS2rA989SLT5WdlqR3SNmJMU/gOjJ8XfYOw251Ak=;
        b=r9xdDMLoK6nXyyhKobtHOFavGWYrmgw9zzmE3wHgoJsU9CTc+mxMyrkRY4oUnApV94
         zdSdV70yH9FaGTd0DbgA7qLrPdmj+N65FRqg3YxEJdrRCyNYoQ5QnNysrhQ3Luf/c7d2
         I5MiXZFsiwelqr+3Lirvy3hqDBYNQqG0HQlCyLZVETCXCWCeASTEAgMzXmOxyweeqWxg
         rc/tnZlVPzAhxWUSX+PNS4xaPkwi+TF9TJDFQnHGUE17SK+XjwbQsFsk5+Whxb9+EQ7d
         EowvlxlRGUbgmnB2yMa7xM3rFaekFG2UhM1uJjc6X2HB89wa9HP1zmCHCKnZyNugGzS8
         qy4w==
X-Gm-Message-State: AGi0PuYkoJbF8amxA/yRRwZ0ZO39b12SJ4yToS1rOmGx5mFknk480e2+
        5uz8j+NZPUMyKLCTjAztBvGK+tANzKOt+OAAX3+p0dQGzYlyfas9bI4zHcPGamdL9e1u9elkHLa
        JmBZtzOtQ9Q+SJceBQSCIME73elc=
X-Received: by 2002:aed:2765:: with SMTP id n92mr6561186qtd.73.1588999642175;
        Fri, 08 May 2020 21:47:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypKrdwg9wFkSZEGyvIVNHrNxASjnM/WoZIv/+zUsBOK23ts64KQdieyMlQLlRE6tvAKySSZD6A==
X-Received: by 2002:aed:2765:: with SMTP id n92mr6561176qtd.73.1588999641925;
        Fri, 08 May 2020 21:47:21 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:c9e1::359])
        by smtp.gmail.com with ESMTPSA id d6sm2783247qkj.72.2020.05.08.21.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:47:20 -0700 (PDT)
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Masahiro Yamada <masahiroy@kernel.org>
cc:     Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] bpfilter: document build requirements for bpfilter_umh
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Sat, 09 May 2020 00:47:19 -0400
Message-ID: <131136.1588999639@turing-police>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not intuitively obvious that bpfilter_umh is a statically linked binary.
Mention the toolchain requirement in the Kconfig help, so people
have an easier time figuring out what's needed.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/net/bpfilter/Kconfig b/net/bpfilter/Kconfig
index fed9290e3b41..0ec6c7958c20 100644
--- a/net/bpfilter/Kconfig
+++ b/net/bpfilter/Kconfig
@@ -13,4 +13,8 @@ config BPFILTER_UMH
 	default m
 	help
 	  This builds bpfilter kernel module with embedded user mode helper
+
+	  Note: your toolchain must support building static binaries, since
+	  rootfs isn't mounted at the time when __init functions are called
+	  and do_execv won't be able to find the elf interpreter.
 endif

