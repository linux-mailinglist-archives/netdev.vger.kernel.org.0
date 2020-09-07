Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FD326048E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgIGS3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729953AbgIGS3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 14:29:25 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8426AC061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 11:29:25 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e23so19291493eja.3
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 11:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMttToVBk526x8/p8GkvcnlJLP3o3Ezok0kTyz/Xrdk=;
        b=rtwbfM9RV748vffqYirEXeJoPYPRbFyX1HyeXCET4+7+6wv4VP4AJw8Ls7NFtkswZ+
         PAzDopbHhvy6vNsm+zWSUmgiWIw0HunYf/HeRzuH50FR4KVcBsxpxb/OmxsRGJdt1b8e
         qvUVu3i+QteCJcVOOGBMKC2iKVTtV4QNiCDJ7VK7e6a+GIM+CeA5+ZvSdpXmoT6rOCOl
         CoVur4aa2DHvwvK0UZ9XTfuPkDBV00xxY61PHG7GiHmoMTzsYm3qJoy7WdwI9x/Vehc/
         m8DyVLip7tgEYBtuBIV6RVJzkkGXTJN1O7Uxap2D4Ti2wJ8ZAPikPHpO0QpbPdbsbm5k
         Jong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMttToVBk526x8/p8GkvcnlJLP3o3Ezok0kTyz/Xrdk=;
        b=D9n6hSWnzpIb/N1dJDoN30ftjAwrWF4XzwR9oq6I+EM2YrWsZrqcyX3bQqygzPetuS
         l7n12JzYhdDjCVCRLJt506MP3MYjC9LsfsD1CvsJH8+B29x8SZCXe2N/mMC1eCYkSxO+
         xmWJ17OOr912YO0WyL0bsuaNc6W1fx/6QnyigY8Nx7LKJM0FLbGxGCw66IENPNSff+/X
         +3vdOTXKWCEg17b22WLeYDZiAUU//lsmf4Ap7Vm3LI3gqpYWka/pRbVDVGQubUKSx3JQ
         O8SWGj8KSblsb6GZAWeI4zwfsfltC4eaFhWsitINTBKj2ZRvK+eJxo/Gobn+XKmtQevH
         1nuA==
X-Gm-Message-State: AOAM531Tg6BMDKdP155WM5DWdlASxZg3n6knrohDDCSrhTMqb312n/r5
        kbjIhjGyqYlzlZJT/h+xE7Q=
X-Google-Smtp-Source: ABdhPJyE+CLHwCUDMvW6OPbasGApUV524Yx4cyvhHXfNAiFHCFEb9b8U6dhAcIdoby0pcv2spfrpaA==
X-Received: by 2002:a17:906:3a0e:: with SMTP id z14mr555825eje.192.1599503364144;
        Mon, 07 Sep 2020 11:29:24 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g24sm11746816edy.51.2020.09.07.11.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 11:29:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: dsa: tag_8021q: include missing refcount.h
Date:   Mon,  7 Sep 2020 21:29:07 +0300
Message-Id: <20200907182910.1285496-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907182910.1285496-1-olteanv@gmail.com>
References: <20200907182910.1285496-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The previous assumption was that the caller would already have this
header file included.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 311aa04e7520..804750122c66 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -5,6 +5,7 @@
 #ifndef _NET_DSA_8021Q_H
 #define _NET_DSA_8021Q_H
 
+#include <linux/refcount.h>
 #include <linux/types.h>
 
 struct dsa_switch;
-- 
2.25.1

