Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC99013F9D8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgAPTsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:48:38 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35527 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730056AbgAPTsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 14:48:37 -0500
Received: by mail-pj1-f65.google.com with SMTP id s7so2146391pjc.0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 11:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7JA7OaAwygRJhFE5OhJzasHdhSSViUU13KIg0q1FSec=;
        b=Dru6MVnrzDSQhqIHA9hIc+S6OHXwFZ13mSc/MDV5EUflfFBwbF5yeXyvEMf64S4TWo
         oMNf8He6pzARNKhqgo427B8thWqGNzvD8YOlppZwxjoyQfdiyow/tajtNNvMEr0E+H9v
         6u8DavnxmR4PzUbLCPTFtDtO571XASTqrceV/wzQLBVwVUx/WHdXayDuHkZTmdZ86W7W
         EpESmGt/PHNb5q8AOAhSsfvtIFANOea2YiDumswBdsplBbBGKRbHV98ptdu1xpYuYkzg
         A7+KlE9j1CXoYXn2r0HM77LHQOcQ5zmjIWrXuG+Fe2B4R9Niw4XcB63Or5+6pPQE1oke
         PL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7JA7OaAwygRJhFE5OhJzasHdhSSViUU13KIg0q1FSec=;
        b=d5sbemdULWrsEUqw3x93pT6EtS67AFVl4BASLWIU9fpZMZAo/GPOFB/n/gczF3CEKj
         7lCHps4ivSo3dnfXmkAyodhD4D2XkCAXnKrACXy/6pzQxVLVVMc81PGIPTgIVq0vZ3NE
         1DxZrPvHa8UIWeNoFWc0IRZ3qHC1EnlRS56A9AfEscwcGfp6JzfZ4J3Zm3KeOzp7jwIj
         i8+tB5HzomYv9hZNBL9ywRNTGIT+BnCAhXeScwW8F7RhKTIBpcHxS1d/5LtLkOudYwrX
         1h1Er55kkfVuO79TSY0pGCBiiIh99iJW4bYDzRht7LhpOVNhUz1oNAXVydH/VQAqbET3
         RnAw==
X-Gm-Message-State: APjAAAU19OJByGxJMLZ04Cd3PKD9Bb7f2CJ20fBRxobfKFrwYIUF/gQ5
        JMvRF/NOXL4IXsLQfJRerS6XeVuXnw0=
X-Google-Smtp-Source: APXvYqzI8QoRH4xmbr0ohmIFDn4k4TVtDhR0x4SD6gbWhxXanm5f01R9RybidTeokqgTpJeSNyrHng==
X-Received: by 2002:a17:90a:a60f:: with SMTP id c15mr986122pjq.61.1579204116659;
        Thu, 16 Jan 2020 11:48:36 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j28sm26174623pgb.36.2020.01.16.11.48.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 16 Jan 2020 11:48:36 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 17/17] MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver
Date:   Fri, 17 Jan 2020 01:17:33 +0530
Message-Id: <1579204053-28797-18-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added maintainers entry for Marvell OcteonTX2 SOC's physical
function NIC driver.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6659dd5..73b510b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10002,6 +10002,15 @@ S:	Supported
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 F:	Documentation/networking/device_drivers/marvell/octeontx2.rst
 
+MARVELL OCTEONTX2 PHYSICAL FUNCTION DRIVER
+M:	Sunil Goutham <sgoutham@marvell.com>
+M:	Geetha sowjanya <gakula@marvell.com>
+M:	Subbaraya Sundeep <sbhatta@marvell.com>
+M:	hariprasad <hkelam@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/marvell/octeontx2/nic/
+
 MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
-- 
2.7.4

