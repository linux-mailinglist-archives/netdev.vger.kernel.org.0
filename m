Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1FF33A880
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 23:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCNWXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 18:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhCNWWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 18:22:46 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F196EC061574;
        Sun, 14 Mar 2021 15:22:45 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id x10so29985511qkm.8;
        Sun, 14 Mar 2021 15:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7B7xY3igOoJbuW3KheyCp4L18Qf+vEsDSRa9Nks3Dls=;
        b=cMZcYJiVipvWRlxXGEF2f2LSvPl1ZC7b1Cn+UGHLVs84KguZVKajFPzyEqNNGxPZUi
         R4R0m8MoC0VcgMInjtz3Mwcxa4EAvNdNv8Lw2AHnHm3hRURhK/WyM8OjXZrJy7fOteC3
         tDYkUToTZ7RF6Ie9OCgSNk9W96FYtm3lUUwCDbGtUJts7SWbVVBxc5o8Zlv0GAnJk9rA
         KQ88EvkFh9VZYRrdQ1v4Qj1H709O728XNGRN2FS67PSxKrfay/i955KkIa8qZohp3dOX
         5PsQ1W5IMbcgq0l+Gs0POGeScnvCcJJP+jHQGMyLtLUTPhy+Fe15Ezp/q6Yh9Hy/4XxI
         u5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7B7xY3igOoJbuW3KheyCp4L18Qf+vEsDSRa9Nks3Dls=;
        b=df2NZxG5L0ZgZtrvH/93OUIllOMM1hQW2UYmuuyeYFHfvlLARuft4+cFVLb8X7dcGz
         GJzTGwEdjHmKdQuJqJR2EHWJ2+sAfz5h6cyl9d3ZfTdVWqj6b4TX10lc/IPqKy9YVQwY
         OLQkQ4LIMTevlI8AcJxgdJEwXNIjZCh7u+1T1lF4+C4qtg4EhBPQ+8ed+HnycJz4JM80
         0oQc9IsGfXj4fiM03DIATx4W93g5e0ogETdpw0nB5zkwdNPr/UMOYZRnRkcvTSDzpRYf
         Lnz8qoFByChGcxplFP5vYDO70dkfS+vxWRZeg35mHkGLo5o7e/xWrQzudEtoyODsRAR8
         aeGw==
X-Gm-Message-State: AOAM533XIM1qq3VvHPunF9aQ6VHlqZeRtUofrxtpuWiI5ES0on5LGcXp
        E4z6GFQVVr2m7JfMc8+uzas=
X-Google-Smtp-Source: ABdhPJxbNsxlq8BOlKgoIMRCEg8x1jLDfzsdEjKYKxJlpj+BrPFV2gPIiUDMRmNrLpFiIfqOjMMDrw==
X-Received: by 2002:a05:620a:210a:: with SMTP id l10mr22171571qkl.398.1615760565142;
        Sun, 14 Mar 2021 15:22:45 -0700 (PDT)
Received: from localhost.localdomain ([156.146.37.247])
        by smtp.gmail.com with ESMTPSA id g7sm9778981qti.20.2021.03.14.15.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 15:22:44 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, davem@davemloft.net, kuba@kernel.org,
        shayagr@amazon.com, sameehj@amazon.com, unixbhaskar@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] ethernet: amazon: ena: A typo fix in the file ena_com.h
Date:   Mon, 15 Mar 2021 03:52:21 +0530
Message-Id: <20210314222221.3996408-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Mundane typo fix.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 343caf41e709..73b03ce59412 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -124,7 +124,7 @@ struct ena_com_io_cq {

 	/* holds the number of cdesc of the current packet */
 	u16 cur_rx_pkt_cdesc_count;
-	/* save the firt cdesc idx of the current packet */
+	/* save the first cdesc idx of the current packet */
 	u16 cur_rx_pkt_cdesc_start_idx;

 	u16 q_depth;
--
2.30.2

