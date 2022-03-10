Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D414D445F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiCJKSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 05:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237730AbiCJKSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 05:18:53 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7C55620B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 02:17:50 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id w7so8561179lfd.6
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 02:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ok2yIWNdYw6UT5efIAaPeOu7HZzSRGXMlO55ACJQkJA=;
        b=iFB1j+Q2fbiLFyCEX66U0kNp3R9Qdjv5othk0HJtDc2koSj6UaHKn2IGAqWRW1srde
         83/F+janZ5NyYA/TbT8hP3qMpuxwDcs+Hsmm5M7olP4d98+JP0b0cjAXIi5je2Pkk3vy
         CwQRiqmsLBbLHQTdFz1H6D3p9Yq+eQH6L0ozOBmN0tLogA0aNw+uevLz3ol6JQgP8Di+
         uqkd0BRWhgDZdMpWrnilq2tFFuwxUkdzz3pBJ++1f3oR55zUi20lDRqI0qZWQfUMs1rD
         QHePrR5mY8w/q7oY6LnLziLRnEnookfGFge72iCcTKzqTvZLiTLBiYzk1/YZ715UeuYk
         aj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ok2yIWNdYw6UT5efIAaPeOu7HZzSRGXMlO55ACJQkJA=;
        b=0eSov+pivugKWrR2k36sbIEjR0b/54ZhXrKRV93YBtrHde98eQUnt58IGv6E8Q9EG7
         SdRVFjTqZXfT8E+ALGtQjMJbRHQ/4Qc2TeRavQnoipM1rMThBwcWxpKrTSBp3Ciq/P7H
         qoUtpFbRUPiASfsgxoTQ2w6CtUfiqHFuscqCl7zO4FIYEsqbsp56po+KGZOmLjFmqwc0
         bJTakqZLa4a3F5A/PY2zacHuBXvkNCSFW9Mb5hEBlX1ywwsi2Dl38fAdiYFsJ6yTe210
         t3DconnkvNLw75Lk6V3yMYIcCdknV5juJ4swuml2Pq51+Uappz1EuJOnN2fMn7fA/rQd
         RTNA==
X-Gm-Message-State: AOAM531z682UgCmMtYlIwit0+qt1E847zzVO8sIAjYcEiYU6wXxQAZVb
        QwzCnZpvgACEvmUsPAljV9UhGhAiPX7xT6lJ
X-Google-Smtp-Source: ABdhPJwBLpPZruapkiuD/6bfRKohLHFYZXOqojAnrZrEwuSgOh2iA/UtAX49f1b2E4n4vKWILkebQg==
X-Received: by 2002:ac2:420e:0:b0:448:1c25:f22d with SMTP id y14-20020ac2420e000000b004481c25f22dmr2563248lfh.476.1646907468987;
        Thu, 10 Mar 2022 02:17:48 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id n19-20020a2eb793000000b00247ec95fddfsm984566ljo.33.2022.03.10.02.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 02:17:48 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] net: phy: Kconfig: micrel_phy: fix dependency issue
Date:   Thu, 10 Mar 2022 11:17:44 +0100
Message-Id: <20220310101744.1053425-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building driver CONFIG_MICREL_PHY the follow error shows up:

aarch64-linux-gnu-ld: drivers/net/phy/micrel.o: in function `lan8814_ts_info':
micrel.c:(.text+0x1764): undefined reference to `ptp_clock_index'
micrel.c:(.text+0x1764): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ptp_clock_index'
aarch64-linux-gnu-ld: drivers/net/phy/micrel.o: in function `lan8814_probe':
micrel.c:(.text+0x4720): undefined reference to `ptp_clock_register'
micrel.c:(.text+0x4720): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ptp_clock_register'

Rework Kconfig for MICREL_PHY to depend on 'PTP_1588_CLOCK_OPTIONAL ||
!NETWORK_PHY_TIMESTAMPING'. Arnd describes in a good way why its needed
to add this depends in patch e5f31552674e ("ethernet: fix PTP_1588_CLOCK
dependencies").

Reported-by: kernel test robot <lkp@intel.com>
Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/net/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 902495afcb38..ea7571a2b39b 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -220,6 +220,7 @@ config MEDIATEK_GE_PHY
 
 config MICREL_PHY
 	tristate "Micrel PHYs"
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  Supports the KSZ9021, VSC8201, KS8001 PHYs.
 
-- 
2.35.1

