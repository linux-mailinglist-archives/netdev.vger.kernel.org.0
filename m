Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CD0130431
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgADTxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:53:23 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:44817 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbgADTxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:53:21 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mt6x5-1jgsza07NR-00tS78; Sat, 04 Jan 2020 20:52:11 +0100
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
Subject: [PATCH 3/8] net: batman-adv: remove unneeded MODULE_VERSION() usage
Date:   Sat,  4 Jan 2020 20:51:26 +0100
Message-Id: <20200104195131.16577-3-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200104195131.16577-1-info@metux.net>
References: <20200104195131.16577-1-info@metux.net>
X-Provags-ID: V03:K1:Ci9PP5MICbNyKZYz/hOm3tbLcnhVGValijAAoQ6mFu/hIgdFR42
 OovCRWMFmdaKsPmQLoX3w1NfLCvwicLbrS9Z5JaAXiHuKAbGPpuW3P4RohAj4aSIL09hQfb
 TYS7Mny8thYiVeUZaUSDgi1GBTy3Vr5IdyUjQz4bNE2bGoQhSZJnUkOxRqbuS36vKCmNqwU
 xHutYcwZg3P7dc2M84wew==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rjpsvxxoJPM=:hX5kfdTKwbLpbwAXjMQX3c
 UgcG2H12f29KLzs12xnWxcGB78lBx6XdBTOVpCx1XpyrDR3L6UPzlIhn4S1dO18LqU9pZYqZq
 Dron2+oLoEZ6UPHbpE40SXa504ZnjiyPH6eyBWak4/YWJ0rY9ATeR6dUJ2+Lky751Wp/f7c4X
 7B/QDh4YJyyRxRKzyEEYimtHxg8ovcOVKju8CCv8a+suOxCLoss/ZYOLPXfSHOxNklcsv9XeF
 AJDHWzgAf+rI46m9R77Ppm7Uve4065Fgn7qd+Lpxi5HppTzwEKDS+Dk+xR5hYt+4Ixi4zdKXs
 W369pyPxbQovyrgkajw5O7u+5U45bhRSOgDrZXXGFocikFT2hVe6v3Jg2EFRr3Df8xkPIuaD7
 +IIHNSy9hBrhiZGelK5+vmnORx6iLaTJF93SmOIwWcT8+PGMI3joY1kNRBSGnTNbK4aw1hPsU
 zdcOIFzkSUHJzhz2rHrBzMX3zfsFzZbRKmz/SPmgARVzlkH5SQYskPwYfAQDAL83ifNiQEJ54
 dHI917U0PFfrytdO+39EHRZzwgendSFoSg4JGUhDgoGKFVncftzUP9bSxEiZzOmMKK766wbC+
 SAK27B3AjKWQFF6GiV0b/Ya4u7JUPnNdoYk/FqwTtlBSKqq+z0XXkwSzhIY9q9WLGa4kCoR1d
 Ocs7/66SM2G5vQwYbk+RjQCYa+vAX8kSsLXO/saYmFh+oN+1nVTdqDiagE5rU7q7ksQSW0AOI
 ACmApk+490waUmPxqB7mogDCQCrQZO8YPATvEOjBdZTpe0MlJhe+FoT5R/JMI6iFr4TwoFgpV
 Q/QtoE1WzmHEpS/AOyELlVd+GNKWwYtcGYcxNOsguH0k5n7JlctK7/ytOe4imxyhwrPUSFWF3
 3hTDCAPJaee9k5ggLzMw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/batman-adv/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 4811ec65bc43..8ccca3734b7a 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -748,6 +748,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR(BATADV_DRIVER_AUTHOR);
 MODULE_DESCRIPTION(BATADV_DRIVER_DESC);
 MODULE_SUPPORTED_DEVICE(BATADV_DRIVER_DEVICE);
-MODULE_VERSION(BATADV_SOURCE_VERSION);
 MODULE_ALIAS_RTNL_LINK("batadv");
 MODULE_ALIAS_GENL_FAMILY(BATADV_NL_NAME);
-- 
2.11.0

