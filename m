Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47085CC6F7
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfJEAhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:37:04 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:34441 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfJEAhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 20:37:04 -0400
Received: by mail-qk1-f171.google.com with SMTP id q203so7535287qke.1
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 17:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJCWj4IEdQlZKxrzda1bYNCJWGwOmW+nfO4YLU85uQA=;
        b=MsnN2PwKzWoLRJakHWn/T5ryAyKAJy15ErOyCmlPjaWWHKnda2Q/r787GCnrmRJ2nf
         ypt52wY8ZcsxomRnqGoCXWP7rlEOpG15LL0j2P+5CQrsgNMwf/zKvZcSyy5Jl4E3A0vP
         8kO4EkSJmkK12ff84u6qwR9kXu2w5GN0mQ8daMDPY/a3FSzIrAbsypqVPxXyTdrfGCVj
         9RFDvoVJ8Ffv0AFnYb9DYo7oDwYdA+oYkyb+2x3Lsrx8T0xtpbREwyV9EY2RtM9EuMfZ
         KLjuWYA9DBhacCNSyyzjhYYxfQ1/MErDlF26ikbWt5y60XxA3fwre7RrRVGWqQ+DAogr
         RufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJCWj4IEdQlZKxrzda1bYNCJWGwOmW+nfO4YLU85uQA=;
        b=RqYpkMAaz5cnwEUlglG0MScth/+KZa9K25Azm9wBAaUog+zqmXop7+Iq8aBa82g0Tm
         yubs75dsi+zwA6Rptg8t4uFSaARreMkBsouKwJqINL341DZdBslAUYjaMKRF0ee7Fslq
         jM+LwfL9AU3QfB4fMcWt9DFhZeDpvn8d/0/rCExppA+4/LGdgviINNGIM4OhbQ97HB8N
         9Txy8eieNdHkriIaUwyVrcIJue/TzRM239An3UvvJ3CwXXt3TKk0JugUXhsGMcBOCez0
         XONrl+ZJcefgjJdg+Mc+SemDhGCTTasdFprmyn6tADZQvo2Ui3lAMUejT9oJiywWM79c
         KeJg==
X-Gm-Message-State: APjAAAVh5venERjm8qVwSE2RU2R4Opx3uZP+86UxkgblYJXxSxANnwwT
        g+OqOClKTSajXOcRT5B36wEmjw==
X-Google-Smtp-Source: APXvYqy5ELbao/eUN/Da3wsfexFIFXx0P7dQNy1oRj442NEKyHkFDyjvtaf3RnNExch9DQKlfY1g6Q==
X-Received: by 2002:ae9:e20f:: with SMTP id c15mr12939662qkc.122.1570235823385;
        Fri, 04 Oct 2019 17:37:03 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c8sm3782598qko.102.2019.10.04.17.37.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 17:37:02 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        dsahern@gmail.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net] selftests/net: add nettest to .gitignore
Date:   Fri,  4 Oct 2019 17:36:50 -0700
Message-Id: <20191005003650.32246-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nettest is missing from gitignore.

Fixes: acda655fefae ("selftests: Add nettest")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/testing/selftests/net/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index c7cced739c34..8aefd81fbc86 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -21,3 +21,4 @@ ipv6_flowlabel
 ipv6_flowlabel_mgr
 so_txtime
 tcp_fastopen_backup_key
+nettest
-- 
2.21.0

