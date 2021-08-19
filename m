Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3303F1A98
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbhHSNj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbhHSNj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:39:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6A9C061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGO-0004Gk-Jy
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:20 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EA68466A7E2
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5FDCB66A7CF;
        Thu, 19 Aug 2021 13:39:17 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1c9053ab;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        socketcan@esd.eu,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
Subject: [PATCH net-next 01/22] =?UTF-8?q?mailmap:=20update=20email=20addr?= =?UTF-8?q?ess=20of=20Matthias=20Fuchs=20and=20Thomas=20K=C3=B6rper?=
Date:   Thu, 19 Aug 2021 15:38:52 +0200
Message-Id: <20210819133913.657715-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthias Fuchs's and Thomas Körper's email addresses aren't valid
anymore. Use the newly created role account instead.

Link: https://lore.kernel.org/r/20210809175843.207864-1-mkl@pengutronix.de
Cc: socketcan@esd.eu
Cc: Stefan Mätje <Stefan.Maetje@esd.eu>
Acked-by: Stefan Mätje <stefan.maetje@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .mailmap | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.mailmap b/.mailmap
index a35ae244dfda..6e849110cb4e 100644
--- a/.mailmap
+++ b/.mailmap
@@ -229,6 +229,7 @@ Matthew Wilcox <willy@infradead.org> <mawilcox@microsoft.com>
 Matthew Wilcox <willy@infradead.org> <willy@debian.org>
 Matthew Wilcox <willy@infradead.org> <willy@linux.intel.com>
 Matthew Wilcox <willy@infradead.org> <willy@parisc-linux.org>
+Matthias Fuchs <socketcan@esd.eu> <matthias.fuchs@esd.eu>
 Matthieu CASTET <castet.matthieu@free.fr>
 Matt Ranostay <matt.ranostay@konsulko.com> <matt@ranostay.consulting>
 Matt Ranostay <mranostay@gmail.com> Matthew Ranostay <mranostay@embeddedalley.com>
@@ -341,6 +342,7 @@ Sumit Semwal <sumit.semwal@ti.com>
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Tejun Heo <htejun@gmail.com>
 Thomas Graf <tgraf@suug.ch>
+Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
 Tiezhu Yang <yangtiezhu@loongson.cn> <kernelpatch@126.com>
 Todor Tomov <todor.too@gmail.com> <todor.tomov@linaro.org>

base-commit: 19b8ece42c56aaa122f7e91eb391bb3dd7e193cd
-- 
2.32.0


