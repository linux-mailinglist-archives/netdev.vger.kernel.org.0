Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0E25F3D4B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 09:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiJDHc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 03:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiJDHcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 03:32:47 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3C14D246;
        Tue,  4 Oct 2022 00:32:45 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id s10so14346926ljp.5;
        Tue, 04 Oct 2022 00:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date;
        bh=bSZFC1cY9nLrecV4EA48kyYz5HoUOeNFW38JRZTVhww=;
        b=Y71rSsGxZZF4I98WfGsuUuEifQ2bIFzz11uLE/+OFkHWKEY1Z0GxBNh1cIlpmKoZ9M
         hTRkMFPkaC996DS/71Ih2ju6SYsuO56600XeUG926gYcw25aAaWoikIV7L/R+fJ2o63I
         Oh/arQTl9CiyOJow3bxH6bfr/dNKK2J/dEQGoQzpCZQqEGJ/NAOvD708U7LJ+TRCzgiB
         +ECVvXRFgvGMR65AzHDL5tUO9NgnJS6ELyl27QtrgiQSqCJ6CaAkq57LUlLPO4KJDpW0
         hTE35S605lpYiP8/s4FpU3oCF4DkxP9yr8Z9iKZn2k8R78TfG5lInqWUeGICVKpNDVhS
         DGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=bSZFC1cY9nLrecV4EA48kyYz5HoUOeNFW38JRZTVhww=;
        b=uFV0KSHTueJ2mIQHUar86BDFY/BfotRkYuF8Lo01qF9dbTCKthWLknZD2yHiMryjRS
         VJA7IOrrZk1Cyo9o79nJCUQRHzxBmSZ2Qm999BvH+WMK278pRlcfRUpamtOa4IDtctQk
         61+YlesM4BTaA0E+QkqIHqKnlErzPhFn78uwmq+jdrfeCWZ/MkBGJ8hJcsof2aRLh5vs
         SCxPhN7i12NZZQxYVxGrvPJ6zjS7h538jjwtf2Cy41nqXP66Jr5rw56Vj80/XCSoJEWN
         Nc682rUOwlMQKNDtJxRRlJC21QAUidI7m7uxsJXjuUsX67d+dfr+g3IBD2Dw6RiVU22t
         4uSA==
X-Gm-Message-State: ACrzQf0DY/bm4nwvFfUSW43+rWnsY/FkZByUQaQAacp3x975YO6P17+W
        DYIrcWxmFXn0XsvCR1LHD2g=
X-Google-Smtp-Source: AMsMyM4S/YM2hA9QKc1xz5D4NvWaMce/dcV+6cyNywzQ3XCQ9M4R4vKL48euuUitCExphPsOvk7gFQ==
X-Received: by 2002:a2e:3517:0:b0:26d:e2be:8c41 with SMTP id z23-20020a2e3517000000b0026de2be8c41mr1969365ljz.104.1664868764023;
        Tue, 04 Oct 2022 00:32:44 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i19-20020a056512225300b00499bf7605afsm1800229lfu.143.2022.10.04.00.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 00:32:43 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] docs: networking: phy: add missing space
Date:   Tue,  4 Oct 2022 09:32:42 +0200
Message-Id: <20221004073242.304425-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Missing space between "pins'" and "strength"

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 Documentation/networking/phy.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 06f4fcdb58b6..d11329a08984 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -120,7 +120,7 @@ required delays, as defined per the RGMII standard, several options may be
 available:
 
 * Some SoCs may offer a pin pad/mux/controller capable of configuring a given
-  set of pins'strength, delays, and voltage; and it may be a suitable
+  set of pins' strength, delays, and voltage; and it may be a suitable
   option to insert the expected 2ns RGMII delay.
 
 * Modifying the PCB design to include a fixed delay (e.g: using a specifically
-- 
2.34.1

