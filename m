Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2248B585C94
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 01:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiG3XB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 19:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiG3XBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 19:01:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6061214022
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 16:01:22 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p8so7438269plq.13
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 16:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=TVS7Stgs3qPTei1UEkK5P2dNEdozcmQ/ayF4xp3Ron8=;
        b=cNVn8d36399sWcxM2FAeRT1l40n1NiZfsmAbAE9WAJtPQ/FV6mix6oMRvVjt3tckur
         hxCN/AM3Ppo3eITwdm/meG2pbdHjMeSRC1A2eSoZvNhP9GnVx17ffKT8sYh+4XGF0U/Z
         gEfODn9lpwFmxbIfk4Om+AwqH0NwNQruzaGObuPhKhoBBmzcZH6fbC5HYqa10JaABEYa
         FUlN2Q6MrHz6UfXIuzqj+TuzGmiSZYL6XKdpPKw3y8sMsmUSWegvifvoL9v+A10ppnLh
         77h57ywiKUG7tz6X4w5Utthc+qjf3sAscz5ngm/C6Ypz5Nggl8A4p41sbel3ZFaMY+fy
         Z/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=TVS7Stgs3qPTei1UEkK5P2dNEdozcmQ/ayF4xp3Ron8=;
        b=ah4ljQYhltuy9D2IX4Yo84xEnM0zISvHSaFg6ImI/Uv21GPz3wdmvB2/niFTuy/Yv0
         ZbQ+kQBush6FASIflsEEJB0U7ujsGTpLAFFvFUUlbLw5wgWqRQGUsZ/TeYvCidfJPx0N
         WM/N5xUuoHO8c1oK/X/q8DU+K47DYVx2VpWj3scqL1uJiDK28+sZ0cwk2PEhA8VqM5Bj
         R9s6DJbaQW5JqQddvHoUIRv2bpd8mi8OmA8cUBGIj1acbLOECuUn+DRwGmLUlGWHaYip
         ESplZ+3bt+r62dZ40sw1+bSiSMLw2vk3hPjDtCsLT8iKbgIa+jECgxC1cltwGiNiEXMW
         XQ9A==
X-Gm-Message-State: ACgBeo3xo1RdnxFGNfBgSnU77JaB28Dt6Vm6HJ3ydBWLJtciA7/E4DUq
        8phpTa0uj3LUB7vKTX+/bJuMF1fHKT0/TQ==
X-Google-Smtp-Source: AA6agR7DUjP0cwNTR97pztrbArJcOKMXy5PDQV9IjntHbIb/EK5yEfoNE4MRTifI4nFOSz55ywEogA==
X-Received: by 2002:a17:90a:fd06:b0:1f3:29d8:72d8 with SMTP id cv6-20020a17090afd0600b001f329d872d8mr11697082pjb.23.1659222081524;
        Sat, 30 Jul 2022 16:01:21 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:91c0:ec2a:ce2d:b0b8])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c11500b0016c40f8cb58sm6259235pli.81.2022.07.30.16.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 16:01:20 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: usb: make USB_RTL8153_ECM non user configurable
Date:   Sat, 30 Jul 2022 16:01:13 -0700
Message-Id: <20220730230113.4138858-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Maciej Żenczykowski <maze@google.com>

This refixes:

    commit 7da17624e7948d5d9660b910f8079d26d26ce453
    nt: usb: USB_RTL8153_ECM should not default to y

    In general, device drivers should not be enabled by default.

which basically broke the commit it claimed to fix, ie:

    commit 657bc1d10bfc23ac06d5d687ce45826c760744f9
    r8153_ecm: avoid to be prior to r8152 driver

    Avoid r8153_ecm is compiled as built-in, if r8152 driver is compiled
    as modules. Otherwise, the r8153_ecm would be used, even though the
    device is supported by r8152 driver.

this commit amounted to:

drivers/net/usb/Kconfig:

+config USB_RTL8153_ECM
+       tristate "RTL8153 ECM support"
+       depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
+       default y
+       help
+         This option supports ECM mode for RTL8153 ethernet adapter, when
+         CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
+         supported by r8152 driver.

drivers/net/usb/Makefile:

-obj-$(CONFIG_USB_NET_CDCETHER) += cdc_ether.o r8153_ecm.o
+obj-$(CONFIG_USB_NET_CDCETHER) += cdc_ether.o
+obj-$(CONFIG_USB_RTL8153_ECM)  += r8153_ecm.o

And as can be seen it pulls a piece of the cdc_ether driver out into
a separate config option to be able to make this piece modular in case
cdc_ether is builtin, while r8152 is modular.

While in general, device drivers should indeed not be enabled by default:
this isn't a device driver per say, but rather this is support code for
the CDCETHER (ECM) driver, and should thus be enabled if it is enabled.

See also email thread at:
  https://www.spinics.net/lists/netdev/msg767649.html

In:
  https://www.spinics.net/lists/netdev/msg768284.html

Jakub wrote:
  And when we say "removed" we can just hide it from what's prompted
  to the user (whatever such internal options are called)? I believe
  this way we don't bring back Marek's complaint.

Side note: these incorrect defaults will result in Android 13
on 5.15 GKI kernels lacking USB_RTL8153_ECM support while having
USB_NET_CDCETHER (luckily we also have USB_RTL8150 and USB_RTL8152,
so it's probably only an issue for very new RTL815x hardware with
no native 5.15 driver).

Fixes: 7da17624e7948d5d ("nt: usb: USB_RTL8153_ECM should not default to y")
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hayes Wang <hayeswang@realtek.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/net/usb/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index e62fc4f2aee0..76659c1c525a 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -637,8 +637,9 @@ config USB_NET_AQC111
 	  * Aquantia AQtion USB to 5GbE
 
 config USB_RTL8153_ECM
-	tristate "RTL8153 ECM support"
+	tristate
 	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
+	default y
 	help
 	  This option supports ECM mode for RTL8153 ethernet adapter, when
 	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
-- 
2.37.1.455.g008518b4e5-goog

