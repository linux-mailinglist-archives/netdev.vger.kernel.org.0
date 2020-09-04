Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B425D177
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgIDGeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgIDGeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:34:46 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8888BC061244;
        Thu,  3 Sep 2020 23:34:46 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q3so674845pls.11;
        Thu, 03 Sep 2020 23:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5n/OPSDhM3uanqKb+YL48CfWwtA6HLpmv/RHBP/jyY=;
        b=M9pmWJ1jNLwnusYt/BTqHLszFVRWcQiwrJFiGA6fIFN78uDqxgZnasoyCB36eQ0zzK
         iV5jNdtkaPEvDdZJYSdKe2oAABYEbn4uOMIkafUK7obM9UOZ13waFtb8w1mxiJSDle65
         DJVv8WT1X1aqLDMuVWlDmVE2trnG3F9JtiIKY7x0fR26kUetvqHgz5VBsHsLH8WYn1Wz
         xBrxvgdot8T9kfa7npF72yfCui4ZUHwyfz1Hdw1aGTZuRcHv/LS1nuuRVoOJCKy1eLZV
         24JN9NGYNFIY7hfyeIwZRswMUfctD4sgrWs4aYz3tqKRrryJoyBTzwTOJdAmOAvVYzVd
         8nZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5n/OPSDhM3uanqKb+YL48CfWwtA6HLpmv/RHBP/jyY=;
        b=bXDaoXGt2yJTDLXiCvsyfsdN0wvuN8ey1CXdQPI3RSL88HBV3/93wCZD3bUbJ2s5B5
         p5AfPWK9j4k7XCkvjipbbCqZK1K4CCGW63Rk8USW94SrjC9kP8jKAD9ngmlUEckPtUXj
         TPrV7Pc+8TOrWsQ/wv8WJqsGc1+RiktThbO7YfRwyoWLp3n6nBqKRyJQEIzcuAHVkp2e
         WBcOVfCxNvWSsRO2hVJZxohP8t3cwRptwwd3cdCu4brq8qD6Eu19emYAUad/homJ5FjC
         p3Re/eO/gsHjUSf6Ci9O1UsV+/ISyGo7wGTDNwokbyh4VAbpZCjl9W+jh7aBag2JauTV
         fMlQ==
X-Gm-Message-State: AOAM531f/p8RPedgzTFK+6GYSdX4Gr8tWxlbXB7KTbDVQjjhLbbIfaGi
        3w2iDpN7xJRO3c5QI6CD59ESBcOhmg==
X-Google-Smtp-Source: ABdhPJxueensrIMi2TLmxN//NgzFa8XCyszDo0/cMO2i5wuOY4XxxhenZ7kXNP33ORay9EdxrBOtrQ==
X-Received: by 2002:a17:90a:d496:: with SMTP id s22mr6488131pju.167.1599201286095;
        Thu, 03 Sep 2020 23:34:46 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id l22sm5499182pfc.27.2020.09.03.23.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 23:34:45 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/2] samples: bpf: add xsk_fwd test file to .gitignore
Date:   Fri,  4 Sep 2020 15:34:34 +0900
Message-Id: <20200904063434.24963-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904063434.24963-1-danieltimlee@gmail.com>
References: <20200904063434.24963-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds xsk_fwd test file to .gitignore which is newly added
to samples/bpf.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 034800c4d1e6..b2f29bc8dc43 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -50,4 +50,5 @@ xdp_rxq_info
 xdp_sample_pkts
 xdp_tx_iptunnel
 xdpsock
+xsk_fwd
 testfile.img
-- 
2.25.1

