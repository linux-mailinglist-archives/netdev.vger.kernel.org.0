Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D5C28503C
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgJFQ42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:56:28 -0400
Received: from mout.gmx.net ([212.227.15.18]:60513 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgJFQ41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 12:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1602003379;
        bh=0hiowMUE7/1wGUQ4AJ3LP2zroFobVTbmeN2RN5EcecA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ATCsywr/AbCJ8s7wIe0KueQzrFXL4asAGFZb3OwgYUal85fL+gvtnsz/IU4PcCGIo
         j2ZkrEgboKeEwfivSiM3KRsZj8AlUdvx/90fiQ6vVJ2Tnp2eClfpshdb7uoQWbmFpT
         BFvsXi3BhsBzFXD9n/U7B1k45gcwuYI0XfHZO0pU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([84.154.210.207]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MK3Rs-1k5Zr32WvG-00LUKy; Tue, 06 Oct 2020 18:56:19 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] ne2k-pci: Enable RW-Bugfix
Date:   Tue,  6 Oct 2020 18:56:06 +0200
Message-Id: <20201006165606.7313-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HMlnoAD+ccJI2do879khdjDcNS9Dmw8uNvdrO892y8GBirJXrZ0
 caH30Hj3Oe4ck2hX6HYHoX8UZShK0HIKpcGNekdZvwTTuWkR2GEKOPgUoJFVIs8sfPTpNlJ
 Vo/Yf9lbc7x54jVbs0rlV0lX9wXsb+qKW0yca5iBmLapkatBXrYXQg6giEfv/Ag+vU/LkfH
 GNuYlrwbZNsxqk6a+8jJA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2KM2BC2DKq4=:27FYZHe7lqTnJOAmN5imdY
 6FaTJE0hpZBkAKsa2RZkDx4PB9L1xkzeDjYpHVD8aSMuqEOQZIR4IjOzgyRNFzKOA/AOkorZX
 ijZ9Wm7DGWr8g1tyNxn11CmkOygotmS5CM2cwmC4L6+yDvpH6C+BUyog9UPEu2U0vJLD+EMEo
 3mSH4rxN6+A0FgPFWrM2NMapLgL7j72B4sr7NA+t6eXzRUjIiFRCD7p8vk0KJgFgS320FE1Jy
 bmNdYdRxyVjOjLSlXqTRJF8IhGz04ARIp3lTIht8EUGndFTUzVqJvtf2Xu/nhQvUs/pftLWlp
 ehcBPERmQaLOY147KWzsf9+VZ8y35pcAD7eKEEQEcNTZgNC0QpSqprMytXAmgmQ0Ws4RSAYIG
 lM/W9UWObk7s5DUH17kiczRipbLQ+REiw6zDFH1tRk+i8owtXDrolZ2ib9Cym+rARY7+j1g+a
 EFo080dY5Fn1+9YrXfFXlFgVP0h4mP1dTnWEe0SxdEkHGLCVdyk3LqPKXd6TZ7pLWkjhNEMSf
 X7VPHK9i8/D/DS3ZiJeRKhxEylW8ayCNFsQAo8Gez2aH28VcepQVAW/JUOiDrkxKOWFgbf0//
 DT3/LAxS2hGaOVg3SeoiKzjYcZyH4xAVsndGZy2hqC5YTG33BASKrO7e8rvF9tLyZIo8DFBS8
 LgNzCVqT7G3+HL7S5xOGYNCOhXO4M2a+ayXQlDO8UvO00Gxeu691ZajbFM0yByfd8NLq4X9Iw
 yPcPnDqcpJHXlDa6aU4OU3JUSzgWfgGtB9yeZG2Tmz4uxoa/P/NPbWlJAU/WyqLPdduidJW4w
 IUtW3epoKy/FWJ3FaUde5UJ84TdjYr4SLDDqM3Hc15sFemPOP9lg+vpgVxWquGf4Zje6abzFl
 /Bm9hHDAAof6Xr8oqu0TMuy+NKIlqqwXaJezdA+1/YmDzxcX/Eun1I+nLBKHaIJwndHT/ma7j
 rR5TciN/5Fm3XceOgOjGORtxcF9AFdDJyPABYY905xHP71abCkgpZsglW5SukEwA/gE7hJyIv
 /2t4/006CQI73CMfSTinTLRC3K3c0eFv7Jl4WzXHbuZLleMM3N+fZHW7tGArTwjGT1RSn6cNL
 INrGkK3W/dFlilcuHZPjSpseGefsMbZJfyRw9o64+GA9pxoCiRD27jWsALJFywlC3o8BIQKXh
 BLMDNtRAgw3MNeu1x03lBlTc3TmHSeVe/ccrOitP3ibKijI/JoHfXjOJJfcaQfsEc2sCFK3n9
 Zgi8+XVN5HzJfVTMs
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the ne2k-pci Read-before-Write Bugfix
since not doing so could (according to the Datasheet)
cause the system to lock up with some chips.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/ne2k-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8=
390/ne2k-pci.c
index bc6edb3f1af3..a1319cd86ab9 100644
=2D-- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(full_duplex, "full duplex setting(s) (1=
)");
 #define USE_LONGIO

 /* Do we implement the read before write bugfix ? */
-/* #define NE_RW_BUGFIX */
+#define NE_RW_BUGFIX

 /* Flags.  We rename an existing ei_status field to store flags!
  * Thus only the low 8 bits are usable for non-init-time flags.
=2D-
2.20.1

