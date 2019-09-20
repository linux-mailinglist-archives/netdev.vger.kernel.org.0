Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3018B9233
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 16:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390699AbfITOa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 10:30:28 -0400
Received: from mout.web.de ([212.227.15.14]:52101 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388501AbfITOa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 10:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568989818;
        bh=1Dg5xa7ackOfTJBIlmbUSVHFuIeSMVrSZgfmVZsAy4U=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=VjXZA34Fca497U6gkstlAbOrGCEjIYMdsu+Z09EmXU/bbtGu2SvVcwQUYyJPn05J/
         QevKwrds989ue+PL96YEd4/jdYa0G+A1iYP/tnBjr0McgOjm1MFubzFzmiP8iIR3k/
         d8H6LHmPzIVpkYQ3x3zQfSEg1Ax5ZZ1m8ADBQiX0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LuuC9-1i2YZ922OP-0107Ka; Fri, 20
 Sep 2019 16:30:18 +0200
Subject: [PATCH 2/2] net: dsa: vsc73xx: Return an error code as a constant in
 vsc73xx_platform_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <738c12c8-f51e-d2e5-f31e-7f726cf6325d@web.de>
Date:   Fri, 20 Sep 2019 16:30:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1E6cTDyEGw0he+tMtqLIiPLGc5pVKefQtBnnOArHtRwOy1s09Jk
 ClhEepVwl0uSPcrMZ90hd0Ko02BzgrS5WKljWB9RLXDincJkI8LZtpLF8j0CDLG2dQ0OHqJ
 Z3la7c97X5+ohTjcbsJnT50ZG9F3EEVil62YXfF+587sa9kSL6zuCxPrI+Up5xp1Kj+1fBt
 BQOLeGq96hctApky5rNpw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oXJTgZtcpXs=:Flp5Nv6zYgotJXglNqPN5T
 WdXACv+ho/s0DZ0a5piTSkeHw/HLoXo1pLVpgIe90VEOQuqfgvntMZBlq8BIVto9b2+WiOCwG
 9PUFYrTO9VKBwV3f69CWOVn3JuH/BKy5fgCyBh/Vq+NK9UeW5HlwUO2fp5pSrtot/60IdWfJv
 HKffC200ayfQ9wr8qusI8cRuQSMgWAOfQop7hrjlybR+n4GT/OgxEzVhIYUnxCw2bOdy3k33w
 8d2qd2ZiPFUyku9g+kG+nqNq89KkG+JyihWgu++5Tx7kLaZbCRbHx0dDD5KERLOS27uv2o/xJ
 3MJkrhnVQlmI7LChfCgZnKnZKJngWq0d5/U6x9fUPoGPQejW+XQQx3i5pw+G5e+58tSbKWAfT
 M6T44vIfif0WECb4ZKZG3Uk4xB7e1gCa+TIp+rJ7zvXPvCp3YTzVsz/XvZTv+6IqAWprC6u5A
 0tN5Yz6enLEwW2LUlCE6XPky3+A52VraBGV/MhRklYtSvsEBPUJbHZko1U5JD5BwftEiWjzxi
 YAqFYtcrNveVB99zLOt5ZesExWTiNA6PA126VxUBjuTQr34fp7ZIIL9ZcXYlUVJh7TpNZVjdL
 61HqC0SATExaAUt8mhnuHEIWhhdpdgs61VQMnqOTgHHnf+/Uve2UKf9wFDv4ulT12Ohqi7U8l
 D+QyFeY+nOCr2iIwo+5TX0rX2SWGM5lnVJEo/78Dh+wsc6OoJkWdUzFRG2E+gY3kP9gfhInES
 HcNehsfZQddxb+3tTPFZXZAPunHz6fMC3KQ07Kto/ELr1T+WlM3oI3vbQoPmmwkkArLshH/Tn
 +1QeTt4JcUq0PTEQNpIFE5boGXhhWse8hHp+d86/7qzYR280eiD7vl+YEj4jbHSje0IPl/UjM
 eSFp7XFr90snRJ71nTVjZrb07u45z0GZmM2g4aSgJpxlkZSBU7Y34SbdHmYsqWa8u1jWlR6OK
 nxkfbySpwitaJzpRg3TE1og4pV76tNOgTdfY22/MIbZF3nA2XVvwpqSPCRtZT+hzDDJ599GKW
 zQ/vtBgtAV2LeoG+4NJiY8AP5EwPevp0VSyGQH6uYKi1gSl3P/NTpht8rQOy1uc6aBwVrSMcr
 nlQWpr8paG04vZMDNuSFcEjdPDa1ZN81xriZepa2Sr/KqtMTe+W3H3VmIZgMso1lNCaKsPdfE
 9dLbudBO/MKryUrTtpzBDPP8py6quoN0ucZfPnkukd8xvymR3Ig5J0qqJQHycueu2w3/o3TT0
 ELGQtPUekhzLgXaaywt5V8skocTLdAdGErvd7Xn9rxdY0MNEyh4CS597svAE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 16:07:07 +0200

* Return an error code without storing it in an intermediate variable.

* Delete the local variable =E2=80=9Cret=E2=80=9D which became unnecessary
  with this refactoring.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/=
vitesse-vsc73xx-platform.c
index a3bbf9bd1bf1..0ae8d904ca85 100644
=2D-- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -89,7 +89,6 @@ static int vsc73xx_platform_probe(struct platform_device=
 *pdev)
 {
 	struct device *dev =3D &pdev->dev;
 	struct vsc73xx_platform *vsc_platform;
-	int ret;

 	vsc_platform =3D devm_kzalloc(dev, sizeof(*vsc_platform), GFP_KERNEL);
 	if (!vsc_platform)
@@ -103,8 +102,7 @@ static int vsc73xx_platform_probe(struct platform_devi=
ce *pdev)
 	vsc_platform->base_addr =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(vsc_platform->base_addr)) {
 		dev_err(&pdev->dev, "cannot request I/O memory space\n");
-		ret =3D -ENXIO;
-		return ret;
+		return -ENXIO;
 	}

 	return vsc73xx_probe(&vsc_platform->vsc);
=2D-
2.23.0

