Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A6485502
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241069AbiAEOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241070AbiAEOsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:48:51 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04022C061785;
        Wed,  5 Jan 2022 06:48:51 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t32so4119014pgm.7;
        Wed, 05 Jan 2022 06:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=DPDptQnqmmP73ot3bG6mL1jWK1Bk5H9HgLLa0bLKCTk=;
        b=mIRg1VzHdj7GVAcK4kCjo9Ld4eLQSRIzE29rST5J0YBegq7aHyo/KSQrZ42k0UOQ4Y
         y6IQE6S7z7V0bYNch8xhA2804oCkk/TamKbJMcgIA6Dh488qOheSFEOrCHtXaVVvvbPd
         2gPUDM9zIfyi5JjxLiYehxj1XuxgqDJlhCIaGqV0RLlA4ibRgN/FsYjVDb26Iu61D+t0
         Tnc/P8N3r/ACFCEWxfNI2lt6Flzl8s4YN++NsrWq7MfoIbGPfyBBu112xQ6GxC78EOEu
         rDd0HG71bQDQIxRNAn80rGMK6CFd2zrTjoENW4XE/DesbOkxrNblJBATUHuPcM9eRjzJ
         UOuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DPDptQnqmmP73ot3bG6mL1jWK1Bk5H9HgLLa0bLKCTk=;
        b=we595Rq03aY8y/E7EfegvaT3NM5T7JJAHxcdB7pKQq+JZBSDuS/n6KnxU3t1RlZD1E
         duUE2iVKOAH1Zr2BCEEgaQMla9a65smeWQWbQBmg5+lawBW+oGnso/UdsdS97OPK+elA
         S6c8VlGfSP/XCZyV3jTnBjLpP4e+4W4e9t2g2gIOxKmnBQihIOXMKiKayZ+w2xcrmQER
         BWomVSxg8/yWJbyKAXpp54ofZGtq3t8JHMp+Iu+RRx1s1FfgMWLnuym9vQO6hHbx757h
         TpXB6pethiz3yjcID+6ajd9O6EMFQqo8fS1iXCmMtxVfTR4HyWicFdQ8wOezHfuF2nBI
         m02w==
X-Gm-Message-State: AOAM530jCaI02fK7ruFAs1+LWJhxu6ICQJ27+N7/V+NeAt8Vm9QbUO+Z
        ZWZS4wwgfqDSR/wYBLrXuHJuQ7TFE6w=
X-Google-Smtp-Source: ABdhPJzTS/m3tjH4mhcMfItEa8WeLsBN3W9HU2C71RL7yaD8do3Ie3eJ4HmCiyGWwukkVVODpfoYog==
X-Received: by 2002:a63:290:: with SMTP id 138mr14291185pgc.408.1641394130481;
        Wed, 05 Jan 2022 06:48:50 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id h17sm43151278pfv.217.2022.01.05.06.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 06:48:50 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Cc:     ap420073@gmail.com, liuhangbin@gmail.com
Subject: [PATCH net] selftests: set amt.sh executable
Date:   Wed,  5 Jan 2022 14:44:36 +0000
Message-Id: <20220105144436.13415-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

amt.sh test script will not work because it doesn't have execution
permission. So, it adds execution permission.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 tools/testing/selftests/net/amt.sh | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/net/amt.sh

diff --git a/tools/testing/selftests/net/amt.sh b/tools/testing/selftests/net/amt.sh
old mode 100644
new mode 100755
-- 
2.17.1

