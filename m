Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F9974269
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388017AbfGYAHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:07:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41969 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727379AbfGYAHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 20:07:30 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so47280509qtj.8
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 17:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KDeKcR8d1QbfFr4hKBrCJ8c2DS8++tAr6M69pIq2wpU=;
        b=FpttxRYbzS87QqCq4NOkNazgZfH4782RA8G+WjY6j7Tp53bhpaBcVFblH0X0M7MW3/
         GhQ6XJY0vSmpAnZgQuZQCIX2Uq77kFnJAE0s/RKFs9VF0MU/YgMytsMlAy9eD/l1hOV2
         J0yf7ye+/YVkKnMhmIHMHYynTaTCeBSqypV4Lvk+nL3E7vhkLlHmkL8WfQF68EyJu26h
         tVrHUSfJH1E413sqF1LgvL7qne3nioNZxbXdHFR8cj8zqy2ZaRBf97JcIHZZsejlRDPl
         UxDK25zNQsMa5JVoJbFirjqMDUGbrmgXmph+Ibq+PYmT0zLFqc/GEZ809onVJrEngAEZ
         x21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KDeKcR8d1QbfFr4hKBrCJ8c2DS8++tAr6M69pIq2wpU=;
        b=geBjdPDQNPn2CH041QyzsPNlW8jrdQ924rSBKDwMhmJIvxD8iMqdTmH2FrhZZlxt91
         qcRxLE4kBxLw+iFx2JkxuZ8bVHijmG4zRXXVO3S35DD/+aNSQJcqjknWlKXCcNOUgYNf
         lQA3zqbE6+9dajE1pG7Q2Dz8ZkHDDioXVizPmQk+8oD1UilV59dn+K9ueLM3QSH6y7ra
         q4L41GP7Cu6JItR70L4xB/VoxINI1oDGgIWVE7RkwKVSq7trId/E6CXPYU04mrA/ICOM
         2C8o7CY4bPSrdm2Dj4xtV5ZrkKli7yGU7E58wK11Nuk+DIrQDU5oVYnxU9Yu/LFN8rEY
         qlxA==
X-Gm-Message-State: APjAAAWJAVJd3e6b4dzFRb9ci3tfW2QpTV9gmSFlnH9R3TOGFM+2ZhWz
        E2dBhxde8FOj8hqNh1n1aSLt/w==
X-Google-Smtp-Source: APXvYqzOhqPchJZD8xRw+XwD9mEaSyuByqjdlyqAM4c1gFmD5UIpBLVtQdA5kRRCnvOUtx3ZOkTHxA==
X-Received: by 2002:a0c:afac:: with SMTP id s41mr61886000qvc.184.1564013249679;
        Wed, 24 Jul 2019 17:07:29 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z50sm25502101qtz.36.2019.07.24.17.07.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 17:07:29 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        willemb@google.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH net] selftests/net: add missing gitignores (ipv6_flowlabel)
Date:   Wed, 24 Jul 2019 17:07:14 -0700
Message-Id: <20190725000714.10200-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_flowlabel and ipv6_flowlabel_mgr are missing from
gitignore.  Quentin points out that the original
commit 3fb321fde22d ("selftests/net: ipv6 flowlabel")
did add ignore entries, they are just missing the "ipv6_"
prefix.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tools/testing/selftests/net/.gitignore | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 4ce0bc1612f5..c7cced739c34 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -17,7 +17,7 @@ tcp_inq
 tls
 txring_overwrite
 ip_defrag
+ipv6_flowlabel
+ipv6_flowlabel_mgr
 so_txtime
-flowlabel
-flowlabel_mgr
 tcp_fastopen_backup_key
-- 
2.21.0

