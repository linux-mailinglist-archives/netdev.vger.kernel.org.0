Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A0C33D8F3
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238550AbhCPQRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:17:43 -0400
Received: from mout.gmx.net ([212.227.15.19]:56727 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238541AbhCPQR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 12:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615911441;
        bh=t1eWm2oQpCC1c0NIOlF0f18NVJvKps/sDSZ4DlifkSo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=eK50uKCnz7tGqSsC+71i4Ntj1ozF6PmBpMIPoad5sDjD7O+8dYtQX9VxCkcJeyLvF
         67Zhqc3Gh9O0HNoKTtIS3/5G2fjcbeCAWWbcZ7mLZru+UDFTGGUapNIKo8Bjl08TKw
         ibASGpg9yWQ1t2zkm2OTu+2VthazBacuGywgU1aM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.77.133] ([80.245.77.133]) by web-mail.gmx.net
 (3c-app-gmx-bs08.server.lan [172.19.170.59]) (via HTTP); Tue, 16 Mar 2021
 17:17:21 +0100
MIME-Version: 1.0
Message-ID: <trinity-1d5e191e-69a4-41cd-80e3-f689ede66daf-1615911441288@3c-app-gmx-bs08>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Aw: [PATCH] net: wireguard: fix error with icmp{,v6}_ndo_send in
 5.4
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 16 Mar 2021 17:17:21 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210315132103.129386-1-linux@fw-web.de>
References: <20210315132103.129386-1-linux@fw-web.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:xTl/7g5ym5mtf19P92ixeMhAoFxZ81eOvz8VH4RjEN6VUwIDhuIOfbxVwDQbxbliUm6bJ
 UaSKd2APt1bAC6HeBo65hVVpvsz8qw1J42pGIgTQf1NWATJThDTPEaaCK2IaSMdAUgiuREQuYKqv
 q3h0EPtGDQw7Opy1vMNYeX+nFO4tO76ia6MZYyD2RSnTNIZ7/U/P0QKw8qXE7dfKHiEHgZ1hDKxe
 1xVjDtL4eTFanqTvN8563eRuhGQRGU7HT8AGSP8a95cnKn2FwkomtL/xChsjJ7eM/9+lFBG3cafQ
 3Y=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BicDGzdy0Bs=:k1RtC5hcJ1WIZE3mp2Sw5w
 pwyD3A5vP9IzM6rb8Zn0prcmr49/WMed+IxWt98Q2e/ZFqLU3XIFmDcbfYYkbURDd/pKRLE/1
 uaQfbWNvfQysMgTYS8MXb51jlKod8W+vr5F1jgfcQKgVHWR3Z9JQunBWF/oAkVuscM7rYWRTf
 9r8YCH4/djofKnJKAGVnT2qixfRtuHnUnF3HGuEAbrGJyZA53axmj2kFtwFs0TTZH9daCdEyU
 ViocfHnec5uOQRIiv8trdpHLFv5t600FfgLytATfoMOs/M079MkzykE60hpj2/U8uRtu1cOdV
 1U0ktHvCIc+qd3ZaQfKK9S1fLACZNoX5NVx+jI8/ckFwh144Q6JJJ6WHQ3tCHEV2Zkw17/z3s
 QFARFNhvxbRQhOH/J6DiTn1cZVMfZkegsYyyiHJTxhKwQuvQ8ArAFhmLGB8TtCTkvvi1E4w1f
 DYIu02w7yCj/DUNUy9tR++c28FVSk++CFXUP6792w/LhKiu29BJ+eIHx0aH3Ke8KawmuHjacm
 CyRYgvlFuYj2mqdsEIYiQ60qwSSwg8CL4EntliTFAm2JJuSy6RWodKUFOMnHkx1LzrcI7KLTI
 wck+0Q3UcD4mw=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

sorry, please ignore this
wireguard was included with 5.6, my 5.4 uses external wireguard

regards Frank

