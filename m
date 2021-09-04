Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE52400B35
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 13:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhIDLvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 07:51:33 -0400
Received: from mout.gmx.net ([212.227.15.15]:54833 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234695AbhIDLvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 07:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1630756195;
        bh=v23ee+m+JJjtewkqOV9p0pm3JlwVl9WxkFvaAGuX1Ok=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=aFui8fkZ7Z58f+hoFtAARRQYR9O68rtrzMTniksFo0yE+lIEfO8ModCfBVi3mXR5i
         EiOQClEbqBjrK4Gn5fkW3frJ1W1wJ28rxOIoMIaAkazaBm4BVzWTUpmsjw9B6B7DvV
         +BTYZq34iQwbt2CERbZuU6dSHBuhNNARphYOxqDg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx004 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MNKhs-1mbF5F0Vek-00OpPE; Sat, 04 Sep 2021 13:49:55 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: Replace one-element array with flexible-array member
Date:   Sat,  4 Sep 2021 13:49:37 +0200
Message-Id: <20210904114937.6644-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:80dhGiw6SsS128pziswnDI1u80tDjGhkmv0etse23Btp6AiuXMU
 erX4Fha1+Rio79fF8pR8DDJ243friSWaqCt5kJWcTfJS8wa/JbBXL4tgdUSUZYaPB9y7t0X
 9ZEW64C2K3McSXftObLTHx2lBttv0XJ/hCJFeLcUY4zh87JmoJAlgu26uWiTJbTQJy6b4hi
 SILt2HJn0e/o9Q3rmEX8w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hwJ/wysCuJA=:gLwWR3WSAne682ae3N83h7
 50mzDgEeO35RizI+pFCaDClySune61eyNXfXjLGv6+ZINVl5WeMkJTnPUt+6yi6iloIqsY1Bo
 3oEgJpt+dDyr33uMSv10s3FwMTuBd+b3R+KBHY2fFqSVHuI6DKRQICn+TrH+k/U5ftBNaaHhb
 sju5YC9m1VdKaetngY17T8nk28xhEZCAYKpsYvYNuVoLYu4b8Y122XoJq2NCNbhJlHKFtWTUQ
 6wlAv7cn+wobzXEc1s4XmWZNF5dMwSmrSv5wYpBP/jlCUvh/wV1NcwYpWPz+UhZWdkuZpVMEN
 Jd7AF4eu4eXPmLexUxlWjZfuw7mwsxoWiyWT8+0mZT5RFufCGtdJV2MS1gAgK7/vtScsB3fBo
 +CBPGDQxKx046dbIJYdy81lWeSDDdn9HGLCeSvZdNrFtIlNYwYQkCKOWgsvbxOUYMm8z9+ZWs
 1/ghu6bCKaR9DSMjZ1Y4/en4DCsoOS6o2ExUB5DCL6ZTCizzqsPCZuBk+Jn2toPzILlSJiujM
 3qI4SwhsxWgjMaOQl8sWt//D9QYjh7ILxAljt7JMEfuDmsQd37zETumtwPmq9MqADN1JnPQCf
 PEJ7+Epmtn9Q8NuHDceo3VwcbtG1BPh4CfQkyt9R2e6JweyG69DslwhMhFiP1OG8OFKsLAjoq
 Ll5CkkmUvYz2eQy/0Ir/ZQg8BMAXp4K+ODHOsTYq3Q/dmz7bMYRZlHVasI5iWQwegyhLRgA4J
 0qI0Z/Ppfx3xXsBJnnJBn8q50MP30dlVQ6APQm8uvH52NUZ7wqGebKiKPEecS18MFHIlLO8mC
 xqJL1by3fzzt8VWO8+6pTSN99WU4chbNeaS3+8ntlhIoOcEu2VK0Xg9xOzNGCu/69ZG2zNlss
 W5gftl2UUdcsuZv10FcUv2tiNEcB58aL5bHPNyUAbzPuexYpcxrVUj+5m5Yb8dLzbCDuY68TD
 R7xEjJB3zUAyDJ77S4e3lrUoOWJQQu41sVXPm1Pu0JuKGbr06Pk5rh1I8edO/OnbcYSyPSSMe
 VzUVBm+roYpznFZXx6FxTnuataFDQOcwfoWxNbh2Q/3YfR5E4xVGCAzmb0e3ZwmPa9Fy6oIBc
 spnMijX1mfCTHO9cQgrpNdhlNAB4gtHtDXSthY1/3jqmx+N4q4T9CiZTw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use "flexible array members"[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Also, refactor the code a bit to make use of the struct_size() helper in
kzalloc().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#zero-len=
gth-and-one-element-arrays

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/wireless/ath/ath11k/reg.c | 7 ++-----
 drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/=
ath/ath11k/reg.c
index e1a1df169034..c83d265185f1 100644
=2D-- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -97,7 +97,6 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
 	struct channel_param *ch;
 	enum nl80211_band band;
 	int num_channels =3D 0;
-	int params_len;
 	int i, ret;

 	bands =3D hw->wiphy->bands;
@@ -117,10 +116,8 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
 	if (WARN_ON(!num_channels))
 		return -EINVAL;

-	params_len =3D sizeof(struct scan_chan_list_params) +
-			num_channels * sizeof(struct channel_param);
-	params =3D kzalloc(params_len, GFP_KERNEL);
-
+	params =3D kzalloc(struct_size(params, ch_param, num_channels),
+			 GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;

diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/=
ath/ath11k/wmi.h
index d35c47e0b19d..d9c83726f65d 100644
=2D-- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -3608,7 +3608,7 @@ struct wmi_stop_scan_cmd {
 struct scan_chan_list_params {
 	u32 pdev_id;
 	u16 nallchans;
-	struct channel_param ch_param[1];
+	struct channel_param ch_param[];
 };

 struct wmi_scan_chan_list_cmd {
=2D-
2.25.1

