Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F214D27B86E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgI1Xpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:45:35 -0400
Received: from mout.gmx.net ([212.227.17.22]:35667 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgI1Xpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601336732;
        bh=ECwWux75a27RYic83c3058cAIaxb/Sxf7IJ9tnw88Ok=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WIeCoqAOh+p0ZN9BB5W/kVGSkSeacDH6RDK9Kiiskdh3xb3Dirb0yn8QJyp7ADoG8
         4z9KVNkBIAKvFKX/G0N3nl9hCfHZler72rHY+/2D88GhV3UNi0NNnJS4iHDm6R8jxY
         9k+bg/Osi7DY2HDBa3IUuytsDr+wHAnCOfqu1Grw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1N8GMq-1kRVMW0NdY-0149JS; Tue, 29 Sep 2020 00:01:12 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net 4/4] via-rhine: Version bumped to 1.5.2
Date:   Mon, 28 Sep 2020 15:00:41 -0700
Message-Id: <20200928220041.6654-5-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928220041.6654-1-kevinbrace@gmx.com>
References: <20200928220041.6654-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:5KNCZa9kfnP0WVdLImlA3xgvz/RV/uAxeo/ebd21sEm+CYe3Q29
 HZgDygalih7C9IZqlliSEcrlZ1i/eF48xxRSyH+2IAyrJ9nsdPzhyOHA9HkTb6QjLmekzJP
 PP5EQw7w5A1SpnJaHz3TpLBDxGu5OD86t0HnTZvVO0siccJjJ4ueyTbm7IfnFhIpa4gqAQY
 xZbi82UssRGLK24zGopTQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:z1+QwOTUpTE=:ruZpyjr5P80UCZs9t2npCi
 4Ritx730qIGTJd0oWiy9fPVHeCCPIOfxAbGWdwxfwEK4H2zdEfD2LzXmFBqlbYRgxAZUrxLlH
 8vm47iZfTJpTWFNMiCMip0ldYrViZqhz82QdsLAaKKUjvadg702a4zpnDrPolocnfa24Un5xd
 3jLXv8Rm33LBegN6/4xVt6RL9mNOlRIB7Iwb3QcJZYoBexb6fIQ7lahlFtT8MPpNqAT8juwDR
 Ed8Ewl3CLh/5MktLlrMU8Q8pNSgLLaVAEZgmgT3ZFNUIsM7SLAYj7n1CcgCogk9RpHhw7Bhyp
 rLP37cQ6IZASM14J4tXaj9q5ZDnk8ygnCXrj5TfzGOAGWbJzDyLohiYyfKJe9475nz2M0jpPO
 dybWc8uC7hRGi1WVPNWzd7aYFs2JdC/NgggUmrKqRmDwgDiCnL+edMKBtEL9HthEgGbr2XKjQ
 fDAILSoW02knzDpMhICMh2fC9syoN5yug810HdgCTgDZ+68vJ6322+vN4QY8jsGlpMr+SETs9
 XVmEEGwdh59oCqFmoXbT58bw4gMXG5wJuWebaUP0OVCA5K+RMCAhvQZml+v4Olqa0HqVbbqV5
 uzN/UbQfcUAYS6lMrnkw7z1kjPAEMBCYKNf+OUUY3C6xNM6QBq2hIu1mDSL1DwucuaO4UVPqd
 uTbsS2PK/dDv/ZvVauK1yuhEE5Eg37xs+1EqnKVY2krE5u2tju1jz9koLZBqPiiQffsGYQMBF
 EcYSzEBVxjpOKBll4aTkAVOEwmVnpHYur5Jt65fLwLHWRi3pN1eVKHqtnU5YyT3Fdc7xKZBkL
 OCgYoAnMCt0oHMglfCyYC0mO0e2WbiZ/91+Go6pgR9+6WUbWG9xtZ9/fOrhnmdeuR3x4jR9Q4
 7kk6QYiNS9HpbESZZ/QDX2jUofiOBIDKK+xi1oKqA98VTcYiJpGKUDUGGo2KWFSihMI+DL1a6
 1Wy1RMWekh8VIlJCV8WmaUSjuuBa97iGFO+Pa6RV3kfMUX6NvSsvo0LSpuT1O3nST8eztXtPg
 nS0FDZu9+oqKgjzTMQ0N7CkjPhk0s5WWaQF5Ko8gxxoXi+7SZlLPRhNWUWlxMgyaIppLLc8C+
 CE1MTxs6MosWEaiAilSQZUB8d0XXy5e1yMtee1rxzOoCzr4q1F779ymTfEcLiryfPtfBePHvS
 wp1gG9uEllpStdPN/eOQOyBO6kjMWgZOK1epNdLddLDwpLN63YC/DV7i24xB35P1JHRBW7Ewc
 Y8w4ijbW26oYe2sK3cTieDHfJWsaNK2tqFMfagw==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

via-rhine Version 1.5.2 contains a fix for reset failure and hardware
disappearance after resume.  I am taking over code maintenance work
for via-rhine.

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
=2D--
 drivers/net/ethernet/via/via-rhine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/v=
ia/via-rhine.c
index f2ac55172b09..9e2af4bf2f0e 100644
=2D-- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -32,8 +32,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 #define DRV_NAME	"via-rhine"
-#define DRV_VERSION	"1.5.1"
-#define DRV_RELDATE	"2010-10-09"
+#define DRV_VERSION	"1.5.2"
+#define DRV_RELDATE	"2020-09-18"

 #include <linux/types.h>

=2D-
2.17.1

