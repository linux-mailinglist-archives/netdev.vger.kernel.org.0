Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EBF288850
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbgJIMLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732957AbgJIMLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:11:09 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AB4C0613D2;
        Fri,  9 Oct 2020 05:11:07 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u8so12753714ejg.1;
        Fri, 09 Oct 2020 05:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=d3YdrBOFHDSRVDjKGNClxkEqeRQoEPb/8URXW9wI3bc=;
        b=X4LtL/EZsx93wLJRBRg+wFWEVStqNa5Wra7WxrKmnRtlcYkwqQngNGm9xWqreuvkkZ
         3JXCggCrQ3vWHZwxiqjy4Gcxbe9SAxbaHmetIAsoomW/nSKyWJHKaSwOyh9N4QzjON5K
         E/mw7bDYdDve2CxIHK5FxwsK224fY3arWD9fdipkLhUqhAytBpwKZE4FXv+WG8FKl/gg
         pyOuIPvaLIvn3goX6C8d6ZQHQ8v2DZ67/YQA8SaYLKzCaXjDSvFJHH7uQSfByBm/YIQA
         d5cLAmlg3jYGJXocb3p8hYbUNXOgWKGa1I/QOywwBTimySieQpOWn9qixguh32U1NeZO
         Dwbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=d3YdrBOFHDSRVDjKGNClxkEqeRQoEPb/8URXW9wI3bc=;
        b=r5HXDWJfI0RrBqix3CTUevLw+OnpyKrGVq+bvb1C7NZ+6MxdpEkmrEJNYBXTK23rA9
         uj0E8DI2+G6tk2MwCD/9gnOsy+VUjSxLQmKNH1XIubwvPorkFHNtri7chRGvT1wVoxZq
         AgAJjopyhf/ZUndjipYDRBVsKRAkAvPyZp6EnkdNCibDETg1rzrfY9iY+SAK7jPR3694
         X0TZvkfFIEp047CwDCfTrSV4uu17Wo/80z2t7RBSSmxLTp7cBj93sufcj7TO6kVVsayF
         6VSovtlCE8cAPQOYGSeyucJlXS2UXESfcgKh+pCmsu7Lj4x5DV7OMRJcizLi88dmBFZY
         cwQg==
X-Gm-Message-State: AOAM530e9Y6K2HsncPeo6VBRN/0sKyeJsxvmCVzLmUrrbxkGV71TBowS
        89WybW7pM3FSWanu46T2tcIk1xwTKdO/Iw==
X-Google-Smtp-Source: ABdhPJx+iQTn0NOfo3iNXau8j7qg1pe9acEEgwrFVc1hUsmNTN906IcXdTeiv1Ifhdgc78TfGLhanw==
X-Received: by 2002:a17:906:8157:: with SMTP id z23mr13440895ejw.274.1602245465940;
        Fri, 09 Oct 2020 05:11:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:e538:757:aee0:c25f? (p200300ea8f006a00e5380757aee0c25f.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:e538:757:aee0:c25f])
        by smtp.googlemail.com with ESMTPSA id dr7sm6167171ejc.32.2020.10.09.05.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 05:11:05 -0700 (PDT)
To:     Oliver Neukum <oneukum@suse.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: usbnet: remove driver version
Message-ID: <bb7c95e6-30a5-dbd9-f335-51553e48d628@gmail.com>
Date:   Fri, 9 Oct 2020 14:10:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obviously this driver version doesn't make sense. Go with the default
and let ethtool display the kernel version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/usb/usbnet.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index bf6c58240..963d260d1 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -34,9 +34,6 @@
 #include <linux/kernel.h>
 #include <linux/pm_runtime.h>
 
-#define DRIVER_VERSION		"22-Aug-2005"
-
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -1047,7 +1044,6 @@ void usbnet_get_drvinfo (struct net_device *net, struct ethtool_drvinfo *info)
 	struct usbnet *dev = netdev_priv(net);
 
 	strlcpy (info->driver, dev->driver_name, sizeof info->driver);
-	strlcpy (info->version, DRIVER_VERSION, sizeof info->version);
 	strlcpy (info->fw_version, dev->driver_info->description,
 		sizeof info->fw_version);
 	usb_make_path (dev->udev, info->bus_info, sizeof info->bus_info);
-- 
2.28.0

