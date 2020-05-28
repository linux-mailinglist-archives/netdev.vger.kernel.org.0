Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF161E6D61
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407566AbgE1VPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:15:23 -0400
Received: from mout.gmx.net ([212.227.17.20]:51759 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407489AbgE1VPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 17:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1590700520;
        bh=Rfjj4YFlAC0YxLGDBmsLqHfga5JPXz0xX4ukTUivxk4=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=L2kQktOpjxpASIq32e1S1VHEpxH8VWim489D24Z5C9DGEl53qhkLd3q4Y0+QstBVT
         F5MblIcOYP+DFQbY571d0shRIPPqEsphSvORI+dQ7OZHw/jc1eSX3svO1iVHNhh0IP
         Rp6ebtzRUn4F33AxOT5ZkEw/W+drweAzxXXO7pUI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([2.247.249.176]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M3UZG-1jey6M0F3C-000dWS for
 <netdev@vger.kernel.org>; Thu, 28 May 2020 23:15:20 +0200
Date:   Thu, 28 May 2020 23:15:18 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     netdev@vger.kernel.org
Subject: Usage of mdelay() inside Interrupt
Message-ID: <20200528211518.GA15665@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:SZ2pYcnAoX1vJO2lTiGUp8TKGerHOCTwlfdDGi5QgANj0TZD3NI
 DD6ABYLKiI/86mkZgDZ07dAGH37UdFyvjgqU2++G20ppenD5DdGgOVTqMnSuImNJoNZzY4K
 v0phjBHdgrGaLjgTwXG0Vy5yyH0G6rr82ONYT+gy9l1SsvWhPO4qIgOb4nGQmYfcbGLTqo7
 95wPae4Yuz4ZTPYO5cc2w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kYCfh4Fxk3w=:PmY7iVCDxC9TyKpeTlmF+A
 iqBKb74O6iHEYF3md1l9uh3lHrylv5YbAA/kLXeG4GMEA3q37Cs7WDqlFkXg8ili2NKe1GTF5
 b/JPghVRmqIhdawEpmtyQUZi9Sz8ClpQYxdQwZG82UH5+f4OYREoDGoK8Iwvpq845A1mDdB68
 QrVyIqGb5H0q/OIzHOAwpM4Jk16dGHq5XmweXcHR2moBtqvAPhTkFjzcvAoa3dpdAq1CjfT2i
 TWO1jIPBBphZQtZf4FlN/Sk/mvKBp/cslct0Rvlz/CNFiUEew3Af8oGL9NTfMJC2naQLKG8TM
 SR4FSDJoIs20rLT5pMyOR1l26lX459FoE6ORrJZt/bZctmY5URA1qgbCzi0HG75GEE70/FjW1
 ubayo00swMji69ZeyiK1EDwVum5G2Qj7qu/esSuF9b9a2XkUcyRLw0eASwBMOG9g7cpNCoFpe
 RfhT+QbkbnCVl6soeXkcHn1mll9JA4yLcI1d5qDN77zdnE9bWpch1bsFB/qMQzXwOSn0daI27
 0BvXykvSLMFoP+lXURqgl9ScDovHwY5+C2Xt5ufp08FemC+OJt696N50S9lb7WtGrmLn8Rtg3
 G8fXzkt8Co06l4Na3XZqaw/DUDwYhh6RKoX5DKYLj0By6nT+P2dh+E8wHUT7svDE1lwLfgXKc
 mxD90vs2OhQd6llO5gwC60dAzONVmJ545Eub63rkVrsXOhxHDnp6lAOZFotjmaXM9hAkgjC6T
 yNBFyfWJzYXAaHIyNHwVg6fkNUCwZynUYVt4Gp6kLENVY8SJGfpxyPrAhf7oS/iLouI3qOfmN
 0oRFpwrk9KMEc7I77mRHjHYyFkxzhzMn6gZe0+NiHIEwDraNc9FSl4YbDGb1MnIC/SwRholb9
 dU7h6+Zk3ai7uZUCHz8sNlOYUmXrthEIkBFRS//sCr0tV5FF5Xhjv5mLV1hM01875DlArJGXT
 q/y8mWzbvQ2e8deZ4KO0MG5Mj2InXUznyJP5QQE8c7ETd6sPotO6BpVZM4RpgHk+UB8OJ+pEU
 FKGOStnA7Oq565CNVsVvovJRM5Dtj5ljoxbpyyMA8rPI5mtLVMrZGRD8uSztcpYhdTcHPopZ9
 C/kXUXwd4KgsITjibvcbNHIm8LrFTkIEYJSQSxSpn94zop+zqOQfB0UoPw73nIQEwdIqEyqhO
 sY/mPzsx4kwOHeNig9XcaLWaergCQijoEfn6BDdhZ7nkJflYvv/RApavG+vKwdcltfj/c9GUD
 4QjrGQWv+xL6Wprax
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while browsing the sourcefile of lib8390.c in
drivers/net/ethernet/8390/, i noticed that inside
of ei_rx_overrun(), which is called from inside
a Interrupt handler, mdelay() is being used.
So i wonder if the usage of mdelay() inside the
Interrupt handler may cause problems since waiting
~10ms in Interrupt context seems a bit odd.
