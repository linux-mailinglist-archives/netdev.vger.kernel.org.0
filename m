Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D2D130428
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgADTxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:53:09 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:48915 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgADTxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:53:08 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M3UhQ-1ioNhJ42s6-000efh; Sat, 04 Jan 2020 20:52:12 +0100
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
Subject: [PATCH 4/8] net: ipv4: use netdev_info()/netdev_warn()
Date:   Sat,  4 Jan 2020 20:51:27 +0100
Message-Id: <20200104195131.16577-4-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200104195131.16577-1-info@metux.net>
References: <20200104195131.16577-1-info@metux.net>
X-Provags-ID: V03:K1:J7BY2gj2YEin7trURLNk79uAJ/mq6WfmxNnbfWNnLmmWnq2y+sV
 KHgroWux6WNpZbNc/fWv5PGycTrlfApSPQ4WTHXUYNJ565CbHGDI6IeoVuoGwmpaixaXK1c
 tzHgOCkWXMbHsN3/qQn4sbWAif/ipKs1cvS8SCdX7QnnIGhq6nDdhzUI9FA6T+CVPEQZ2Cx
 9TL2UDyHFWl1KngxIfagQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5A1PxoPB1WM=:7Ei2+AUzuUr2WWaZCTyYzu
 RLWvGazV5lzU+AQxlmQa6DPImh1XCvaR8hssdfQiLqwj3qVkzhf8sEHp9/gHd+0oMD2uKnC5S
 EhvxwonVGw/HzCapxz/2czZ9HaoC7W8g0FDAkCsLIwk5IlvY3svOCp0OfPzsUB2aiYOVVpcso
 JtgVG6UfeJvRKTkEGgnAU83zKeU9i47JquE88GXiz/vEj0HDGWjgJblqgaPydzT/RMmLj+E2J
 X84rkJSTXvgWiOOJRGKgfG9K4shD1QDVzSCwznaBmmH/P1m7qYIRkQojgySom5IJrMyuoh3Wf
 DdN+L22YyfOgiQlOvQJ91WBM5nEhDt12muoRW7FOY1sJCDNm8NdylzaW2vTmoRVuKHglw/sn/
 AwrPwclGJhAA5/aL71MPAmxXXd1y7cdGqxQifxXsrvoPRyc5QomSsZf/sGx/XjnAsvDCDLfsI
 L3dy8HWzZJHo93L84ht6lYylPLgVSHXHVIee9eEfr/X4c+4uPV5mByvVD0RBA/ANlulC6P+5t
 nLxsgCfUq57uFiUmBX+Xpr7VV4RQIrXNgxB843L8KgE5juB8IpxjeZyFPAg+LvU7/NIvvH0DL
 Y8S3BGdLyCNWLYCoCVHcbO6FYC14TpC6Y2M08B6MH+xC4KdRPMD2EfyWn7Q0/MBE8iUak8JbT
 MCgl8KXqhw+WWCLLMcq2d+BG37mo2P5O1IC3fseZKSbr3matwWESgUekP8InUH4+hwqALGBHZ
 Bq3uigXwZHZEIAWpI2c6RAeRxHdxijdMgJWbU1B4/IPPcpXdrhHjRpDzB6zwoNkfP08cnyFdh
 9rpOdX1ngf/IoWgQsq3I/i3glnFF2ByEnri7Gh4PtAi2iWxZn6lKcj6nAwQK3uly1tv+9G8TR
 VAhXYWjkIMYYv0i9gDzQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_info() / netdev_warn() instead of pr_info() / pr_warn()
for more consistent log output.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/ipv4/tcp_cubic.c    | 1 -
 net/ipv4/tcp_illinois.c | 1 -
 net/ipv4/tcp_nv.c       | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 1b3d032a4df2..83fda965186d 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -513,4 +513,3 @@ module_exit(cubictcp_unregister);
 MODULE_AUTHOR("Sangtae Ha, Stephen Hemminger");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CUBIC TCP");
-MODULE_VERSION("2.3");
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 00e54873213e..8cc9967e82ef 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -355,4 +355,3 @@ module_exit(tcp_illinois_unregister);
 MODULE_AUTHOR("Stephen Hemminger, Shao Liu");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TCP Illinois");
-MODULE_VERSION("1.0");
diff --git a/net/ipv4/tcp_nv.c b/net/ipv4/tcp_nv.c
index 95db7a11ba2a..b3879fb24d33 100644
--- a/net/ipv4/tcp_nv.c
+++ b/net/ipv4/tcp_nv.c
@@ -499,4 +499,3 @@ module_exit(tcpnv_unregister);
 MODULE_AUTHOR("Lawrence Brakmo");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TCP NV");
-MODULE_VERSION("1.0");
-- 
2.11.0

