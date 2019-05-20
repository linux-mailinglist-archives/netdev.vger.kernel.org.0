Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9931E22B1B
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 07:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfETFXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 01:23:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43944 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfETFXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 01:23:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id t22so6170432pgi.10;
        Sun, 19 May 2019 22:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y7ZsJ7M69axo8UKSCozRvOH3tnMtWuejv94ZVramP6w=;
        b=usm8wQMNdzjZB+l6nd/d0ORDrW+TAPL82hhxIddbmP3cYWXw9qs2wXwnzs4p6RiJw1
         +/gdBmgJxxjOeqBHVWIXl4xfUnl6FhM7rTQkDJSR0742f2oWKFW7miKib4mYXxxAcZG7
         fhOQ4z/CAeikHPbrTs0g5LoZ08gkPD2gTnB8qhmd+Lnrjoj9kOk+p6bNToTgMxQb8Qfs
         8TQ8B0+NLJzhSIhJz1VJRvunWSbtjIhFaW4CaiLnRNa9q0YfcFkRETGIA9HFAN9kptj/
         0xmUPWyvBigWxKASjjgiT1kYdPTOF050jAUXz4ffCTOe6AV5bfPuSpEpKYQ2tjdm/xfX
         4YxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y7ZsJ7M69axo8UKSCozRvOH3tnMtWuejv94ZVramP6w=;
        b=KDJCmNl44kL7r33QIKX81mXpwd9N0khLX0cZT/vwVgZO+6yhTQypNWDX4hR6NQ5kqD
         b/gLbbJ6C+mydAuadLt2SXYIXG8fNyFZ3bmpY68Qk6tYXVDvACJF/NSZkk+urrutoWEy
         LBEoiZ2i7vd3BOPhWIqqo1Q3b1rW6OaMRo45dZOKkEVum4E6mXttsxGE87qKbApaGD0i
         w1O6DWYUldF6Rn7pgKpvLO5uHNGSu5Zdo8GZm+4j1QxbedCzPS8ksUWQuMrku+zRUqux
         RkNOxaLAvldU7t8SXglCcpFEst9EjSzdp/vUuWef2AHChTsvjafBtgaldsmNhj4AnT9F
         9EpQ==
X-Gm-Message-State: APjAAAWdzWr3THtwxmG7sSbuwO8KPAWYlRiX8J53s4yV2v4SG7y1H7A8
        WE7biBFKM/uK2P48tqRzRj4=
X-Google-Smtp-Source: APXvYqxARzCoDPWyje1XFLKlr+mnGu94stmycRegc+EF5IVhpI0UmKvFwt8hFKBOO68hK8MLV/4JYA==
X-Received: by 2002:a63:9d83:: with SMTP id i125mr67552518pgd.229.1558329801284;
        Sun, 19 May 2019 22:23:21 -0700 (PDT)
Received: from localhost ([43.224.245.181])
        by smtp.gmail.com with ESMTPSA id q27sm24714424pfg.49.2019.05.19.22.23.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 22:23:20 -0700 (PDT)
From:   Weitao Hou <houweitaoo@gmail.com>
To:     davem@davemloft.net, corbet@lwn.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Weitao Hou <houweitaoo@gmail.com>
Subject: [PATCH] networking: : fix typos in code comments
Date:   Mon, 20 May 2019 13:23:17 +0800
Message-Id: <20190520052317.27871-1-houweitaoo@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix accelleration to acceleration

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
 Documentation/networking/segmentation-offloads.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/segmentation-offloads.rst b/Documentation/networking/segmentation-offloads.rst
index 89d1ee933e9f..085e8fab03fd 100644
--- a/Documentation/networking/segmentation-offloads.rst
+++ b/Documentation/networking/segmentation-offloads.rst
@@ -18,7 +18,7 @@ The following technologies are described:
  * Generic Segmentation Offload - GSO
  * Generic Receive Offload - GRO
  * Partial Generic Segmentation Offload - GSO_PARTIAL
- * SCTP accelleration with GSO - GSO_BY_FRAGS
+ * SCTP acceleration with GSO - GSO_BY_FRAGS
 
 
 TCP Segmentation Offload
@@ -148,7 +148,7 @@ that the IPv4 ID field is incremented in the case that a given header does
 not have the DF bit set.
 
 
-SCTP accelleration with GSO
+SCTP acceleration with GSO
 ===========================
 
 SCTP - despite the lack of hardware support - can still take advantage of
-- 
2.18.0

