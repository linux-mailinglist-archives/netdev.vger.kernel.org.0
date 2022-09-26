Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB35EACAE
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiIZQh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiIZQhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:37:07 -0400
X-Greylist: delayed 553 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Sep 2022 08:24:51 PDT
Received: from mxout4.routing.net (mxout4.routing.net [IPv6:2a03:2900:1:a::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548E212AED8;
        Mon, 26 Sep 2022 08:24:50 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout4.routing.net (Postfix) with ESMTP id 7FA2410091E;
        Mon, 26 Sep 2022 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1664204890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gu67iLTcMpzYQt0Kue8AjzxM20d7cDhso1y+s0Ycn7g=;
        b=RAUT8RO+l3S5C0EbsiIAqJrOtc6mi51v6SnxF3MDzvuGPIe2q8Du10hOelfdywvYQUG7lc
        ouXDA/LX9x2oxu7G0WXWOQrrUzSi9va61jy/RC8EFdBNQwaJVMWWOgQJSRmakMLIeecSRN
        rzroY7VpG6XJ5veRAiZevj5mrtxiiSs=
Received: from frank-G5.. (fttx-pool-217.61.154.230.bambit.de [217.61.154.230])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id B727B36026A;
        Mon, 26 Sep 2022 15:08:09 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-usb@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] USB: serial: qcserial: add new usb-id for Dell branded EM7455
Date:   Mon, 26 Sep 2022 17:07:39 +0200
Message-Id: <20220926150740.6684-2-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926150740.6684-1-linux@fw-web.de>
References: <20220926150740.6684-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: d1679d74-3f87-4a09-a7db-2a1401a2b864
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Add support for Dell 5811e (EM7455) with USB-id 0x413c:0x81c2.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Cc: stable@vger.kernel.org
---
 drivers/usb/serial/qcserial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 586ef5551e76..7897609916a6 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -177,6 +177,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
 	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
-- 
2.34.1

