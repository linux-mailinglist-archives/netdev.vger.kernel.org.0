Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C46C9D900
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfHZWX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:23:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37002 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfHZWX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:23:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id d16so978276wme.2
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hwv141bWdE3sLWUL8OJWA/mN7+buDbCPYNoAmwTNV8s=;
        b=LZgN5Ps9Me1WnV9umOPY6a0TeGPYFCxBjaW50mZekMgMMKPePxsxHv2GxBuULTdQK3
         OtKvJ/2TvOQiocPmU4LtBqBMKIDZ1EmtqtiBFjMdbOVBMv/AmiAHgFouFERuG5quJfm+
         qRgO/NFNe8IgiiaGlEZ3GEdKD8oUC+gfiUq9D9z6LrjVcOZ+ivhzNBc2C2Tue1YmlBhH
         5ZQgDDFmvRhM8ryvoZ6CtZxjyMxOdQjgpLkL+Sg/EP2vumPRR+ev9PCnDJIfNzOzYXUz
         zFUQwD3I9RylpzwgtFQrcRPbVIlKKK+cCOFZf36Nf88odD0/odFEFR7AjjepbOREgqVD
         VZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hwv141bWdE3sLWUL8OJWA/mN7+buDbCPYNoAmwTNV8s=;
        b=QdWfAZerN/KYMfXcQ0/Ieb9wi+D60LV0kLWOGJLwie/axFL8A7OlogWS0GYLtGv/9j
         1qGqjDD+4UrxeaGAEFrSZyIbijPlKP036OsrqlejZEVm05/15U1O2kzWJHsSQJ6X71Mq
         dXlZYKK+vY5UM1cBzVQ+Wf6UHsEoTx5vckiqIWzj1XK8ZruaDdyGJZ1XTgO7u2NGGjYR
         uFCnK7NxhJhCM/mhiOpIVgkCOXTBgDUEw2QRrJBaszbsK6FyjLT6lFTQylVqmcvUa1NT
         u7lEd4qvDyX4hP61G/ZVbdXapxX+FNUPLbVZQ/gFODJ60tWWqH4rz2MSm574h2xW22kw
         0bLA==
X-Gm-Message-State: APjAAAU9d6Yj6f6YGjHVYHwrRZGHthrEZ+7asbFr/lDtZU5ElOykr8ez
        w1Eh5jX2QhS7BzFNt4wRNT+MV7xF
X-Google-Smtp-Source: APXvYqwAwI5xIfPjCP3b2aBVrJbY9LVValwYow1U3q3XTX01OEKE+qa6yTY0IiLjA3pAKDpsC2O38A==
X-Received: by 2002:a1c:dd82:: with SMTP id u124mr24533994wmg.89.1566858234773;
        Mon, 26 Aug 2019 15:23:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:787f:2a92:ccfe:e1e4? (p200300EA8F047C00787F2A92CCFEE1E4.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:787f:2a92:ccfe:e1e4])
        by smtp.googlemail.com with ESMTPSA id 39sm39625699wrc.45.2019.08.26.15.23.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 15:23:54 -0700 (PDT)
To:     linux-firmware@kernel.org, Chun-Hao Lin <hau@realtek.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] rtl_nic: add firmware rtl8125a-3
Message-ID: <dd3220fb-7ed3-c5d1-d501-5e94f270a6b4@gmail.com>
Date:   Tue, 27 Aug 2019 00:23:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds firmware rtl8125a-3 for Realtek's 2.5Gbps chip RTL8125.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Firmware file was provided by Realtek and they asked me to submit it.
The related extension to r8169 driver will be submitted in the next days.
---
 WHENCE                |   3 +++
 rtl_nic/rtl8125a-3.fw | Bin 0 -> 3456 bytes
 2 files changed, 3 insertions(+)
 create mode 100644 rtl_nic/rtl8125a-3.fw

diff --git a/WHENCE b/WHENCE
index fb12924..dbec18a 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2906,6 +2906,9 @@ Version: 0.0.2
 File: rtl_nic/rtl8107e-2.fw
 Version: 0.0.2
 
+File: rtl_nic/rtl8125a-3.fw
+Version: 0.0.1
+
 Licence:
  * Copyright © 2011-2013, Realtek Semiconductor Corporation
  *
diff --git a/rtl_nic/rtl8125a-3.fw b/rtl_nic/rtl8125a-3.fw
new file mode 100644
index 0000000000000000000000000000000000000000..fac635263f92e8d9734456b75932b2088edd5ef9
GIT binary patch
literal 3456
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
DeEY6F

literal 0
HcmV?d00001

-- 
2.23.0

