Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430993129B3
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 05:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBHEQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 23:16:52 -0500
Received: from m12-14.163.com ([220.181.12.14]:37843 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhBHEQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 23:16:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=3PjaSyTPIF/0eA0o6d
        2SeGzWaUYGs51QsvtN6khf1pE=; b=QlscQxfQYcjauD2p8tY0SBGqexmoXtdBDm
        C+QVwbzMOMBr0vaC1c7+3EmezDraM12EyrjIB8cstwGXYrVHyYRtUGCZ8/cJ9JGF
        ki7jfbhluAuw6OCt1jw8rmZZ4vsDPqmbnYJU728GuDljyOJG7aVETd0XJAuMKWPC
        Y67im/QbQ=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.53.134])
        by smtp10 (Coremail) with SMTP id DsCowAA303CepCBg1rL5jw--.655S2;
        Mon, 08 Feb 2021 10:40:32 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH RESEND] rsi: remove redundant assignment
Date:   Mon,  8 Feb 2021 10:40:29 +0800
Message-Id: <20210208024029.24412-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowAA303CepCBg1rL5jw--.655S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWxWF1kZw1xWw1fKF4UJwb_yoW3Krb_ur
        10qF4fWrWkG3W8Kryj9FW3Zr9Iya4UW3WrGw4qq3yfGryUtrZxAw15Crn3J3yDG34jvr9x
        Gws7uryIva43ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeg6pDUUUUU==
X-Originating-IP: [119.137.53.134]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiHQAzsVSIpToy4wAAsN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

INVALID_QUEUE has been used as a return value,it is not necessary to
assign it to q_num,so just return INVALID_QUEUE.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 2d49c5b..a48e616 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -193,8 +193,7 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 		if (recontend_queue)
 			goto get_queue_num;
 
-		q_num = INVALID_QUEUE;
-		return q_num;
+		return INVALID_QUEUE;
 	}
 
 	common->selected_qnum = q_num;
-- 
1.9.1


