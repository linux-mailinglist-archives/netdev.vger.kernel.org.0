Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B737849F33C
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346270AbiA1GFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiA1GFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:05:39 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D01EC06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:39 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id q19-20020a056830441300b0059a54d66106so4863461otv.0
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ppn2aW3TH8sRgl0VGZ2oD3kIf/5HQfLl2F2c6WTuJ3I=;
        b=nEnUr8HwIzgyQujlX2Fl/A38m8eJ+wnWjy/wkt9SWMOHEzKkN6fMZSR2WrelXUpq3P
         kLe/JU6IFQTRUFRtwwJdNHtydPXUl7xuasIFsgbmueremqO1xrl5CSpqgvX5PV6vsBtU
         spyvGWbScRs8m7vtZKCiZcgLvxBv6EQtR1Mwahms2AECiuYRk3hgZj61YX+NGEbxzR1l
         5CYwDJDgluE/Ryh/n/Jm7VckPN18KFym9/CI2q+w7VlwZrejTMprqHl2i5+P3b6E8tvF
         XkzilchEaoOhuUSWQW4tv6T4QGc4tsG9eTvjrXGxPHyXdZyP+j8pIEsy322nvlCFTR9h
         3Irg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ppn2aW3TH8sRgl0VGZ2oD3kIf/5HQfLl2F2c6WTuJ3I=;
        b=nLxzC3vCC9zE3SkPOTuWuhkPmg+40kdfxDfLylBQrekJ48BncNFgcq+fbG70beZCJV
         ZoBjEFj9iqORLyBS852a204HNwYbmxw9kAExbDNdi3aghpGnQva/2K9NDWCATg9AbTmi
         E+Z/27UZd+jF2qkOfiA7LZrFz6Klnb7+4jrjukUUGP3oXRM4S/39aX7VnVfH4Pir8tOL
         /niAmww5X/zxcwyl16hvRPgMzfoovS6A0xlQ0b3V7PYriYM1JlVvCHFzeXlhSacZ7ICF
         74Mnb7AuiGUaLCY1DnR6DBNsd1vuy8eAd28NZFgBuy5x+gYGKKpjtCXMiPUrhF9d/ybB
         q02A==
X-Gm-Message-State: AOAM532e4I9XmRdxUHBrY8nqupVGOg8SFG/oNPd9LikVi1EmuYFaMPr3
        TA6VZ3MnB0ndMN/NrpfrZvT1YRwWfkQHtA==
X-Google-Smtp-Source: ABdhPJzYJJhugT+X/vHlMiaLU7fG8hHuI234ldkIgIkjow+kOOwQQZ20yY8mdM7K9RiqYGs7U79c3g==
X-Received: by 2002:a05:6830:33e4:: with SMTP id i4mr4144543otu.260.1643349938571;
        Thu, 27 Jan 2022 22:05:38 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:05:38 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 01/13] net: dsa: realtek-smi: fix kdoc warnings
Date:   Fri, 28 Jan 2022 03:04:57 -0300
Message-Id: <20220128060509.13800-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed kdoc mark for incomplete struct description.
Added a return description for rtl8366rb_drop_untagged.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek-smi-core.h | 4 ++--
 drivers/net/dsa/rtl8366rb.c        | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 5bfa53e2480a..faed387d8db3 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -25,7 +25,7 @@ struct rtl8366_mib_counter {
 	const char	*name;
 };
 
-/**
+/*
  * struct rtl8366_vlan_mc - Virtual LAN member configuration
  */
 struct rtl8366_vlan_mc {
@@ -74,7 +74,7 @@ struct realtek_smi {
 	void			*chip_data; /* Per-chip extra variant data */
 };
 
-/**
+/*
  * struct realtek_smi_ops - vtable for the per-SMI-chiptype operations
  * @detect: detects the chiptype
  */
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index ecc19bd5115f..4f8c06d7ab3a 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1252,6 +1252,8 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
  * @smi: SMI state container
  * @port: the port to drop untagged and C-tagged frames on
  * @drop: whether to drop or pass untagged and C-tagged frames
+ *
+ * Return: zero for success, a negative number on error.
  */
 static int rtl8366rb_drop_untagged(struct realtek_smi *smi, int port, bool drop)
 {
-- 
2.34.1

