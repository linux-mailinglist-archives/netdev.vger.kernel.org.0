Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236E7252A42
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgHZJhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbgHZJfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:09 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA37BC061358
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:35 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so1110994wrw.1
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wOk7+v5tRA8kQkojRiep+oFsY19pnrxzjDBrN8NxzU0=;
        b=oROYULirz7RycKlFmz17ODwkIRUf3Ag8qwgHItHR6BX/j/SEk6NQew0g/BRgEMzKRt
         tt5Jo4BYLTEgPjhR8lr8ljhURcObcNyebw4VhcIRTD8tNDzT+tN9XWFK/g1IEDDze0lo
         cVcmlCZWZ3+6bIsZPPUPS6/6TB7U+uwepRDGIDC6wHM5H0TXN7N+u6megW0Hfk/fhUh9
         7ay25LPBDBt4KObWLrnNxDdAtrhYcz0n+4RItNhX+gnxbxzecxQt4SWzH3BOKu5ViVg0
         KQqLjd3R2nlk95hbvc6xpBfj9zdeQaaNiOxwWcq04YmdmBtGeOwgHTAtW9TERdqwx4W4
         y2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wOk7+v5tRA8kQkojRiep+oFsY19pnrxzjDBrN8NxzU0=;
        b=C9gmQZWRH2MNYKYBGwJoUFgSMyOZ7CIMvps3PhC0IWhWuGUBFj5LcYy66RKFzYX76o
         8G/R1lHlDvsueWjcGs4fqYcsI+FXgldST8MfCDCJdBXGd0H6lrdHWa1Ny4rfQT1i2occ
         +JjtraQP05HONEndbgC1YKaQvpofZsxHpYjk3h0OmqMvk6KOF0Z3XceqCsHYvaho++Fd
         vWRSFD1os++Io4+cat2DPFbu4AUWBNf1J0bnzWB7XnB2DSgLiC7s7pJJYKYQbsD4N/L/
         UIzRYNdmV5GBexqg3uHRcnC5+t+QTVqECuVD7aLYoly6ql+Hy1A/Ga3Xmoq/9QqDSBMg
         IujQ==
X-Gm-Message-State: AOAM530SowIIWSrMWSNNE4Qd8ruGw4KaXd1NoSjaRaXOWLuRIpc5dWQc
        tTqH8JlZWlapYkcYzco/frU4YA==
X-Google-Smtp-Source: ABdhPJycFcwRj1JjehKwx0tcqJuFWgg2Bt6DGFQBYF0/uRC61ugktaO9SXdUglT0sloncVXp09skjQ==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr15018301wrr.345.1598434474431;
        Wed, 26 Aug 2020 02:34:34 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: [PATCH 24/30] wireless: marvell: mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as __maybe_unused
Date:   Wed, 26 Aug 2020 10:33:55 +0100
Message-Id: <20200826093401.1458456-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'mwifiex_1d_to_wmm_queue' is used in'; main.c, txrx.c and uap_txrx.c

... but not used in 14 other source files which include 'wmm.h'.

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/marvell/mwifiex/init.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~
 In file included from drivers/net/wireless/marvell/mwifiex/cmdevt.c:26:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~
 In file included from drivers/net/wireless/marvell/mwifiex/util.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~
 In file included from drivers/net/wireless/marvell/mwifiex/wmm.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~
 In file included from drivers/net/wireless/marvell/mwifiex/11n.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~
 In file included from drivers/net/wireless/marvell/mwifiex/11n_aggr.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~
 In file included from drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~
 In file included from drivers/net/wireless/marvell/mwifiex/11n.h:25,
 from drivers/net/wireless/marvell/mwifiex/scan.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 | ^~~~~~~~~~~~~~~~~~~~~~~

 NB: Many entries - snipped for brevity.

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/marvell/mwifiex/wmm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.h b/drivers/net/wireless/marvell/mwifiex/wmm.h
index 60bdbb82277a3..58bcd84b050c5 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.h
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.h
@@ -31,7 +31,8 @@ enum ieee_types_wmm_ecw_bitmasks {
 	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
 };
 
-static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
+static const u16 __maybe_unused
+mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 
 /*
  * This function retrieves the TID of the given RA list.
-- 
2.25.1

