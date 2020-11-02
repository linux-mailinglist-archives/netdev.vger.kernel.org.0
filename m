Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97752A2967
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgKBL2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728670AbgKBLYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:33 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DADC061A48
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:32 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w14so14116299wrs.9
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L4fJoUFxGOk+wlfr5ygIh+H6VB2oPqLC6DAqdYBw8oE=;
        b=U01TdZA4ou+Nb33YQqS94KykKTScklcdisoNL0DDDIpnD65IVWVqxdDzAzh7Tg44nt
         jUhxnIHWA0PU5JsKht+nwohtNUzIJIJe+6CWAW4CHXGOQsMWnq42abCCxAUGK7DuNuHw
         PSxa44W40vAb6gRH7hv9ZxIjtEu+GQSdatDckaluWZ53w+SG/y9jBe0GyAW9DjN0ySU7
         X4ibisX6nxc48HcX8Bg+oo5VfU0OXAlJISmDWoM5SEju+RFWI8ezbbcUZF2GrJH85LXW
         TE1Gom/dqJW2TnEUzqWftY+oPyuHTzr+/G++eRgIOnSAVrjOMwjS6JEPjwVRR4iTdDom
         nfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4fJoUFxGOk+wlfr5ygIh+H6VB2oPqLC6DAqdYBw8oE=;
        b=DW5Fj2vPKp/OvkFcRuD/o0QgtznroxFqSgxzrkUHrrNENeax5cytgwS5DhqaMoCEHj
         iyzpFxjhm1wWnx/z3KR8Bda1wD3odODdKepYHS3oOGUN9TgyOEBDjAFIl9KblmxRwhhm
         pg7k6ZELLbpQR/4DxFNayLAQSL+UXQh5QG53ntlGQwoYKcF/dCnLODqWDiSUhgGswEvv
         n02ik7Q+O9Xs4uRJ+2aPPCv6zKqluXrDxmRBBt8Q3/ZdOIdAMbNz7TbfRlmdw4wtndxR
         qIGHO7WUH9SJsykPT89H3b4Xiu0n96OhDzUxun31HAbqZuA3WfQorZ3tuUmZntWICmlZ
         exEA==
X-Gm-Message-State: AOAM532GGfNYE9dQHiUlJi+DUajdO6pq6IfaA8d6ZQpFYyu17sveiorz
        EFhvQkEdX/hJpHIqKWJdhM9BMQ==
X-Google-Smtp-Source: ABdhPJzpHltc56zkt1lE0UmaN5fxaSG/K6DQJ9K+LHHIPVp1QiY+GlC3nuPqsKT4skW3MzFmzobCqA==
X-Received: by 2002:adf:b19c:: with SMTP id q28mr19225949wra.119.1604316271566;
        Mon, 02 Nov 2020 03:24:31 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:31 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/41] ath9k: ar9340_initvals: Remove unused const variable 'ar9340Modes_ub124_tx_gain_table_1p0'
Date:   Mon,  2 Nov 2020 11:23:40 +0000
Message-Id: <20201102112410.1049272-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath9k/ar9340_initvals.h:624:18: warning: ‘ar9340Modes_ub124_tx_gain_table_1p0’ defined but not used [-Wunused-const-variable=]

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/ath/ath9k/ar9340_initvals.h  | 101 ------------------
 1 file changed, 101 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
index 2eb163fc1c18f..3da4ea564148c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
@@ -621,107 +621,6 @@ static const u32 ar9340Modes_high_ob_db_tx_gain_table_1p0[][5] = {
 	{0x00016448, 0x8e481666, 0x8e481666, 0x8e481266, 0x8e481266},
 };
 
-static const u32 ar9340Modes_ub124_tx_gain_table_1p0[][5] = {
-	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8005, 0xd00a8005},
-	{0x00009820, 0x206a022e, 0x206a022e, 0x206a00ae, 0x206a00ae},
-	{0x00009830, 0x0000059c, 0x0000059c, 0x0000059c, 0x0000059c},
-	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec82d2e, 0x7ec82d2e},
-	{0x0000a2dc, 0xfef5d402, 0xfef5d402, 0xfdab5b52, 0xfdab5b52},
-	{0x0000a2e0, 0xfe896600, 0xfe896600, 0xfd339c84, 0xfd339c84},
-	{0x0000a2e4, 0xff01f800, 0xff01f800, 0xfec3e000, 0xfec3e000},
-	{0x0000a2e8, 0xfffe0000, 0xfffe0000, 0xfffc0000, 0xfffc0000},
-	{0x0000a410, 0x000050d8, 0x000050d8, 0x000050d9, 0x000050d9},
-	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
-	{0x0000a504, 0x04002222, 0x04002222, 0x04000002, 0x04000002},
-	{0x0000a508, 0x09002421, 0x09002421, 0x08000004, 0x08000004},
-	{0x0000a50c, 0x0d002621, 0x0d002621, 0x0b000200, 0x0b000200},
-	{0x0000a510, 0x13004620, 0x13004620, 0x0f000202, 0x0f000202},
-	{0x0000a514, 0x19004a20, 0x19004a20, 0x11000400, 0x11000400},
-	{0x0000a518, 0x1d004e20, 0x1d004e20, 0x15000402, 0x15000402},
-	{0x0000a51c, 0x21005420, 0x21005420, 0x19000404, 0x19000404},
-	{0x0000a520, 0x26005e20, 0x26005e20, 0x1b000603, 0x1b000603},
-	{0x0000a524, 0x2b005e40, 0x2b005e40, 0x1f000a02, 0x1f000a02},
-	{0x0000a528, 0x2f005e42, 0x2f005e42, 0x23000a04, 0x23000a04},
-	{0x0000a52c, 0x33005e44, 0x33005e44, 0x26000a20, 0x26000a20},
-	{0x0000a530, 0x38005e65, 0x38005e65, 0x2a000e20, 0x2a000e20},
-	{0x0000a534, 0x3c005e69, 0x3c005e69, 0x2e000e22, 0x2e000e22},
-	{0x0000a538, 0x40005e6b, 0x40005e6b, 0x31000e24, 0x31000e24},
-	{0x0000a53c, 0x44005e6d, 0x44005e6d, 0x34001640, 0x34001640},
-	{0x0000a540, 0x49005e72, 0x49005e72, 0x38001660, 0x38001660},
-	{0x0000a544, 0x4e005eb2, 0x4e005eb2, 0x3b001861, 0x3b001861},
-	{0x0000a548, 0x53005f12, 0x53005f12, 0x3e001a81, 0x3e001a81},
-	{0x0000a54c, 0x59025eb5, 0x59025eb5, 0x42001a83, 0x42001a83},
-	{0x0000a550, 0x5e025f12, 0x5e025f12, 0x44001c84, 0x44001c84},
-	{0x0000a554, 0x61027f12, 0x61027f12, 0x48001ce3, 0x48001ce3},
-	{0x0000a558, 0x6702bf12, 0x6702bf12, 0x4c001ce5, 0x4c001ce5},
-	{0x0000a55c, 0x6b02bf14, 0x6b02bf14, 0x50001ce9, 0x50001ce9},
-	{0x0000a560, 0x6f02bf16, 0x6f02bf16, 0x54001ceb, 0x54001ceb},
-	{0x0000a564, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
-	{0x0000a568, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
-	{0x0000a56c, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
-	{0x0000a570, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
-	{0x0000a574, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
-	{0x0000a578, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
-	{0x0000a57c, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
-	{0x0000a580, 0x00802220, 0x00802220, 0x00800000, 0x00800000},
-	{0x0000a584, 0x04802222, 0x04802222, 0x04800002, 0x04800002},
-	{0x0000a588, 0x09802421, 0x09802421, 0x08800004, 0x08800004},
-	{0x0000a58c, 0x0d802621, 0x0d802621, 0x0b800200, 0x0b800200},
-	{0x0000a590, 0x13804620, 0x13804620, 0x0f800202, 0x0f800202},
-	{0x0000a594, 0x19804a20, 0x19804a20, 0x11800400, 0x11800400},
-	{0x0000a598, 0x1d804e20, 0x1d804e20, 0x15800402, 0x15800402},
-	{0x0000a59c, 0x21805420, 0x21805420, 0x19800404, 0x19800404},
-	{0x0000a5a0, 0x26805e20, 0x26805e20, 0x1b800603, 0x1b800603},
-	{0x0000a5a4, 0x2b805e40, 0x2b805e40, 0x1f800a02, 0x1f800a02},
-	{0x0000a5a8, 0x2f805e42, 0x2f805e42, 0x23800a04, 0x23800a04},
-	{0x0000a5ac, 0x33805e44, 0x33805e44, 0x26800a20, 0x26800a20},
-	{0x0000a5b0, 0x38805e65, 0x38805e65, 0x2a800e20, 0x2a800e20},
-	{0x0000a5b4, 0x3c805e69, 0x3c805e69, 0x2e800e22, 0x2e800e22},
-	{0x0000a5b8, 0x40805e6b, 0x40805e6b, 0x31800e24, 0x31800e24},
-	{0x0000a5bc, 0x44805e6d, 0x44805e6d, 0x34801640, 0x34801640},
-	{0x0000a5c0, 0x49805e72, 0x49805e72, 0x38801660, 0x38801660},
-	{0x0000a5c4, 0x4e805eb2, 0x4e805eb2, 0x3b801861, 0x3b801861},
-	{0x0000a5c8, 0x53805f12, 0x53805f12, 0x3e801a81, 0x3e801a81},
-	{0x0000a5cc, 0x59825eb2, 0x59825eb2, 0x42801a83, 0x42801a83},
-	{0x0000a5d0, 0x5e825f12, 0x5e825f12, 0x44801c84, 0x44801c84},
-	{0x0000a5d4, 0x61827f12, 0x61827f12, 0x48801ce3, 0x48801ce3},
-	{0x0000a5d8, 0x6782bf12, 0x6782bf12, 0x4c801ce5, 0x4c801ce5},
-	{0x0000a5dc, 0x6b82bf14, 0x6b82bf14, 0x50801ce9, 0x50801ce9},
-	{0x0000a5e0, 0x6f82bf16, 0x6f82bf16, 0x54801ceb, 0x54801ceb},
-	{0x0000a5e4, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
-	{0x0000a5e8, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
-	{0x0000a5ec, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
-	{0x0000a5f0, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
-	{0x0000a5f4, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
-	{0x0000a5f8, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
-	{0x0000a5fc, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
-	{0x00016044, 0x03b6d2e4, 0x03b6d2e4, 0x03b6d2e4, 0x03b6d2e4},
-	{0x00016048, 0x8e480086, 0x8e480086, 0x8e480086, 0x8e480086},
-	{0x00016444, 0x03b6d2e4, 0x03b6d2e4, 0x03b6d2e4, 0x03b6d2e4},
-	{0x00016448, 0x8e480086, 0x8e480086, 0x8e480086, 0x8e480086},
-	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a610, 0x00804000, 0x00804000, 0x00000000, 0x00000000},
-	{0x0000a614, 0x00804201, 0x00804201, 0x01404000, 0x01404000},
-	{0x0000a618, 0x0280c802, 0x0280c802, 0x01404501, 0x01404501},
-	{0x0000a61c, 0x0280ca03, 0x0280ca03, 0x02008501, 0x02008501},
-	{0x0000a620, 0x04c15104, 0x04c15104, 0x0280ca03, 0x0280ca03},
-	{0x0000a624, 0x04c15305, 0x04c15305, 0x03010c04, 0x03010c04},
-	{0x0000a628, 0x04c15305, 0x04c15305, 0x04014c04, 0x04014c04},
-	{0x0000a62c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
-	{0x0000a630, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
-	{0x0000a634, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
-	{0x0000a638, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
-	{0x0000a63c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
-	{0x0000b2dc, 0xfef5d402, 0xfef5d402, 0xfdab5b52, 0xfdab5b52},
-	{0x0000b2e0, 0xfe896600, 0xfe896600, 0xfd339c84, 0xfd339c84},
-	{0x0000b2e4, 0xff01f800, 0xff01f800, 0xfec3e000, 0xfec3e000},
-	{0x0000b2e8, 0xfffe0000, 0xfffe0000, 0xfffc0000, 0xfffc0000},
-};
-
 static const u32 ar9340Modes_low_ob_db_tx_gain_table_1p0[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x0000a2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
-- 
2.25.1

