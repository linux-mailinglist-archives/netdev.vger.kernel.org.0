Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8218C05C
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfHMSSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:18:48 -0400
Received: from mout.gmx.net ([212.227.17.20]:59139 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbfHMSSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565720284;
        bh=Vq2Rwn6ZpDvdbJzC++Agdo9RfM34OqXBHgokRaHCjmc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=WTj/ir7EWEPBhjOfci3nIob7y7Q1LoWiIMlCuv24p4jOapHe13C8kQP1MU3RQP9xU
         vVQ+vqLusWjOoEXRPfVS9EXx7wyyJTTjfgTSEPwe9oZdokO58Uz1A2VYizXKlaN7Dg
         x2cv1Dd1xOY0LA4dMH2gYzdZ2M9ztOBzoOuXZECc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.106]) by mail.gmx.com
 (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0MSY2q-1hpnKh3mBI-00Ragk; Tue, 13 Aug 2019 20:18:04 +0200
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-hwmon@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 1/3] nvmem: mxs-ocotp: update MODULE_AUTHOR() email address
Date:   Tue, 13 Aug 2019 20:17:27 +0200
Message-Id: <1565720249-6549-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:ggoDPxD3GY7PepSw+ctdpLrl9Y0S1aRCjm4mFCxJFfmatdyhLMv
 gQKCUttMR8MgugL3SYZ2iq96h7Lf+bYGIB4yBaRwN5Vk8ECnW/3ra/jpu88CzXnkGskboOV
 tt1BYCRwY4h5TfJGVwZObZWKs/kHuVwwLogYL8GQRhwOnNMB7WBC2c04E8ZGgxUXDpSBYJE
 inPKHKeIaVdlIIdO493Hw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FquO+c5eQAc=:oWHph4cQRWLnygCC2s+DAJ
 KzLKi4uLouuuF8GVsW+JuZf+JT8qOhhX+M8HHg4ISWTwTggQ/88i4v1z1L8rOqtpjr8FzQbqn
 tVzN8dsDs0Qs0INEuJB9JoAjZZgABQJ/8GoLzf4fkrHSHchjM8tZscYGdedU5Hcz82pMq2x3B
 LhnwImhLhZauw1zbCReTPhleCxPzUvHj7Slg4Jy8Hr03QA5s0W/YdOuU8xtVe5Y0EHxC7LsT7
 Dn22kRzsngfOIV3iP93/WslGLrF57bApI+gdn9AlsKkaWWG8mMuD3Lu7HGumX1ld5zTgWhJc1
 Ml/bU6gCCn3RaAz3tWW8UGL1qjNHfJRpLVA3Ig3vVsdQX2UKQFQK2jTWL80Qo+3JNq8HWAbDA
 Ow9zEBqHmFVMn3k4x6DRCwL+kDFl+CZQKTjJ1Q085MPNb2Qrvu0/3u2MZEEADTdQpDIdmkT3I
 eemDTG7WQOEaqgSxTJXGrrez3WVBTQzA/lbFulhiyM9uygyRxNx0L75EydKZB/qSwqjZKaS5z
 JgSgoHIiUZeFPADSUKUNpoyhSHcZsJc6lIGRqbH4HfO7/SZzPc4d6KhPBdWgZtizGC+IQL3NO
 yViNAEzK0E3o05spkTh6ShkHhlyXt1gGNePwvNo1Ie42g7VzJ0GmVaLpesQJJjYlRi013xGH/
 uZ7PVe6J0JTGLL5yq8EyOkhn8A1dJxm13EUijNTtX8LT5lYCJ9yQaTcnE6OpkKQO4DzPDzqpC
 QakBF27rkY1YIq0r1xBTS12aspTRWi2q7ac/0QZHYZypPKXU8Oyr5jAMDJw/o7rL4NrP3/3qR
 vxaU+UMgImqd69i65UMH+jNhNXgsXWVGBV2J7HpEXN/oOI0kg8NeWCLWiX/UXFmRtLRQX43Ax
 Vxz6RqcJvqQ6JtmBQycSd5/iplhipnsShUUbvTn0wM5ImSI8qSJ+83ksDxUw5p+cyQJbq8YQ1
 SvG1+vMhd2hlk/LujgOnultEYTWu2V7UlrcdGYBOAsKmFC0C1SKDoIKV+FoKtcaNHsdSFoy3E
 2wqSi6pmgWoKFmF/UqpSLXe6ZbE0XaOweQ0V0CHPz+RRziCNhCeEzkxPjHBB5O4vt9v+TXJaA
 AJZAdQDsOtgICLm8SCTzJimj0pkZVXbbQL077tNPeQ8zAomIyHyv0bs1tOY7lqrEahzfNvBSP
 EAa1T7vDowUaDmVZ+SJ49fZkOmfm+aagWgAslo6bf+tAFP+g==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The email address listed in MODULE_AUTHOR() will be disabled in the
near future. Replace it with my private one.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/nvmem/mxs-ocotp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/mxs-ocotp.c b/drivers/nvmem/mxs-ocotp.c
index c34d9fe..8e4898d 100644
=2D-- a/drivers/nvmem/mxs-ocotp.c
+++ b/drivers/nvmem/mxs-ocotp.c
@@ -200,6 +200,6 @@ static struct platform_driver mxs_ocotp_driver =3D {
 };

 module_platform_driver(mxs_ocotp_driver);
-MODULE_AUTHOR("Stefan Wahren <stefan.wahren@i2se.com>");
+MODULE_AUTHOR("Stefan Wahren <wahrenst@gmx.net");
 MODULE_DESCRIPTION("driver for OCOTP in i.MX23/i.MX28");
 MODULE_LICENSE("GPL v2");
=2D-
2.7.4

