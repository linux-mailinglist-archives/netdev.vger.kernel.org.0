Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38513041C
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgADTwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:52:46 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:35377 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADTwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:52:46 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MfpGR-1jKyQg2q3V-00gL4c; Sat, 04 Jan 2020 20:52:15 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 8/8] net: tipc: remove unneeded MODULE_VERSION() usage
Date:   Sat,  4 Jan 2020 20:51:31 +0100
Message-Id: <20200104195131.16577-8-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200104195131.16577-1-info@metux.net>
References: <20200104195131.16577-1-info@metux.net>
X-Provags-ID: V03:K1:e0iL8IFbjcCAHpd6BMZe1GejXvKwFuPi9wH+/YPt+bg2ITpBrYD
 nkU3ZJUAVBwFU0ddcB4rZq81KTDf7D5x/LPLhXDEM+JOe2BnSDuExsme3SMm1eC9ZevhTQK
 w0JOpAVBeESjGAiYwl9JJcfUtknbzHVCAag9+EmQP5KZfh1hU8xlfhCZr0fmzU3wyDFN0yk
 CeQMvuXvGKeXb+Pj8qAbg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:31eC9wPUGiI=:l+PE8pH7YuJeWPkcGeZYUV
 /jM9EZTd9WXG8OCxjkkaTp1WeYSC7fZm5FmoKOshuEwaZZjB2QEbLQHX7TZNvESwgw/HfBvsh
 v5S8zsJSsJtBJIDxCT6bssUkDV314Nln8elCc5QkEQq0sgRKFmkbVTJSm1qXDZg3iqNCrS2wn
 PQOvdLUoCOIaA+luAWcM5alqMKXXQGksIB+U71fz3c9vqtObY6p7aORR2sPjOorN1ZNXxCAB4
 +ahbhJXEkuslqrIiqMz5H5aMKNFo8p525j4LLOh4kcH2mVnSvNdKlpEYQRonWt+7+Fexd+irl
 32Au7qqb0uqgpNXXw4Vi8EGLmHE3sGsRr+N6MaZzwgolIaLKYt1uHa2VOfZW82yGVLanyqRQI
 K6AKzdQEQSNpuFkuVlJn9d9YWAzMWLBAMZcOjg07olAwiHYOvk62Be9tsOncc5wpk1tPYD06e
 q5OxirdbCl2hNBSYFB4VfdSLOCY93nWdw2rnMNuLwxyWnUcUCEXJYGb6zvIN60xgdmzG/sXtM
 FMH+P4Kph+LFAsGui9lTjKgjWPa9Mqimt3jf0QWyrcLuVZUlhPw5Kr0n8d3fd1yeIoS4r/GCl
 M2kBmWJASBJv38KC9Fa+p+qB+tiP7YSQRed5AgKhXZbywFwNRfOkKcvsJx6q4B5ta39lUiIFV
 ljmz6RlDUAp3s3yUQgHJlMratrMyC/mjGuqwcNTsDDtXwuwyuUCvo9OHhR7vWyDAKiP3UKSq0
 bongl1fBCzsImpFJ4r+sz0k3L1aAJ7LfDJ9icHaXKiFb/v0ubOBn5UU6AEQmMJYrdcT044h1D
 FMsnF56uGfuzi+/fpkEbx8v78RWzDJ4cwF3eSQoUHJvBX86oo9gLGwTFJ+P1ipIrxcUMtnRlb
 RiCaNy0H84HcINVwB39g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/tipc/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 4f6dc74adf45..98dbc18a0dd8 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -221,4 +221,3 @@ module_exit(tipc_exit);
 
 MODULE_DESCRIPTION("TIPC: Transparent Inter Process Communication");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(TIPC_MOD_VER);
-- 
2.11.0

