Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8302B2CD601
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389088AbgLCMuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:50:55 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:39307 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389048AbgLCMuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:52 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MEUaQ-1kwMUn2U7W-00G3at; Thu, 03 Dec 2020 13:48:07 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 04/11] drivers: staging: goldfish: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:47:56 +0100
Message-Id: <20201203124803.23390-4-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:4VMUivbUOMUD8OthMTSocKelq1MbRgHbaY3f/G6xITxz6Xk22M8
 uEHUC/m7pcHhQN7/1teMHnGJ105bj2MFxIG8OKD8iMvw0OijeR18OxT+t8B0FkJvqbNflL2
 kBIVNRlu9uGg7FSNGDM3EvhgOQpvUQ/ujKwC7A+tlDShQON10tV25yv0S6bLDTnEhdvdql7
 Mi+EHZ1SnUSeR+e459RGA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/ZThhDNRtBg=:nhBRCngE4HdS48BlApC8N0
 ONTzsyy9ujSC4Xeo4w9hxz3+VWhpmVANsgQOAJXhGAbxAOONikbDE3xX3mM/8A1v7qv0GoM6u
 qhcDtZyGVu9+gbScyuV0g7+9cqiYQhwEG5DTqQNb59qfKoSvttrPrX8Uffz5UwTNqtScGHHBF
 IXtFSlwWy87137LwHju9B1fgIG+U87TnNu+8di0HDUUpRD8RgwUjOEOkAAYdQBmE6EDq4C7iY
 ZYdyZ1IHuiCls74t1twRXYX8JX674vhxqqi1e1MaWLfxL5xqY18X7eH4TFkn75hWw3zPyLuig
 vy7NQcwZDhyQCYwcRQoUUDmfmZIps7uRuz330L3JPoqP8CpqLeZKXdZgPkpWAuygzScxOZUmi
 9Gr9AGejryjR2VV6Qgia9N7SnlGfrYRyoQYAjJXxomK2+nxFUhlJ3QSHkbP7k
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to have much practical purpose.
For in-kernel drivers, the kernel version matters. The driver received lots
of changes, but version number has remained the same since it's introducing
into mainline, seven years ago. So, it doesn't seem to have much practical
meaning anymore.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/goldfish/goldfish_audio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index 0c65a0121dde..4a23f40e549a 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -24,7 +24,6 @@
 MODULE_AUTHOR("Google, Inc.");
 MODULE_DESCRIPTION("Android QEMU Audio Driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0");
 
 struct goldfish_audio {
 	char __iomem *reg_base;
-- 
2.11.0

