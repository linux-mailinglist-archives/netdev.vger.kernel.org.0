Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714B329F7C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391692AbfEXT7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:59:16 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33695 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391724AbfEXT7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 15:59:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so1919690wmh.0
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 12:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=98qLq1YzqvDS+bZlxBEFPwpmLRmsqB49UdX6CSq6WFg=;
        b=OXmag4aIKIjDaFfh1NzSOQgdry4dslesRfqxijNP7AKkNLwwFYltwlEXewKikbaODt
         L1rTN4crg+cl+zNFdScEyLE/5oKhLRdKGp29La6q1U9n+11JPdky5ov5pdSJimvu9d5o
         ApGKmV6FZqca/V33qL++rFczCWtqBhgCkYVY3h3zMxvxE2xKfxOorAPtgmcX9upjHQhk
         noIxmfU6sEK69R+bgPUXsuKeSaOORmGskz+IUPCufMxo0zDU6jq125idF9dwjW7fPmNe
         vlkP6PoiG08HIS7zGt+mFwuRrqLwQIVetTWTrhPdpMI/aojBywhnEmmGbBaQ//yMESR8
         i/KA==
X-Gm-Message-State: APjAAAVrSmNZEF3SW59Wlk/Tle8ESr6uSyifW6Y4oTPyIfZg+vtg+PT9
        xqdl1zQiqsRXnISKu2xkVnAy1A==
X-Google-Smtp-Source: APXvYqyRh3OV8dYox0YJl0PBxmCKnOVq+8z+KmDG88Sc4V+O4CxoZp1+fYgDvmYHhZdzy2v+WUx83w==
X-Received: by 2002:a05:600c:230a:: with SMTP id 10mr16603602wmo.13.1558727954156;
        Fri, 24 May 2019 12:59:14 -0700 (PDT)
Received: from raver.teknoraver.net (net-47-53-225-211.cust.vodafonedsl.it. [47.53.225.211])
        by smtp.gmail.com with ESMTPSA id b2sm3237140wrt.20.2019.05.24.12.59.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 12:59:13 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf] samples: bpf: add ibumad sample to .gitignore
Date:   Fri, 24 May 2019 21:59:12 +0200
Message-Id: <20190524195912.4966-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds ibumad to .gitignore which is
currently ommited from the ignore file.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 samples/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index c7498457595a..74d31fd3c99c 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -1,6 +1,7 @@
 cpustat
 fds_example
 hbm
+ibumad
 lathist
 lwt_len_hist
 map_perf_test
-- 
2.21.0

