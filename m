Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FCD469148
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239005AbhLFIRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239033AbhLFIRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:17:34 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E574EC061A83;
        Mon,  6 Dec 2021 00:14:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g18so9461893pfk.5;
        Mon, 06 Dec 2021 00:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QKxPerJUW5xKdsM/yyWUqSHmdveNx4qXZufZHcOkhIc=;
        b=FyqB6NKQcU4ZE95OvCmSoGXQP7/jROCUXH4kjLICmwX+LB3xMCrr2S/mF6eAZIfTfM
         NCrM7A09GguKAJfjFo3ehP227NBjmUuubfgBxwxbx27oEXmDQc0sLSq7jchlszbbkZvV
         6+OcDsMfQsYKL3zaHGtnDLvD+8AJftGdZR7PK2FEBeNPWj/rMLJzMh1LYwFCnKFA16/Z
         mxFrfcFO8bfnuZs7sh09FlEZPHWYOefuRs94OvlKxnBJkpLe5w6ey0HuLlYyuGyXdqL8
         g12i7S3CIjT7S7TB6h5ys0232RhE+CyzVz+GDybHZSmx+4GJIPlBKcraxGyvlFhkiNH0
         HiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QKxPerJUW5xKdsM/yyWUqSHmdveNx4qXZufZHcOkhIc=;
        b=14wZ4h4SP12sD+vwz+U63eOdSm46qoQRQ3Zg0Yh6Wo2G/yfybvI4qjB81VIhT6CUYV
         vNRG8VxksMIKyKYigPLvP5w40Gj9cPXxXyvzMB+n2O9Qel7gCTGCfj68w8SOE9DeKTrL
         eED/cVw4AsS4Qg4jGbLoxTOyTdc3EcUj+csn+36rHH4lSdDsaTFMEwfKx8DsHSgwZ1QW
         4vGm94XzAeS0WpfuBVqFukIlHJkaNg0+HdzrrwMosRPPUdCATKIoUEoqF4m8ABV4+sG2
         mR54SAIoWWs2BngO6GfdoZtg86fvepBJYoQhbs/Kd65Crxb/Di68IVveAmtcGhS0Mqm+
         XMKw==
X-Gm-Message-State: AOAM5332O/nfg/0KmnQU/0ld4N56tkrFDUNaur0c6Y4y3r5I4GDnj+/b
        Eo7URiIpqUPIyKo1p8ar4EI=
X-Google-Smtp-Source: ABdhPJz0c0/jh2b+wZ+k4wc9od7BPCGd3/WYc3GvnBebV6plSz28rGbvIKIgX+liVT+1aoxAhifMYw==
X-Received: by 2002:a63:7f4d:: with SMTP id p13mr17363027pgn.546.1638778444551;
        Mon, 06 Dec 2021 00:14:04 -0800 (PST)
Received: from localhost.localdomain ([8.26.182.175])
        by smtp.gmail.com with ESMTPSA id 95sm8999332pjo.2.2021.12.06.00.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 00:14:04 -0800 (PST)
From:   Yanteng Si <siyanteng01@gmail.com>
X-Google-Original-From: Yanteng Si <siyanteng@loongson.cn>
To:     akiyks@gmail.com, linux@armlinux.org.uk
Cc:     Yanteng Si <siyanteng@loongson.cn>, andrew@lunn.ch, corbet@lwn.net,
        chenhuacai@kernel.org, hkallweit1@gmail.com,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        siyanteng01@gmail.com
Subject: [PATCH v2 2/2] net: phy: Add the missing blank line in the phylink_suspend comment
Date:   Mon,  6 Dec 2021 16:12:28 +0800
Message-Id: <1b32000631c5709e8d8cc0b779c816ae4e595ab7.1638776933.git.siyanteng@loongson.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1638776933.git.siyanteng@loongson.cn>
References: <cover.1638776933.git.siyanteng@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning as:

Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1657: WARNING: Unexpected indentation.
Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1658: WARNING: Block quote ends without a blank line; unexpected unindent.

Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8e3861f09b4f..c26884a56354 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1653,6 +1653,7 @@ EXPORT_SYMBOL_GPL(phylink_stop);
  * @mac_wol: true if the MAC needs to receive packets for Wake-on-Lan
  *
  * Handle a network device suspend event. There are several cases:
+ *
  * - If Wake-on-Lan is not active, we can bring down the link between
  *   the MAC and PHY by calling phylink_stop().
  * - If Wake-on-Lan is active, and being handled only by the PHY, we
-- 
2.27.0

