Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181BE3CC833
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 10:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhGRIpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 04:45:47 -0400
Received: from mout.gmx.net ([212.227.17.20]:53709 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhGRIpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 04:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626597751;
        bh=XY/zxOCbvhlZeJ1i99rhW5BbBx5vSJgiyjkWBXkdUaQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=K/RzuUhT0vSBhVnAMlPPn6+ZyVTTYLjvsEB1KU/J0t+8K3U6h46hDL6e0XNUBJBDK
         z5G9e/O8tW6yxF/mvz09ndIPw1M+Ezld0UqZkk30uun4WlZCZF8VSL1r8CleCzzryN
         CDSExAnvyRUr95DHckR1RawSWKHGGUq9SPWQ8FY0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([83.52.228.41]) by mail.gmx.net
 (mrgmx105 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MRCOK-1lk5i72TjA-00NC76; Sun, 18 Jul 2021 10:42:31 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Brian Norris <briannorris@chromium.org>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] rtw88: Remove unnecessary check code
Date:   Sun, 18 Jul 2021 10:42:02 +0200
Message-Id: <20210718084202.5118-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dynWGx0R5esUpEZg1Xw1+W/TNAzgd/+x0YhsmKEb5KZq1uEUpvg
 XEj0rBZESb0bX9Wm7YC9mFW3kwgO4/3ZfscEGPi80CunbpX3SFGteSWzVz2DC+qge9b6eap
 0UoKzwXe71hyNtXeoKA+9xtH5hjmbTU7ARseNb/RYw7X03UZtsBOg9DCTqLDn9hhNpRKmud
 Fut9w+m3OPoXFznqr3f9Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3DfUG/U4EK8=:vl30PAveMCYFIoZulZernQ
 hmTVARfIkWsX0DoDNtcaJF42ZsWQL+L7/Jrxo5sL7GBjtSgV67TgieNnm0chCt71RmiA6gbnW
 lWIaUR0E80WPxzgDEoHNKMTvkS5qSUYUOYjDzFmmMxtPcwxyP8hC+4fjldVYPIqZZcQaNPygn
 XJQdKaHdYwdYHnjvSRh3l+iszQzrExJ96+Vc3SZrtjtU94++C+/xeQe2RNACxn24aN7GLIvB5
 GVZzO+j6ijSTAQ6y2mNfSzQ5YszCH15HEFbuoG7ESxMJnAVn/tO1td+fdUp1zDTAuEEgofdsh
 +CZ92IZalHrUAiHyZMUsTmCIq3FDBbqvRkxtC5bYzQv2ZN71p/jctBdL7jA+exH1ZGdJ8Co84
 kIXItjJsUz8yhDag4WbxUb8kxV7BG9RZPSOw2lWIjn8fsDeYFTnlgTiyxutpVne0EXvIpbeaU
 LEa9axJXl5zxzc5M+ISR1CTaoKRTu+iF80KTPoLTyRR2HxDPdwwXNMZLk+NZ4vyZYTU+7M8Rr
 fxKZMY+0r0Ahhj4QmLhldg6NyLSzjSF4mCKgLh7yCkGOQ2hXL4LxTypdSB3R/ORU0v3iix5Ve
 JZRy7w+Eb/Ht+OGoV2X6YgCDjaYyRIab5fzM10UlspofBfSIAI7EEyxu/pSZgPqLPhamsuqYs
 cSWZsN3ZtVSE9UzWSEdAmGdUw19GsYLp/5OXNsQTq7MCK4z5M6JkH/tjYRfCNj8jx1pyKiStF
 sT4er+PDaSYVzSVATUfkseSLeL1QCgNChlXEaq/k0GD1yfsvkHumRI8/fbTW+go+bFQDYI8ld
 SOq1209YGl5AQLn394rYzgMzhMWO5VThvZXHiPgyvhvpRb/nz9TTFaRSFW9DiD00/LPzjlf+A
 k24W/c16tRZ5qc9gJFxiC5xNK2rKUrqe737ibvTGJCSJmn0y4XCSiLWnbePK+F2hu41EmF4Ra
 9I0yO1GAW9TC4klAH7RMlvJcY/QzIELz6oDSvlXIBmjvX/wCLAQfYO8P1eMLdmJY7jYCVvk32
 Fvj5S39je9rnFpqAgeZxcQZIZovilLe3GTwJ6PejSEzukCOo+uxy7YWFSGAofGpd/xW16nlvm
 4Kojw2vOsQQekTzOHs/QlqYoeUSaLgzPMYM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtw_pci_init_rx_ring function is only ever called with a fixed
constant or RTK_MAX_RX_DESC_NUM for the "len" argument. Since this
constant is defined as 512, the "if (len > TRX_BD_IDX_MASK)" check
can never happen (TRX_BD_IDX_MASK is defined as GENMASK(11, 0) or in
other words as 4095).

So, remove this check.

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
Changelog v1 -> v2
- Remove the macro ARRAY_SIZE from the for loop (Pkshih, Brian Norris).
- Add a new check for the len variable (Pkshih, Brian Norris).

Changelog v2 -> v3
- Change the subject of the patch.
- Remove the "if" check statement (Greg KH)
- Remove the "Fixes" tag, "Addresses-Coverity-ID" tag and Cc to stable.

The previous versions can be found at:

v1
https://lore.kernel.org/lkml/20210711141634.6133-1-len.baker@gmx.com/

v2
https://lore.kernel.org/lkml/20210716155311.5570-1-len.baker@gmx.com/

 drivers/net/wireless/realtek/rtw88/pci.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirele=
ss/realtek/rtw88/pci.c
index e7d17ab8f113..f17e7146f20f 100644
=2D-- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -268,11 +268,6 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwde=
v,
 	int i, allocated;
 	int ret =3D 0;

-	if (len > TRX_BD_IDX_MASK) {
-		rtw_err(rtwdev, "len %d exceeds maximum RX entries\n", len);
-		return -EINVAL;
-	}
-
 	head =3D dma_alloc_coherent(&pdev->dev, ring_sz, &dma, GFP_KERNEL);
 	if (!head) {
 		rtw_err(rtwdev, "failed to allocate rx ring\n");
=2D-
2.25.1

