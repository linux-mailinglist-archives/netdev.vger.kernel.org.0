Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881C81378D4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgAJWCg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jan 2020 17:02:36 -0500
Received: from mga17.intel.com ([192.55.52.151]:3535 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgAJWCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 17:02:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 14:02:35 -0800
X-IronPort-AV: E=Sophos;i="5.69,418,1571727600"; 
   d="scan'208,223";a="212393117"
Received: from jmanteyx-desk.jf.intel.com ([10.54.51.75])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 10 Jan 2020 14:02:23 -0800
From:   Johnathan Mantey <johnathanx.mantey@intel.com>
Subject: [PATCH] Propagate NCSI channel carrier loss/gain events to the kernel
To:     netdev@vger.kernel.org
Cc:     sam@mendozajonas.com, davem@davemloft.net
Autocrypt: addr=johnathanx.mantey@intel.com; prefer-encrypt=mutual; keydata=
 mQENBFija08BCAC60TO2X22b0tJ2Gy2iQLWx20mGcD7ugBpm1o2IW2M+um3GR0BG/bUcLciw
 dEnX9SWT30jx8TimenyUYeDS1CKML/e4JnCAUhSktNZRPBjzla991OkpqtFJEHj/pHrXTsz0
 ODhmnSaZ49TsY+5BqtRMexICYOtSP8+xuftPN7g2pQNFi7xYlQkutP8WKIY3TacW/6MPiYek
 pqVaaF0cXynCMDvbK0km7m0S4X01RZFKXUwlbuMireNk4IyZ/59hN+fh1MYMQ6RXOgmHqxSu
 04GjkbBLf2Sddplb6KzPMRWPJ5uNdvlkAfyT4P0R5EfkV5wCRdoJ1lNC9WI1bqHkbt07ABEB
 AAG0JUpvaG5hdGhhbiBNYW50ZXkgPG1hbnRleWpnQGdtYWlsLmNvbT6JATcEEwEIACEFAlij
 a08CGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ0EfviT3fHwmcBAgAkENzQ8s0RK+f
 nr4UogrCBS132lDdtlOypm1WgGDOVQNra7A1rvXFgN05RqrdRTpRevv7+S8ipbiG/kxn9P8+
 VhhW1SvUT8Tvkb9YYHos6za3v0YblibFNbYRgQcybYMeKz2/DcVU+ioKZ1SxNJsFXx6wH71I
 V2YumQRHAsh4Je6CmsiMVP4XNadzCQXzzcU9sstKV0A194JM/d8hjXfwMHZE6qnKgAkHIV3Q
 61YCuvkdr5SJSrOVo2IMN0pVxhhW7lqCAGBGb4oOhqePwGqOabU3Ui4qTbHP2BWP5UscehkK
 6TVKcpYApsUcWyxvvOARoktmlPnGYqJPnRwXpQBlqLkBDQRYo2tPAQgAyOv5Lgg2VkHO84R7
 LJJDBxcaCDjyAvHBynznEEk11JHrPuonEWi6pqgB8+Kc588/GerXZqJ9AMkR43UW/5cPlyF2
 wVO4aYaQwryDtiXEu+5rpbQfAvBpKTbrBfYIPc8thuAC2kdB4IO24T6PVSYVXYc/giOL0Iwb
 /WZfMd5ajtKfa727xfbKCEHlzakqmUl0SyrARdrSynhX1R9Wnf2BwtUV7mxFxtMukak0zdTf
 2IXZXDltZC224vWqkXiI7Gt/FDc2y6gcsYY/4a2+vjhWuZk3lEzP0pbXQqOseDM1zZXln/m7
 BFbJ6VUn1zWcrt0c82GTMqkeGUheUhDiYLQ7xwARAQABiQEfBBgBCAAJBQJYo2tPAhsMAAoJ
 ENBH74k93x8JKEUH/3UPZryjmM0F3h8I0ZWuruxAxiqvksLOOtarU6RikIAHhwjvluEcTH4E
 JsDjqtRUvBMU907XNotpqpW2e9jN8tFRyR4wW9CYkilB02qgrDm9DXVGb2BDtC/MY+6KUgsG
 k5Ftr9uaXNd0K4IGRJSyU6ZZn0inTcXlqD+NgOE2eX9qpeKEhDufgF7fKHbKDkS4hj6Z09dT
 Y8eW9d6d2Yf/RzTBJvZxjBFbIgeUGeykbSKztp2OBe6mecpVPhKooTq+X/mJehpRA6mAhuQZ
 28lvie7hbRFjqR3JB7inAKL4eT1/9bT/MqcPh43PXTAzB6/Iclg5B7GGgEFe27VL0hyqiqc=
Message-ID: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
Date:   Fri, 10 Jan 2020 14:02:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 76d99782ec897b010ba507895d60d27dca8dca44 Mon Sep 17 00:00:00 2001
From: Johnathan Mantey <johnathanx.mantey@intel.com>
Date: Fri, 10 Jan 2020 12:46:17 -0800
Subject: [PATCH] Propagate NCSI channel carrier loss/gain events to the
kernel

Problem statement:
Insertion or removal of a network cable attached to a NCSI controlled
network channel does not notify the kernel of the loss/gain of the
network link.

The expectation is that /sys/class/net/eth(x)/carrier will change
state after a pull/insertion event. In addition the carrier_up_count
and carrier_down_count files should increment.

Change statement:
Use the NCSI Asynchronous Event Notification handler to detect a
change in a NCSI link.
Add code to propagate carrier on/off state to the network interface.
The on/off state is only modified after the existing code identifies
if the network device HAD or HAS a link state change.

Test procedure:
Connected a L2 switch with only two ports connected.
One port was a DHCP corporate net, the other port attached to the NCSI
controlled NIC.

Starting with the L2 switch with DC on, check to make sure the NCSI
link is operating.
cat /sys/class/net/eth1/carrier
1
cat /sys/class/net/eth1/carrier_up_count
0
cat /sys/class/net/eth1/carrier_down_count
0

Remove DC from the L2 switch, and check link state
cat /sys/class/net/eth1/carrier
0
cat /sys/class/net/eth1/carrier_up_count
0
cat /sys/class/net/eth1/carrier_down_count
1

Restore DC to the L2 switch, and check link state
cat /sys/class/net/eth1/carrier
1
cat /sys/class/net/eth1/carrier_up_count
1
cat /sys/class/net/eth1/carrier_down_count
1

Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
---
 net/ncsi/ncsi-aen.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
index b635c194f0a8..274c415dcead 100644
--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -89,6 +89,12 @@ static int ncsi_aen_handler_lsc(struct ncsi_dev_priv
*ndp,
     if ((had_link == has_link) || chained)
         return 0;
 
+    if (had_link) {
+        netif_carrier_off(ndp->ndev.dev);
+    } else {
+        netif_carrier_on(ndp->ndev.dev);
+    }
+
     if (!ndp->multi_package && !nc->package->multi_channel) {
         if (had_link) {
             ndp->flags |= NCSI_DEV_RESHUFFLE;
-- 
2.24.1



