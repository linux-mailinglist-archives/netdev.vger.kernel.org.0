Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CAF30734
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfEaDyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:54:24 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40112 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfEaDyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:18 -0400
Received: by mail-it1-f196.google.com with SMTP id h11so13032179itf.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0MRFaUSMAfw/XRQQZHzE3aa0KzqIA2a6f7/ADiTDy48=;
        b=uwklmqHcoHhu1WLCfPLSWItOjPdTvghEYLBU6xALfWtsnd113VuUy3W4OCt7Gf7QPo
         41T0Kb96J3ZSXspViH4KCr3Z1SxedNQJeBOUBfoI6mWPpGqYqYDdnTOvkIRtYFl7he/C
         tuHhPYcxS4Bk+X35n/t9s33SCJGdhQWJcvM0GMVAvgKp0JhTyaf6a7pcaeMTEIKcmgXZ
         3tE7+sKkPwBES53s3TxVG2diUKbi6dwVeJNQMPdqSZXPSI3AAgq14TRNOQlsumqidDGX
         FlY+vsFjKBKkr8fzT6M0XgLfkjQO6tSythQDO4ptBHatoj3PqdEFPTk4RzUy6/qfC7sW
         yRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0MRFaUSMAfw/XRQQZHzE3aa0KzqIA2a6f7/ADiTDy48=;
        b=a33O3LCbbZ65fS8y+KUIR+r8S38/3M4WWUL54nWIpCxjrk/4Q0UxhXhUttw62NvrWg
         CNCKNj3s7GIgDy74tVKrhPHLwiJzymWJVCLovqoYgWv8RNj2AjXk9EFUGVy9KePPj3n4
         6abo+t9EbUF5GzbaMMvuaMaoZCegQpP9nNqjDTPOCLNrWc3bUp76G1VIUeUyfvx1o4oU
         sWmUFl0es9jkAbMcjWWQ/J3HDJ9Bxwf2uuEMwxQbzEjwQllBFQ6/aCHn1AuHos7Q+w0e
         f6qGTSwSrEcX08crAFmIjYb8tK3/IQ5xiffWnWZr2NuNZcduYL6+HV5+Prg3DHFi8T+f
         Zv5g==
X-Gm-Message-State: APjAAAU6NBqQhaD6alKger66trkzN4yjrUiZaQto6oyn94AJ1mEEU9il
        Xf7E/xIGruyoDlVPHAOGh3+FqA==
X-Google-Smtp-Source: APXvYqzAp7WqDtF2svw6m32RESqRJSWfwXgOZsWCJl/PO7gAfHjI0bpJKwO94bXVpo532sRxJONkgg==
X-Received: by 2002:a24:6583:: with SMTP id u125mr5701155itb.168.1559274858043;
        Thu, 30 May 2019 20:54:18 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:17 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 17/17] arm64: defconfig: enable build of IPA code
Date:   Thu, 30 May 2019 22:53:48 -0500
Message-Id: <20190531035348.7194-18-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CONFIG_IPA to the 64-bit Arm defconfig.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 4d583514258c..6ed86cb6b597 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -261,6 +261,7 @@ CONFIG_SMSC911X=y
 CONFIG_SNI_AVE=y
 CONFIG_SNI_NETSEC=y
 CONFIG_STMMAC_ETH=m
+CONFIG_IPA=m
 CONFIG_MDIO_BUS_MUX_MMIOREG=y
 CONFIG_AT803X_PHY=m
 CONFIG_MARVELL_PHY=m
-- 
2.20.1

