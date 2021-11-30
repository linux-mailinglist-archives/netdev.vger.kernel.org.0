Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45FE4631D4
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbhK3LMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:12:15 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:38910 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235837AbhK3LMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:12:15 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 4J3KGc1PTFz9vKYH
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 11:08:56 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mB-kKzFNY0b0 for <netdev@vger.kernel.org>;
        Tue, 30 Nov 2021 05:08:56 -0600 (CST)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 4J3KGb61nlz9vKY2
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 05:08:55 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p8.oit.umn.edu 4J3KGb61nlz9vKY2
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p8.oit.umn.edu 4J3KGb61nlz9vKY2
Received: by mail-pg1-f199.google.com with SMTP id r35-20020a635163000000b0032513121db6so7128798pgl.10
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 03:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L4d1W48kwHHShV4SEtnKYtW4rYy9ZnpgrsWKK2v2g6k=;
        b=GtUW2K/WOpbVkir7I1Tp3FYTarK7YibkN6sNrEotnvhlY9v5OkC6trHYw/B6W6GjNZ
         4QDcoIiSn2o2iY7sELuG/ejW1DjHwKq1RYQVQbSNIJ18HagJl369LgtwiHS69lr/OWGc
         T9klLrFg/3MncZKUeJdY/41Nas3lB1ZKkmi6o0b17UpILbv1gUq3KQhRhVdTq7ILe1UQ
         zd2T9i+Shr2di+mwZKL2sfYUGLgkWXi+38tyEylmcQsJ906rVrb3hH9PkJUybA6jRDf1
         66DsXXSuyZu/3SQ4JzMMN/tXeMdQW1XDcmv1O/Fw5YSblxekSdVUFaMQ+a8OokZdhSIk
         t//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L4d1W48kwHHShV4SEtnKYtW4rYy9ZnpgrsWKK2v2g6k=;
        b=eBWtLnXCyrXW/lo62aURpilxY4AbETQd8iqlnb3T9gkewYdMrgvdWMKDv/Dvezbtkp
         imjyIgMVs9dDtS2MVjRF335uCtTdQcYnFPrM1c9cYeSOun0ahYEj2QBIB/LHsr25tgWM
         oVwJKF7UdjUJQ1BUXRs6yBqlJZXDNq6FWr8CnIy+6DzrvUTZBr8R3PBAq0cx4aAKayth
         Sp1x/9wChE5rQO9VVALOcEOzqQteRqQNHkeOFSa/giWgWCu8kwa325DMxka57MrNDj4C
         DG1EvRphiSZOWH1ssPTpH204+hZkbqieWJ4MSid878WT/VpO6HdxI07AZ7nWmGhCACz/
         SUyw==
X-Gm-Message-State: AOAM5307xI2iXc5zNhkQbAZ9h6CmrYodgjfhYQZtO/eh3dUoAimXmw+J
        O3EfdD0ymy6ThSUCQ7rfvo+VxO+3nUbUUs3PchLklUxeOKuTyrvCfPuLq2/vDgNabviSz1kT05L
        +pBmw68KRtFVeTjk3OJx/
X-Received: by 2002:a63:5204:: with SMTP id g4mr12856348pgb.319.1638270535170;
        Tue, 30 Nov 2021 03:08:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhQMDrKlRy9nZ2NlLQm9ytvcBmwZ3NlEtd489Hx6S5Lk90kMvYdn8hmVlN3kWuCXwOlhER/w==
X-Received: by 2002:a63:5204:: with SMTP id g4mr12856329pgb.319.1638270534953;
        Tue, 30 Nov 2021 03:08:54 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.7.42.137])
        by smtp.gmail.com with ESMTPSA id u38sm23783318pfg.0.2021.11.30.03.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 03:08:54 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Sritej Velaga <sritej.velaga@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] clk: mediatek: net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
Date:   Tue, 30 Nov 2021 19:08:48 +0800
Message-Id: <20211130110848.109026-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In qlcnic_83xx_add_rings(), the indirect function of
ahw->hw_ops->alloc_mbx_args will be called to allocate memory for
cmd.req.arg, and there is a dereference of it in qlcnic_83xx_add_rings(),
which could lead to a NULL pointer dereference on failure of the
indirect function like qlcnic_83xx_alloc_mbx_args().

Fix this bug by adding a check of alloc_mbx_args(), this patch
imitates the logic of mbx_cmd()'s failure handling.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_QLCNIC=m show no new warnings, and our
static analyzer no longer warns about this code.

Fixes: 7f9664525f9c ("qlcnic: 83xx memory map and HW access routine")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index d51bac7ba5af..bd0607680329 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -1077,8 +1077,14 @@ static int qlcnic_83xx_add_rings(struct qlcnic_adapter *adapter)
 	sds_mbx_size = sizeof(struct qlcnic_sds_mbx);
 	context_id = recv_ctx->context_id;
 	num_sds = adapter->drv_sds_rings - QLCNIC_MAX_SDS_RINGS;
-	ahw->hw_ops->alloc_mbx_args(&cmd, adapter,
-				    QLCNIC_CMD_ADD_RCV_RINGS);
+	err = ahw->hw_ops->alloc_mbx_args(&cmd, adapter,
+					QLCNIC_CMD_ADD_RCV_RINGS);
+	if (err) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to alloc mbx args %d\n", err);
+		return err;
+	}
+
 	cmd.req.arg[1] = 0 | (num_sds << 8) | (context_id << 16);
 
 	/* set up status rings, mbx 2-81 */
-- 
2.25.1

