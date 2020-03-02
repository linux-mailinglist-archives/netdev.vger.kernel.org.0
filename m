Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1F01759E6
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 12:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgCBL7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 06:59:53 -0500
Received: from forward105o.mail.yandex.net ([37.140.190.183]:43129 "EHLO
        forward105o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727228AbgCBL7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 06:59:53 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2020 06:59:53 EST
Received: from mxback8j.mail.yandex.net (mxback8j.mail.yandex.net [IPv6:2a02:6b8:0:1619::111])
        by forward105o.mail.yandex.net (Yandex) with ESMTP id 201B14201AA0
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 14:54:21 +0300 (MSK)
Received: from sas8-b61c542d7279.qloud-c.yandex.net (sas8-b61c542d7279.qloud-c.yandex.net [2a02:6b8:c1b:2912:0:640:b61c:542d])
        by mxback8j.mail.yandex.net (mxback/Yandex) with ESMTP id PYD3eq6d9b-sL1K0Z4C;
        Mon, 02 Mar 2020 14:54:21 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1583150061;
        bh=d42kIgfh45qzLz1RN63UIIwddPJm0k5sv1QrfTn4nko=;
        h=Subject:To:From:Date:Message-ID:Cc;
        b=YxYZkmhIrO9tgWAdNPcItK0FAC/8EokeQXbg6FZLucvn0LUmb6Je0BUezzYK2QDPA
         RL9GxsEse0kvfo7Qpout2LrjqbHVEiK2RslQc2cC2yKJ7Eek7ruWVR6+sISlJut32b
         3jTjLb5nKZViL8goLh+ljn8YVR+GP7puftcYbLnc=
Authentication-Results: mxback8j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas8-b61c542d7279.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id d0tANtM0WD-sKIqcTG4;
        Mon, 02 Mar 2020 14:54:20 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Date:   Mon, 2 Mar 2020 14:53:47 +0300
From:   Aleksei Zakharov <zakharov.a.g@yandex.ru>
To:     netdev@vger.kernel.org
Cc:     zakharov.a.g@yandex.ru
Subject: [PATCH] man: fix lnstat unresolved_discards description
Message-ID: <20200302115347.GA1530@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
---
 man/man8/lnstat.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/lnstat.8 b/man/man8/lnstat.8
index b98241bf..f25a9623 100644
--- a/man/man8/lnstat.8
+++ b/man/man8/lnstat.8
@@ -121,7 +121,7 @@ How many forced garbage collection runs were executed. Happens when adding an
 entry and the table is too full.
 .sp
 .B unresolved_discards
-How many neighbor table entries were discarded due to lookup failure.
+How many packets were discarded due to lookup failure and arp queue overfill.
 .sp
 .B table_fulls
 Number of table overflows. Happens if table is full and forced GC run (see
-- 
2.17.1

