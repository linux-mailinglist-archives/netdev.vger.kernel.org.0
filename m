Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199F9381F56
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 16:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhEPOxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 10:53:15 -0400
Received: from mout.gmx.net ([212.227.17.21]:51929 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhEPOxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 10:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621176719;
        bh=JHtFNpY6yauLebNSfe+YG3nn0zTR4q3unSNYar+fztk=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=UFg1FFxbx+GKnIvzKEw1BntrgnRnkEp4ZCj3TsVvPVfogWNC01ooGnUWBMA1eIqXF
         3VrrzmT6jri3nZ5yGN7vbO3tncv0/Bdx7ZRawEVxxu2gynXvZpfi9UGeZjaCVOE0Zm
         i2m4Dxmo77UioslLiFAsF5CsKRLIfu80JlOKb+/Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.74.199] ([80.245.74.199]) by web-mail.gmx.net
 (3c-app-gmx-bap46.server.lan [172.19.172.116]) (via HTTP); Sun, 16 May 2021
 16:51:59 +0200
MIME-Version: 1.0
Message-ID: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     netdev@vger.kernel.org
Subject: Crosscompiling iproute2
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 16 May 2021 16:51:59 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:cnv/uN3HSs9V722ENvEnUc9ArnnOWsuT+CQo0PaHh5E6kBB/g8XZrPmnKCEY3Clnx89ZZ
 lF2H+ry8oywoDxthUXHMi8rT8+Z7qk5KPdRZ6Cd2mFvX7wd8zsfTjeDMFgakVtfi+e0dTmdlLC4s
 5z/Ldf1KEQQndUXIw0DuBECgVA7PASZTxiavEUifACC0FO47eGAxWTiDVG5LLbVJ2Yt4KyvNkO1g
 CPWD1mX5KGb8ptzXeLlotvYLEGPMN48OhzG+n126naJo3b2WAeUbphSCL3HEoMdG9dGoPzOm5z7s
 L0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XrdPHXzsriA=:i1N8voSybBCmmqd9sEghze
 /4FrGyEHz9jy/DIgcTp0cfOIjYKOCQF/o60/n3mClUBDhAH5mrtTulMwb/6HS1HvT2pN1CAIS
 pP0uSzUT5njl+ZelAFvbeJzXBxfk+H6A0zKML2sVHUzIR2k0JOfZDFY+8OTRVr2hMASwvFga9
 nKQbAgPnPqiU6tMAIedu7jBqzZPQWqGSoItWqg456TXWlBlPz8V2GDRzJm903LmtctMs1MlfR
 h+XoW3XWLuKl3Ve90qNOj8nddyESB1PzZtbzBa7ic2xyVVtVDKjr42dTxs2/ixrOLV+IEuZs/
 dmj6AbRDktRJv90c/X22lKkhWT7BgN1NvMC9al3N8XYOfsTqJNJ86SG71lyX48bZL+Acud7p9
 FKn9Z/VwbueIWRQ0cowL7CbC6/UY0JaPJI26s/u9xPV5mWjLEheZD54I+1WaNkOdlDoWz8X+e
 iYTv98zU04rWIgbTPk0UodgjUUt8GaVUXM81MZcUGsM+F8RBz7ywYBgqB8bZvQpu1Sp6FsqqY
 qskT7vcZFU1RGmy0INdAtd91XS44nUT+Drq5OTup+P7+NNkmhhuQ2MFnpMdXgeBJ9BvKONKvO
 OVlY2zSQoGkql33La0gYdoVOY88pmnu9C+pauBWZRbvKdMlJvG8HL5RaSCps2hXevyI8qVekb
 knlXbO09u6POeXvChh+m460ZmpY5HYgTpzlL5yfqBABVHiwn8XFIqHVvtB1TnTIBOX80xChyq
 aIeCG/bi9coUbGFE0qgyt4NM69SNk29lAurKE3zPdjMamFIwICK8hMk7tqRBnjDswQl2P6yS0
 pBwAg4AH1ucay7mC+/GccFr/ccEBc+W38iTBzO+RxA9UrBcD4xri5gFw4jXDt3kMSVRuU45zB
 JkkpbU1No7Adw0NgUUNgwhElI9fDXdtXOu7KDrRmbAYhZrQkRvSoXwjMkntMQtrEnrimdUPE5
 gHecpil2wIg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

i want to crosscompile (a modified version of) iproute2 (git://git.kernel.org/pub/scm/network/iproute2/iproute2.git) for armhf

do you any idea how?
configure-script seems to ignore "--host=arm-linux-gnueabihf" like i'm using for nftables

i modified Makefile

-CC := gcc
+CC := arm-linux-gnueabihf-gcc

-SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
+#SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
+SUBDIRS=ip

and run make like this to use static linking:

make LDFLAGS=-static

but it seems ip always needs libutil

make[1]: *** No rule to make target '../lib/libutil.a', needed by 'ip'.  Stop.

if i include lib in SUBDIRS i get many errors about missing libs like selinux and mnl

regards Frank
