Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBCA33A96A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 02:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhCOBt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 21:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhCOBtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 21:49:16 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACFAC061574;
        Sun, 14 Mar 2021 18:49:15 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id m7so8126624qtq.11;
        Sun, 14 Mar 2021 18:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v5C1FzAc3n+Q+DivoMRN4HMo2xYIzd9PmibOkkmSFMM=;
        b=qfxYsDiUCXCn2YMPNV3ILEn4qTBRXy3TmHhuQxOVq3khLZh8Hfbw0sJ2nXZVN8LX68
         2MXIrvXxo2B6ijIlTTV4biVg8NH4ijLrAntmxqx1ucJr9xY2JWmpxs1FGUyvz+zrnjtm
         siivPv+cM8HkBDT/QFdO5LmJZTxlC/lp75OsM55BdxC9VtjVdoe8JnGfK3+9poIHQ3WG
         MsvbyAMsH6rskCJgOjqHZRn0UjMKegWJUOksBBO78AGVR/iWY80Xjwzi2btTRy79NlTh
         oq04YuxmpgmNvM4q+uo3GBlE0Zt0jVky6wTu9S6fz0hAB8WrA5+wz5ktxUVnxWIZWBoO
         zbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v5C1FzAc3n+Q+DivoMRN4HMo2xYIzd9PmibOkkmSFMM=;
        b=CrZCSpOzFLIqo7lbiv37p1z3PtM/mBAJ7wCE2s+E6DxPe3mMiM+Ao1abaNVJxpuysu
         IvPjPvZlKyX7suJuR7Rxy6lgCj55NvOSGOKdqNCScm8oRXdLe/k4JnVY4C7csBtG95Gu
         B92pwij4z2DiqSribNqXGqfcFfigOHz1L+rvkZanNVUb96PLG0tYJrUfondoUcoG9Njt
         +n+wjQZBYwnrijwPiv1MNRnT7Uu8eSjviK6zGgqLY0ElTEN1XQN9AAq5CIJIZHj3P2kJ
         0ZGS4ir+KTZhLcceXW2bwz2f5VGdco3qPUrwxyqXueONG4S9unIxA0qvEU7ydPcLe9HB
         sE+Q==
X-Gm-Message-State: AOAM5325FmBMw2Onhlq3TPnY2qLSaJ7DVdApJxIeNlX7BHX3R1KVnA9e
        tOlV1+v9+xUkA1XX8+DBTlc=
X-Google-Smtp-Source: ABdhPJxauSh2np1+DiEgowjAKvrGN9eiA811QseMjJ28g+CWSg10+3Cl+N0LksmkC6ssrKOS/DKFsw==
X-Received: by 2002:ac8:4b6d:: with SMTP id g13mr21011158qts.369.1615772954902;
        Sun, 14 Mar 2021 18:49:14 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.69])
        by smtp.gmail.com with ESMTPSA id z6sm9944662qto.70.2021.03.14.18.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 18:49:14 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: ethernet: intel: igb: Typo fix in the file igb_main.c
Date:   Mon, 15 Mar 2021 07:18:47 +0530
Message-Id: <20210315014847.1021209-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/structue/structure/


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03f78fdb0dcd..afc8ab9046a5 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3115,7 +3115,7 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
 		return 0;

 	/* Initialize the i2c bus which is controlled by the registers.
-	 * This bus will use the i2c_algo_bit structue that implements
+	 * This bus will use the i2c_algo_bit structure that implements
 	 * the protocol through toggling of the 4 bits in the register.
 	 */
 	adapter->i2c_adap.owner = THIS_MODULE;
--
2.30.2

