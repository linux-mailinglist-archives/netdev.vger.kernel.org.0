Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B4780B81
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfHDPrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:47:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35797 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfHDPrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:47:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so70735556wmg.0;
        Sun, 04 Aug 2019 08:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=XpKZwopndEr+MAU5NPtSJHYcO6Ev0MiXZLBr1uT/g74=;
        b=XU5QG53d3+2crKQsbTdHoGONPn6CyVrAJXUf8YhuW3jwt3jQNVcwL0fkkD4qsI6q24
         iRlsjJFNqFjAk34GEB5i5ZsPAoK7cqv8xr3ardQdu3a9vwP92MMf/ROCAQO3yfSl5CYQ
         2JZfTKPbcmQd8/HUDYjUjfhlvLH34tg8FBgB81GOx2nkc13oLYz+ypMoIwMGKVfakLvi
         hg2+QMbP/eowocijrEJiHCjdm1p7XCaHVkavK3FcGPuESQCxl0tZAgiPZIxMoHYipia2
         YENHHfbhrj4DPU/oZHFHHLxreYtH61LP0TQSKY1rfJV2C5dhj1tnKZmqKZiT7vZcq1Sn
         u5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=XpKZwopndEr+MAU5NPtSJHYcO6Ev0MiXZLBr1uT/g74=;
        b=K9w+4lqS6MUJa74oyxJmoLIXgJ7/pn7LPDlx93jxN29u8K+yGVQyRBBlkpD3MPhhkx
         BHJGOj9cf/BqaqLREQxh7IrfMYBV1EnWZ0rwyE4gQbLWCSo37LihuOeV6HKvi7fpAqTJ
         z+hwvXHFqt6bS71qZvRoKUtg5fEHrjLq60vNUAdj7sZbrcMYC05zX6TGQ6BS0CBwuNMj
         /8FiRPjotFy77396AX2f1ZsfTJT7T2ewMIOYMBRdB17j4xP+dR54txFjpAKV1NEk8q/4
         PaEa0nitpRTeUXeSf3qRYUK2FNh4O+26PCE1z6Pg+aoAGkvnhslzETsFXAwKhVkAIyqE
         AWqg==
X-Gm-Message-State: APjAAAXUI63yiDAgzAJ61wSMkEPWpKC3A1BXvFRi0gilHRpiEmmEspsl
        MstbSRsbAmODy3R/tB/2aaU=
X-Google-Smtp-Source: APXvYqzJFuGB25ozI+29umWEdsL9Hgl2qPQJteoUcZ6uWqBwZ6hn5nsD/8MzEZeeH8OkXj4yd8zWVg==
X-Received: by 2002:a1c:f918:: with SMTP id x24mr13576652wmh.132.1564933666469;
        Sun, 04 Aug 2019 08:47:46 -0700 (PDT)
Received: from localhost ([197.211.57.129])
        by smtp.gmail.com with ESMTPSA id o20sm217192312wrh.8.2019.08.04.08.47.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 08:47:45 -0700 (PDT)
Date:   Sun, 4 Aug 2019 16:46:35 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: [PATCH] Documentation: virt: Fix broken reference to virt tree's
 index
Message-ID: <20190804154635.GA18475@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix broken reference to virt/index.rst.

Sequel to: 2f5947dfcaec ("Documentation: move Documentation/virtual to
Documentation/virt")

Reported-by: Sphinx

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---
 Documentation/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 2df5a3da563c..5205430305d5 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -115,7 +115,7 @@ needed).
    target/index
    timers/index
    watchdog/index
-   virtual/index
+   virt/index
    input/index
    hwmon/index
    gpu/index
-- 
2.17.1

