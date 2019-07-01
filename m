Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB765C134
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfGAQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:37:32 -0400
Received: from forward100p.mail.yandex.net ([77.88.28.100]:50559 "EHLO
        forward100p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727702AbfGAQhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:37:32 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2019 12:37:31 EDT
Received: from mxback8j.mail.yandex.net (mxback8j.mail.yandex.net [IPv6:2a02:6b8:0:1619::111])
        by forward100p.mail.yandex.net (Yandex) with ESMTP id B10845980F78
        for <netdev@vger.kernel.org>; Mon,  1 Jul 2019 19:29:48 +0300 (MSK)
Received: from smtp1p.mail.yandex.net (smtp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:6])
        by mxback8j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 30Hpcmc82A-TmVe7fkd;
        Mon, 01 Jul 2019 19:29:48 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1561998588;
        bh=LWcSBCOWkhkmijW+vwQrZlV6XLIRqwIu0SU6W4ztBnk=;
        h=Subject:From:To:Date:Message-ID;
        b=k+61aRCEdPUgbWnZJGTvqfW40Y34mHUmI6JGpQZ0WRlLiyrCCegRKhmlCBJRMIBeQ
         6Bnpg0EYf5vnqsG1AoiAAuO8NBQba0M+7OJnJmrtX2JvoPTBkEwPq3gCkb+I6/gJL2
         s7iSp/WnyS30Dzz/wRzT5cDkVHomGSZ0Xu1SwE7I=
Authentication-Results: mxback8j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by smtp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id QczCzjdTbT-TlqGHbKg;
        Mon, 01 Jul 2019 19:29:48 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
To:     netdev@vger.kernel.org
From:   =?UTF-8?B?0JDQu9C10LrRgdC10Lk=?= <ne-vlezay80@yandex.ru>
Subject: [PATCH] User mode linux bump maximum MTU tuntap interface
Message-ID: <54cee375-f1c3-a2b3-ea89-919b0af60433@yandex.ru>
Date:   Mon, 1 Jul 2019 19:29:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, the parameter  ETH_MAX_PACKET limited to 1500 bytes is the not
support jumbo frames.

This patch change ETH_MAX_PACKET the 65535 bytes to jumbo frame support
with user mode linux tuntap driver.


PATCH:

-------------------

diff -ruNp ./src/1/linux-5.1/arch/um/include/shared/net_user.h
./src/linux-5.1/$
--- ./arch/um/include/shared/net_user.h 2019-05-06 00:42:58.000000000 +0000
+++ ./arch/um/include/shared/net_user.h 2019-07-01 16:09:20.316666597 +0000
@@ -9,7 +9,7 @@
 #define ETH_ADDR_LEN (6)
 #define ETH_HEADER_ETHERTAP (16)
 #define ETH_HEADER_OTHER (26) /* 14 for ethernet + VLAN + MPLS for
crazy peopl$
-#define ETH_MAX_PACKET (1500)
+#define ETH_MAX_PACKET (65535)
 
 #define UML_NET_VERSION (4)

