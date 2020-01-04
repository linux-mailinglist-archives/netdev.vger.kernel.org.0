Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B6C130418
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgADTwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:52:50 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:41815 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgADTws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:52:48 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MtfRp-1jiX9W3KAh-00v6o8; Sat, 04 Jan 2020 20:52:14 +0100
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
Subject: [PATCH 6/8] net: bridge: remove unneeded MODULE_VERSION() usage
Date:   Sat,  4 Jan 2020 20:51:29 +0100
Message-Id: <20200104195131.16577-6-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200104195131.16577-1-info@metux.net>
References: <20200104195131.16577-1-info@metux.net>
X-Provags-ID: V03:K1:I2hsRBaeBFs+OxaMX4th8zcKcbOhhqnJxavSfDyB1zublqZ0tzq
 c5A76vY+gXO488rEccNAdAHGishhln9oeDAGoJY3Qgf1uNOUfvrCyYAeriw8WSYhoRkcCul
 OStAnO/fSBfkZm8aFaEXLhZjc7G4UXBXxhfaxa4ius3PSsjZSb0WIglPUjbwSxmxWYAPc/H
 GruSnV4Py6KQEtOtmT9fQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6WvmzJ897/w=:ODIXU9RuraJd4FC6i7YAKE
 b2WPhBug0qOVKvsIZ7HOurHTAOe1FQZ0QgzmF8t90z6/BDwpPIf9n/uF57pjSVTkBJN03IFyQ
 1/xj4ye7AwYPD2+TS728+7TWh+NDyzij+Q1fsLJ4N6rNpJhVsfSSiBBAYmlFwRqXauCl/JecH
 0+yDjR9PAarzA5yTJTl3DCzsCY7k75JDIHnc8QGXMSTGJRtmptyrBEoQQ3RoBno7P4nWp2/In
 N8KTkRHms1p7a+tx3/vTo3bLpdgPHpEnHAHziQYtWbIuGR8E7X9/RqwACNDyLMyPwNQO5ZF4u
 3xIzRXqeWtVth4jjQLLu9wXMZaw5w+tr/Z8xldu36p95spmLpbNZw2fWjxZDohQsCZ0tBTT3Y
 CkzYKugDeHimFxhryJiB7/CLmc/7SIWUZ7MuNzclJbL+anVSxJHJoMuFyKKcKv0skSm/L8R0Y
 P5PJ7E++K25Acp44RMsznfCm092FGg7MqG5uWzqi1gegYtkfXkV6OpQhgZN7Hkte6w1roSOB5
 7x82njX9HKqobbQdq9kNOS9Byu/WYwhoAIQskcP5Oc/hIlUcPOeog4ilOvCmZ1A+S2nJz1IdG
 Xip4m8sca4y+EsMC9332WMtU4b0fi6EVLP9KensBpV7OOh3anqmoBqjW3ad25P23UyQBrws6M
 Z131AUy3E/vqZBwBBfk9LWx+TOrXI1p/zxvN/q7H34QXH7NQIJsfu35RKdJfCSwaIwwYQ9pen
 qiyfjEa9FX2dRuWghTWQFGEKVL2QS+lothRi61zPIygTDUfDI5OyzjzMk28SCRxsMVoVy8cpK
 7+llOHoD4i0I2H8FiYmNeHojXw1S2GYzNRAS0m3XkvkCG3/vxUwNeq3P9ZbiBB2ZJvCj39X+y
 0jr8ALSeb6DOVdcbQcrQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/bridge/br.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index b6fe30e3768f..6ecd3db3ab59 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -394,5 +394,4 @@ static void __exit br_deinit(void)
 module_init(br_init)
 module_exit(br_deinit)
 MODULE_LICENSE("GPL");
-MODULE_VERSION(BR_VERSION);
 MODULE_ALIAS_RTNL_LINK("bridge");
-- 
2.11.0

