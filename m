Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75300545D61
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346805AbiFJH2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346951AbiFJH2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:28:32 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A299113B49;
        Fri, 10 Jun 2022 00:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654846096;
        bh=bM7qwrMX5txhavEAHeipJu6JmkjUsYWlTUyj3tUAEK4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Pm7wekgSiianeX1XdxNpHFDLDGgyeSyzr3p5+NUH/qoxz6kiuEoIunYVLheGprqcG
         qWIqXirB/j1ZZqLt+Ql5Jm572xNA0XigG1gOBn6xDJMiN+nOSPxzWn2iWRsCr6VYYT
         j1CqCpASQDDjvNElk31tXa6wQ84uQOg9tKUz594Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([5.146.195.3]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MBDj4-1ntUXG25Xi-00Cgc6; Fri, 10
 Jun 2022 09:28:16 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: networking: phy: Fix a typo
Date:   Fri, 10 Jun 2022 09:28:08 +0200
Message-Id: <20220610072809.352962-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YIXRPmHeDOcYOo18uCtx0Dhe69ABV50rrJAONLwZgjkGbK4Ckw5
 A6urwdfpYxU+EAesm/HdHrgdBYYuvWI7jMKMr/TcBzqqoDWX8wqQRkJba9E8KTjecm7SwxM
 Bmu1s0e5chfZI1lRyxNvYWNusslxUYOQS0dmszwAw5qmyUr0G6nJhGZ0Lt9sDLs4C4w+6df
 MwtBLz8/DxDE+rvrOjnVA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tfo2lx4XluM=:oboDSAj9AMk0kunZSUgaHC
 4ZGTtnRGzAQJOMAY/4qcNDByXiVD0t+tSF63dfoVOS7KSZ2+53lYkw8jREb71lQf5AnU/O97R
 fv18CBB39ZdrypGI/xiD6+cyKX6AHTLpO6uabSWWD8s15cgjmFAD12cnQQyaO03SDzSk5ZlBp
 RlqwPNjpIx3tU64kE+RvdTHYNj3m0Hq6dyXV3MzgyxvRaoZRXrTofxmFzarbdKW36QBOEL3z8
 yuyfXeyR6T54f5SFcXCDeddMVpPhVZO4ddTFPqQTG7yDN/q1gEduI01WxBZKDpRQpELHKaX5A
 raiF7OdODQdJJZ/pIzaNVSfMZ57qtik3CM8jVo4JKFYRFUOtGMC1kQW/EduAJ6ZDUe26L3MxX
 F7W3pvuZ3mW4kjubFAiwPFQmElLCjGBCuKWHbc6ttKCiGrAZYjSLgsUfzubz5z3wAPkUet8/U
 FNb5xajatSNkIPzdH+/PyyVukvZUOlb+GKe7kFB2clYtg4esAYYsaaG/bk3gZU2jCj2lf/69R
 DY+4X3e9jwH+GsaJwV4w8YiU/a9IEbNporpU1Q5pFgPshOEmv9y8B95jVODQapJfMUBU7t3Kc
 8ht/waSTFphIrN1Or+FRXM4iRz9fkdnKYfso1BFgpZ3UfQ72415gZfHdcfmGkvNlGzaiYoXJg
 5VZ1mXCjiYPSwZvfQmDunL20KRg1iQBd+LRxrj76IDdJ5VEOdxXTbmL1zc8LwT4UxVt6EHDIH
 ahqoq8/kWB3SGippGQ9HVTjIOG8e8YoB+Wnu3kQTWCPnQRZVJx1OuwCz7DAIlefj+CP9LSfyx
 s/Vak76ndJloR9ZHNLcFBJl9TvQSbcjxY6oInAfAXVXd9A847RLxoktaOrJXg8PtbE5NYoa/5
 fyt3euQE8Ru88e+GHU0ODmK52DO8+0RrCjkpZeBzj2dOan9ef2LQsTTSy+jVlSubV8YH2ibvT
 bEHSaDv+F5cekSAp8zacP1g7iRVrCBhyw0Cyd/T9bCnLEyhSp9YPoXVWpv+2HE1bfNVZeVBrT
 zj7hewydzl1NU2qFycs6FlKYLT6YYwDyA0+7PpYYPGrTIxd4YV8vSzHSp5oAzTxceiVL3TM7O
 6J0hcZuFjzNLMZATrDP+XLncCieVXRw6nuA9zRgHh6UZK6As1vB3+fH1A==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Write "to be operated" instead of "to be operate".

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/phy.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/p=
hy.rst
index d43da709bf40a..704f31da51672 100644
=2D-- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -104,7 +104,7 @@ Whenever possible, use the PHY side RGMII delay for th=
ese reasons:

 * PHY device drivers in PHYLIB being reusable by nature, being able to
   configure correctly a specified delay enables more designs with similar=
 delay
-  requirements to be operate correctly
+  requirements to be operated correctly

 For cases where the PHY is not capable of providing this delay, but the
 Ethernet MAC driver is capable of doing so, the correct phy_interface_t v=
alue
=2D-
2.35.1

