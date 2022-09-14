Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C26E5B843C
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiINJJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiINJHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:07:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA6A77E80;
        Wed, 14 Sep 2022 02:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 784E6B816A9;
        Wed, 14 Sep 2022 09:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1A1C433B5;
        Wed, 14 Sep 2022 09:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146231;
        bh=VMjN8AHTGg4+3Rx4ThJnfKqF43L6Bxi2Po21YKxmSz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXBWVJOGvqDzDbFG08pdnFlUD1we+l45pjAj0aaWHYfKZQ5T4+7F4kS4QYPpX486D
         GE2f9iJlrYV/7wrTMku3fd5zRC4a4FbhLlP8HGme2BqQrZp+h2vGsNKVIgYrY833rB
         4kL4UEFMvbL7EQQOrMzfkExzHCTAa2uE94pyZKmNXUPilZN1+/vmtecMlM5woK49ya
         +5bm7rz1nQO733R0pmMt8mmwk5J6III7PPNx+iIsbEAQdE+tjxjwlJDbubXHyTX9tl
         +IpbpTASiczLHFqnOwmwy/ym4z+SwiKFqAPCQb/nls9AQdmcxeNMrNrkkjGw9QZ24o
         mamJj3t0LRStQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "jerry.meng" <jerry-meng@foxmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/13] net: usb: qmi_wwan: add Quectel RM520N
Date:   Wed, 14 Sep 2022 05:03:11 -0400
Message-Id: <20220914090317.471116-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090317.471116-1-sashal@kernel.org>
References: <20220914090317.471116-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "jerry.meng" <jerry-meng@foxmail.com>

[ Upstream commit e1091e226a2bab4ded1fe26efba2aee1aab06450 ]

add support for Quectel RM520N which is based on Qualcomm SDX62 chip.

0x0801: DIAG + NMEA + AT + MODEM + RMNET

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#= 10 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0801 Rev= 5.04
S:  Manufacturer=Quectel
S:  Product=RM520N-GL
S:  SerialNumber=384af524
C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: jerry.meng <jerry-meng@foxmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/tencent_E50CA8A206904897C2D20DDAE90731183C05@qq.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 48e8b94e4a7c5..1502069f3a4e2 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1024,6 +1024,7 @@ static const struct usb_device_id products[] = {
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0801)},	/* Quectel RM520N */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
-- 
2.35.1

