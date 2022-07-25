Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37ED857F9C2
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 08:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiGYG4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 02:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiGYGzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 02:55:14 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EF011C39
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bp15so18847891ejb.6
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=42msKn5+43W2nDXBTScN29lMEs7hqwpf7Xhq17IH5cY=;
        b=DyfTiEUMRkIwWhb8HTM8IcCI9df/WFXrvhdkwpkc38iFnxOhsV9DvHvC6r8ZDWqZDU
         y4MwZUMdJV0PMhBO9bPg7N9ilwc6c9yaDV8W8NfWh69Xa1uU/tJTEaF8tcq87zznmmyE
         hEVTb/ftAGx6aOKwqol+DewRvDYBQbngIuLv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=42msKn5+43W2nDXBTScN29lMEs7hqwpf7Xhq17IH5cY=;
        b=10mohJDZlE3nVn2kNE6HXePVd7B7DxgwCnabzAuga+xoVyzZ6NTw/ULfYTy/ea1Z+h
         tV0e4XI2eGzEmUELumGoBYSl4FJuNCqt3wmoRewZHkdVJCzJ0oK+1IXpM/rvVmSRvojf
         bvmtoY2ns+PptmNL8In3rnT/4Mns2+1scnxi3lsnvMlgHKwypX0LrIiu25ny2ZHDI47h
         c6VAj56WCSi6DE8DFYz9RuxvRnWEzpbfrpyrnDL6XmGCWgd1Pxhg2MPJKS8XXfF2AxNj
         36qBJXfOPrXm9EqoD19wtVeU5+1nCOm79cY6bhyuc2nKlIv93gUKJvwimjYrjW18bOP3
         2v5A==
X-Gm-Message-State: AJIora+keF4U5HHxY1s2DKakUN9wlg238jH5CI74HEVPPuoqxvt+SbFd
        Kh4ZAXCMxGbzFK94BgxpBUji0Q==
X-Google-Smtp-Source: AGRyM1vF5ZVzk0W7PV3udWbZvg9GB1BbplqYZ1ugpxe7+rKxWpYXX9OpNYUGyckInTlGzsEz7DztOg==
X-Received: by 2002:a17:906:6a29:b0:72e:e716:d220 with SMTP id qw41-20020a1709066a2900b0072ee716d220mr8674769ejc.82.1658732072425;
        Sun, 24 Jul 2022 23:54:32 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id r2-20020a1709060d4200b00722e57fa051sm4967711ejh.90.2022.07.24.23.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 23:54:32 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 6/6] MAINTAINERS: Add maintainer for the slcan driver
Date:   Mon, 25 Jul 2022 08:54:19 +0200
Message-Id: <20220725065419.3005015-7-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the suggestion of its author Oliver Hartkopp ([1]), I take over the
maintainer-ship and add myself to the authors of the driver.

[1] https://marc.info/?l=linux-can&m=165806705927851&w=2

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- Add the patch "MAINTAINERS: Add myself as maintainer of the SLCAN driver"
  to the series.

 MAINTAINERS                        | 6 ++++++
 drivers/net/can/slcan/slcan-core.c | 1 +
 2 files changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fc7d75c5cdb9..74e42f78e7cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18448,6 +18448,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
 F:	include/linux/sl?b*.h
 F:	mm/sl?b*
 
+SLCAN CAN NETWORK DRIVER
+M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	drivers/net/can/slcan/
+
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <jiangshanlai@gmail.com>
 M:	"Paul E. McKenney" <paulmck@kernel.org>
diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 76f20dc1aa90..54f16ebd72bc 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -61,6 +61,7 @@ MODULE_ALIAS_LDISC(N_SLCAN);
 MODULE_DESCRIPTION("serial line CAN interface");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
+MODULE_AUTHOR("Dario Binacchi <dario.binacchi@amarulasolutions.com>");
 
 /* maximum rx buffer len: extended CAN frame with timestamp */
 #define SLCAN_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
-- 
2.32.0

