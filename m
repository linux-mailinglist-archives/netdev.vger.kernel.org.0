Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7405116869F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgBUS1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:27:10 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54955 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgBUS1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:27:10 -0500
Received: by mail-wm1-f68.google.com with SMTP id n3so2761825wmk.4
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=o7kNlA5mSft9lOyBBTg7S02ERgx2VYcl+CqjsPgYuKo=;
        b=lFO94BPIg27Sx1ZMGEP7cq5pMKCErXNtn8f1tuFYdkBJlZyoYQntn4qHvIDo45+vJ3
         jhH6ZhU17ACYI8zfqaA+HXrHIZUEew3XHM7ErVcmIPIlBauDW1JxunXiiCd83N646/wQ
         XYkyY47CkGPVQYlb1ZBbuuVQJmxzokJcorOnAS/hIEywgeytaosZ8GeW/cSfQ2yUxwuo
         su9ZidQsDXX+FDSRtwMfEGEhGy1P/yrbz9iaWrag0m84rI4moZ/l5EG9cWeQE8IicBVU
         w9OjZQ2mPMzLbWZcvH+anQyIjGPBlQ4fMCy6Qdnrc4L9t40s+/c8ne6ELjhX6PtM5w9b
         4K1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=o7kNlA5mSft9lOyBBTg7S02ERgx2VYcl+CqjsPgYuKo=;
        b=JFvzsfXnhcRlss2Una+HspClRPoXMziWOnfxN+PwKIC+l/8HNdnUzxYdCvLaDfJkKC
         8h71Zkgzgvfe1FV0BC43RqeYGRRDGaGV/ZiY84mG8NVTQKk+f9YjDDYrJlCCy4OkWUQ2
         QT4GUicpizbZnCFG1aXyqzlohNCNqVvf9jkefUe2vk9s40d8pEoQMkaO6pEeAvGduWCJ
         hLgiZ3bA7q3DDHHSHppUSgeVRVCwC5gQAnrQ3t5EB7lXfHV/1qNCbbA7jHvOuivKH34k
         uXp0L/PFBUKNrY0tP3yqiw98oeSwLeBrL3ksfQ4kyG4qXDSVgpBrJAFvxpcx5BMs2Umr
         sF6g==
X-Gm-Message-State: APjAAAUoJKFHHfLcBVrJFfKDWYn2PMM/e7PFUr9pdHFBBHOouKXVsDPc
        tCOXh0mslpA1Iq0gdlEP8Jwj3pNy
X-Google-Smtp-Source: APXvYqzz17GIwTQQ7uxYoj2y/B9gkPW0+St6PhEBnw5cYN9sFl/H7kGjNbSuR8Wp6VKAxm6bxEe/3w==
X-Received: by 2002:a1c:6588:: with SMTP id z130mr5114470wmb.0.1582309627579;
        Fri, 21 Feb 2020 10:27:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c09:1a13:c773:a439? (p200300EA8F2960006C091A13C773A439.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c09:1a13:c773:a439])
        by smtp.googlemail.com with ESMTPSA id g17sm5310021wru.13.2020.02.21.10.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 10:27:07 -0800 (PST)
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove RTL_EVENT_NAPI constants
Message-ID: <497bd68c-712e-20cc-facd-3c9a1bd22124@gmail.com>
Date:   Fri, 21 Feb 2020 19:27:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These constants are used in one place only, so we can remove them and
use the values directly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 267b7ae05..cc4b6fd60 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1308,10 +1308,6 @@ static void rtl_irq_disable(struct rtl8169_private *tp)
 	tp->irq_enabled = 0;
 }
 
-#define RTL_EVENT_NAPI_RX	(RxOK | RxErr)
-#define RTL_EVENT_NAPI_TX	(TxOK | TxErr)
-#define RTL_EVENT_NAPI		(RTL_EVENT_NAPI_RX | RTL_EVENT_NAPI_TX)
-
 static void rtl_irq_enable(struct rtl8169_private *tp)
 {
 	tp->irq_enabled = 1;
@@ -5113,7 +5109,7 @@ static const struct net_device_ops rtl_netdev_ops = {
 
 static void rtl_set_irq_mask(struct rtl8169_private *tp)
 {
-	tp->irq_mask = RTL_EVENT_NAPI | LinkChg;
+	tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
 		tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
-- 
2.25.1

