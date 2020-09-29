Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9472927D7B8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgI2UKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:10:13 -0400
Received: from mout.gmx.net ([212.227.17.22]:38599 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729105AbgI2UKM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:10:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601410208;
        bh=kOKiJXQ+3TeVc2ixmu2j3vWtMg4b4ukBmC5xheBXpSA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XQvmEkd/tWKRM7HeKV5WbRXtFQgATYAlrjO/hF08c+3UisRMQWrNkY7rMhx6o7OQb
         hseCWp/+fQ8eOUwQe1kG3PSmBV98hc7RyrHrsIM9tij1ASuq+6fRDqEbZeVeA1KBDv
         7fe3vIIO9XaLiP+zjJE1/rmPHIkJ6IFee6o6Lsyc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MWRVb-1ju1nI1WOp-00XxQs; Tue, 29 Sep 2020 22:10:07 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net v2 4/4] via-rhine: New device driver maintainer
Date:   Tue, 29 Sep 2020 13:09:43 -0700
Message-Id: <20200929200943.3364-5-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929200943.3364-1-kevinbrace@gmx.com>
References: <20200929200943.3364-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:tklC/BUjPyEF2mozpSfVyNll0g7TtLL57ksZ8EN+RaI8j9Jm07g
 VK9oUI9FmJbsRkaNAKKkiG1d0BDNRFqXajBMjoOlJF8qgf88eCmukTXSdLnTqoUUNwQEU7O
 dXlYdwnOAs2Ftlfi29SP2NKXxsjsGYMHqfCpvpUQ5AoBl0hUOAPFph2iFgqu77TyEL6Fnw6
 m8YdWdV39jjbOX5kRWHmg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:l0ucBDL3QcA=:TUqXMneBXo0SdmyXTMPtb/
 vYiPoFFJLc2XYIy1wEoC44k6dcnO97/lQZ/letJ/ZhybyHgjcmZEMEzJcZAhdS1sUEa1bMYg8
 M+XVME9mCWOGhZV+OYDHVWpuZtph1dZ+6Jc5AqEfqHGdpl0J2FPrF0/NPoiaDfFSWSIiXfbWs
 /a1B2N4gO9lZOlZ9sSrJdS1yX8Q3jvsgOJtJdV1xdKN+6k5jcGxjrF07IRWe8KRBzRRXsEY3D
 RkYXfNnswvtyMS1wmzAF76znzLiwp6S8FkTWGY8+jBLj0smMttkZQu1EVytWaUaE/EjradCr4
 PZ/G9uhjyiAF9l/Z/9Wwp2b4zhpTHRIYyt8Q0N9I4tCy+tBk3Z8OyhMccYRKYZVh7FxqrPg21
 BGefRGIPnY73gjpmzyCjq10aoDhe/76JgImHa6P1kpsyo+wZV0+uX0Xm3La12mPEB3Q/JMSZf
 fzAd50XW5xGFjsjEgehGtgmfPXtRrdBR5rcCNRrq2pRcy59TU8o0ULMFUSSZpXG+oJuE3n+7x
 x9eLow8+52J+AWTMzJ0zoMHbvUtPj3UgxW5a2XyHqmHOPSYrbqa+MEdxbAzAxDut9o3bbjd4S
 HkoTaFjZJaxdN94mLwHDEqoV/lN0L0Yb5rKy5/wG51bv/VdJDvypS7WiBYah+yLEPFNnbf4th
 sZTsK41Nb3ktMvsjlifcXLOL1fnme2t4atkMz9zY38ookP1Jzt/vgISDE/kptDlfBxzkcdmXU
 ocLLo0RLHyoWTfJsZgY7mILgFNjDNZjKmMeDSXiNlHR3iZokOvvadh3k3rU/fkMiVsPxPKA9d
 CNVPfWYEh1NToDgYyYsWsbYKBC8vQP9TMBiHsSb3XStApwEY8Smcx6i/6kq/Gx9aNB5I/KKCx
 0atJubqOL+YbPn27UvMxDdLHnwosY2Tcwycm5NpgXK/EDLgT08LWo24TmTFM7OOYOzseG4Yhd
 yXYWdnH8rVVEC/CdqSBtGxhX6g3nqQ2ng1fyBrJay07MQNfeXPMVu0oJppBpj4DUjoOFN8WFP
 DADNp80WmzgDGLJ4vwyIT6grXOMuZBi4OMtM+aCzPrBC1WvxptjTwqntKf1WGGaoeQn6oEt9Y
 6Jy3ky3VlVKPxbiWxTrRpSwYcyTEr2WJl1AdVsNa32+uPkioQuEgOptVbEsZxZ04se7zjMQ1q
 5KDIRCnyP5D0Io2xwnsue7Q1NNNotkfCh18VfZanazWnW4sMc8W6Sh6bvl3qxiDuAKiVo5Lgm
 8yt2kIPqHNKwYiHzOGjXrOpUNh0rNomobs74G+g==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
=2D--
 MAINTAINERS                          | 3 ++-
 drivers/net/ethernet/via/via-rhine.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 153f7b3419c8..3e5ae3185847 100644
=2D-- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18058,7 +18058,8 @@ F:	drivers/gpu/vga/vga_switcheroo.c
 F:	include/linux/vga_switcheroo.h

 VIA RHINE NETWORK DRIVER
-S:	Orphan
+S:	Maintained
+M:	Kevin Brace <kevinbrace@bracecomputerlab.com>
 F:	drivers/net/ethernet/via/via-rhine.c

 VIA SD/MMC CARD CONTROLLER DRIVER
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/v=
ia/via-rhine.c
index 8e8cfe110d95..55b0ddab1776 100644
=2D-- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2,7 +2,7 @@
 /*
 	Written 1998-2001 by Donald Becker.

-	Current Maintainer: Roger Luethi <rl@hellgate.ch>
+	Current Maintainer: Kevin Brace <kevinbrace@bracecomputerlab.com>

 	This software may be used and distributed according to the terms of
 	the GNU General Public License (GPL), incorporated herein by reference.
=2D-
2.17.1

