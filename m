Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F72D3947C0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhE1UHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhE1UHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:07:24 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C49C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 13:05:48 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id w9so2500926qvi.13
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 13:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=IgP51dkKJZpY+EAFzr7Ft2GGe4ayl/EhBJOYxx2KMvM=;
        b=VeObcVN/LSPnVRmF7PIoMf/L9TORCRQ2llcg6KcPc7OxaWPDGTK3sM0h8e1tNJFEtq
         1OwoPFm5J1B5vqw8M6wsFdKMjDMlZi4oo9AGZuFRdBChuNwoo6cVn8o9hWJuFmOGR/n8
         32RO7y4ei/3UKmlusOT6uTHs0qpsbYidSoOP5CYQjMK58CIlfUK+WMnWsR8RmZgNV0TV
         gAsI8Tw+9WIFF8kql7LPUxNJYPECpjfczCKQmmH/2X56oY6SpDu4ZJY/Bz7XaZRcLxJs
         1atMxq8JKGQlQiF0sUgWt4UvXfaj07fqjqrvj0m1xbY85eyVn5EYmC3SxysGa074UW4S
         8r4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IgP51dkKJZpY+EAFzr7Ft2GGe4ayl/EhBJOYxx2KMvM=;
        b=V664FAXCg9hdiJap9mYvdUAQGJqxBPwdhDQCSTouxG5IDlF6WcEHz+3m9vYhkK3Ob/
         aos5Gac2uxWe4sb0PAOy8l/NndYuy6Gm/saSLJvfU7BOjnaTk+ApiZXLJrPnidZPJfpx
         /2G0c82+JNYXfAzH1GZ7QrLCPqciz1K35rEPhbcgp3Hftx6fMbsRwwWR0EuwWaU/dOeC
         2AT4e2SFuSJ9a96PdlvN0QImhX/Xwl5g8PiapeN0ZDe1iECavBRuUm3R3DVwCVc/077s
         YEw3XM5cNZ674bBIRFFhlGzCTvx5yQ6Q+Hrxv1DoxcwKHMgDik+QxerhytXjKeDj/2I2
         yuzw==
X-Gm-Message-State: AOAM533rOk6F48PLLqhcGhDdPlfxjlUJf9Xyp5WlAgsgpKxv4s/FeKFq
        LZ8TpeO8zm/yq/8U1mhVVRoGkv0ablwdcA==
X-Google-Smtp-Source: ABdhPJyrjmAVH8MqIaMAmGhET/FQ3Mlu36R44EXxsl73BwSOGZeW6OYxZwrXw/xVun0Mfx30ujGv8w==
X-Received: by 2002:ad4:5804:: with SMTP id dd4mr3901458qvb.42.1622232347433;
        Fri, 28 May 2021 13:05:47 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.27])
        by smtp.gmail.com with ESMTPSA id b2sm87094qto.89.2021.05.28.13.05.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 May 2021 13:05:47 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 1/1] ss: update ss man page
Date:   Fri, 28 May 2021 16:05:21 -0400
Message-Id: <1622232321-8154-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'-b' option allows to request BPF filter opcodes, however
currently the kernel returns only classic BPF filter, so
reflect this in man page.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 man/man8/ss.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 42aac6dee83f..d399381dd73b 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -343,7 +343,7 @@ and is therefore a useful reference.
 Switch to the specified network namespace name.
 .TP
 .B \-b, \-\-bpf
-Show socket BPF filters (only administrators are allowed to get these
+Show socket classic BPF filters (only administrators are allowed to get these
 information).
 .TP
 .B \-4, \-\-ipv4
-- 
2.7.4

