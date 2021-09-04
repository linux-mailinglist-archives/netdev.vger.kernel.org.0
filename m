Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF0E400A9A
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 13:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350975AbhIDJYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 05:24:09 -0400
Received: from mout.gmx.net ([212.227.17.22]:51087 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234866AbhIDJYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 05:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1630747360;
        bh=L8fR945KNUQU+9zGd9AirfrQd7Dhe+868DIRkoUMeH0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=KPuwhoGdL1qtDoIegwLhiFudjE9mb4U/uYMLe62hqCmdXmKQrlkc5t+529UOGi28V
         0EGugWzvEUKDat/PMWYgya+QPYfCVH1y5VZQDLHXOKX3j9J7HY1kAnInlBre7hkGtc
         7CHfeoQrjNCIhH2L87tFdmflw4IAilEpy1TJxZcA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MtwUm-1nGkKi0f8u-00uFTU; Sat, 04 Sep 2021 11:22:40 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: Replace zero-length array with flexible array member
Date:   Sat,  4 Sep 2021 11:22:17 +0200
Message-Id: <20210904092217.2848-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:euYYOsb5q5zCJ4JY1G8MCDhKfAWFs1ghhE5kP0cv6RywSV2UxZ1
 fxPceTtBwTdShAJ6/4x+825c0S3Ky6CsOuUrvOH4K6U+scsz9heJrrgeJB8euqfflTid0SR
 Un3U1J6gvPXYSOB2XKbNO4eQPeBBnbeUypYI2+8u/+/bE3yjSBP3gN+2qIa/H7vn9HAnTvk
 /KroPLIRgjq/VVEPEuLLg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EKAQ7qUHQtE=:gVhJg9ndawlGst90XC9ztI
 1GpYupu7tWcNmgjgMbohKTP9fZqwZpV24Dx7jeAh66bY5T+mdDeMFkXyfsJY8tFgZLRegKZIA
 U/UtHq1bgkCaRkrQaXttPvpL0+wndlh1DD5ZcBgpqkBWayPmCxPu5ASc6HQsmqiT/gRGib109
 rkrMBU9wqZjAacHEWVb8cwLd7z7P2ic8ZxXoSffx9sPsJ2C7AlJVqUk5a7y8lwl1Kvr4PJf0R
 tn6yjkXN75kyKNg+/SaXymeivKMmb4/BxYhkEtdJyrGqR/5aG7Ewd157oO4mDM14w7kPDuqtj
 wLUKgpL/YgQgwFdb9t6AKqXau3Q3oNM86P3a+6gJYUCJDWshvYQSKA9zxgwqakKIauxJKIvBH
 Hmt0f3KFlBfrpx9m+MZxCjALvXgZAiuqUncVyIoleMaRcAOHgC07H/KnMqz39bBLATgx0dokD
 jZ0Qjkb1Q1g6tdNKNT1YuHUV/dI9okBaM74mvbb5grB637AsqXfgGXcHFSPgmiT1MVu/cOOYj
 We9WefT14CgpduKxebRWd0UMzKmoB4psDOR6flebXUDi8mY8VHvw2PV7SQ1v4nNIrPUdY85C5
 CGkAWULOpG8z9dccR0NZixztTLM5QgXGXnI18UpQLoocT+250OTm5VGp31iKZfIF890joCJ83
 nax8+NVWxqn0s07uBvz2lTaivWLlE31NDbmI3cE/NL73WZpOke8rBmtC8SDzYMydOnuC4FOiR
 qOl62mHUTtBvKtv4detKnL+VpD03rzp2LTNNTxsmVzPMumMh3F5NsdwhU1qxum1rJbkO3Lw0n
 rWPYD+ACWU32DD8R29R+sLky0dUYIYd266fMBQuyp4Glt5qWmM2Spwr90ec4KPKyiw9gTMotE
 rv1Xo2Re19XFWsCkpHUpUjfmWWJBeAOPAmL544OvoT7aHzArAnTZNGoKQXdAlusYEhzuMxaM0
 B+6gFRVh+OpDpEqpz1oYwMYsocz+vB/AYSm5te926yVJb35tz3cWWllWPL9W5ylHc67VEDcAa
 9oqnmm+D/kwiRPaq3/Ywj0VLMbjbzp+ZaRjW3+JSd7OjNdU99CNdzRCJDdRNjZkJfCTbKHr37
 X12l52GhnS4tOfDv4ym044m4sZx99wmWfc0bjb1kX1dXWXG2zlyRmCUlA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use "flexible array members"[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

Also, make use of the struct_size() helper in devm_kzalloc().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#zero-len=
gth-and-one-element-arrays

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 2 +-
 include/linux/platform_data/brcmfmac.h                | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 2f7bc3a70c65..513c7e6421b2 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -29,7 +29,7 @@ static int brcmf_of_get_country_codes(struct device *dev=
,
 		return (count =3D=3D -EINVAL) ? 0 : count;
 	}

-	cc =3D devm_kzalloc(dev, sizeof(*cc) + count * sizeof(*cce), GFP_KERNEL)=
;
+	cc =3D devm_kzalloc(dev, struct_size(cc, table, count), GFP_KERNEL);
 	if (!cc)
 		return -ENOMEM;

diff --git a/include/linux/platform_data/brcmfmac.h b/include/linux/platfo=
rm_data/brcmfmac.h
index 1d30bf278231..2b5676ff35be 100644
=2D-- a/include/linux/platform_data/brcmfmac.h
+++ b/include/linux/platform_data/brcmfmac.h
@@ -125,7 +125,7 @@ struct brcmfmac_pd_cc_entry {
  */
 struct brcmfmac_pd_cc {
 	int				table_size;
-	struct brcmfmac_pd_cc_entry	table[0];
+	struct brcmfmac_pd_cc_entry	table[];
 };

 /**
=2D-
2.25.1

