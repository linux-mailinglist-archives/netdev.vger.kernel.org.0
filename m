Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA933DC6F5
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 18:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhGaQgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 12:36:37 -0400
Received: from mout.gmx.net ([212.227.15.19]:33449 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhGaQgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 12:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627749368;
        bh=xJvnrqgnd9oF7uVLB3WIMKssaszgPE/iFBWc4v5eLAQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Alsr1hoWR+49KAmUuhQ2HqyZWAGoejfLJAJMiEmnlXSgw2GXOanitvygzLWJD/7Oi
         wXUA4KVUwtGE8HBdXH3J37WAVBEj+/XCaf/xjJlYGP/4QIEevEe6U/scIjpIWBp2ia
         gTEjmnDSics9ZvasAOJbEgSEyZqijBV1CBc4EQx8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx005 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MYeMj-1meoo72hv9-00Vjup; Sat, 31 Jul 2021 18:36:08 +0200
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
Subject: [PATCH v4] rtw88: Remove unnecessary check code
Date:   Sat, 31 Jul 2021 18:35:46 +0200
Message-Id: <20210731163546.10753-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Jtwz9aBwHctj85q8uhjC+MnBU57LqajgZpmCGu0RbG4Govyh8YW
 kvAS04XqEtEnO0qARUfbKOLjOKqRMsve59DPCLrFV+22e/85q12rF6rZpZVJHtV3uy2cU0i
 amzAzeQSE48PPyGmX6eYg2xZDwXzKRsPl+pmQxBWh7dndgQu4C4or3Venups3tVXeU+GtJu
 lgqEXiAkuzDC50+920W3Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eP0mDLW+2jk=:/6Smk11weOco+P2vV8ia6z
 fls3CdyeTl8+RYmU17Vy3MeHm18/NonuyGAR+e7fdXFl4Ht4hwQkKt0pWBuKsRJ8LGFHjfVyk
 RQJWjM3gkt5+oPjfT1uOQ4nC0Ct8zFH/vrTZ7U4t2P0Xe7iJvbz+V2mldkYbZo/S81cHk4w7D
 b9SARSQ9Gp9D0ZWqmnDkLIY6KKj6GCHbU/b6fjgvcwyVjPmGm5W2pex0CcYEuAkkxXzmGuSGm
 GJFosOpSNj4Atn0uNEKlJFVd6Mj49s4Zs4/Z0hA6iO57iSId3pR8g6xwv7C91mUo3sCX6xHBc
 rf3x5hMh+bqTEN7tbaLFu9E1NuAvqaWyYnJgyY52KLCFjCzOVCH+0EBhFTFPuiIuePqqd6LlF
 g0XxZYMZc+JmPaFFQdwvtF8EcD7kL1JtwaOnlujs2mCrPhFMZLq2/iMKTmrUgQMZk+f7Iqt9B
 m0n00ZjsXAr6GeffdDHEWFroRx9f5X4vZxYCV5vaEcL2HDl5ecDBtAz//i7dBjy46tGCedijL
 Lnpi0SZm31mh8Z8Hbr1cXTFZ95C8Ru+msdI2lVmWlgI7HZUEx2RjJq/VZSaxjMzF+MGEXlmCe
 lQdPOENHQBUq8W0Sn9moT5aHibJtYZX64p2XAuHU9DFrXo6vw4lpk/ISiZ5Y5FZ+NDV5DQgJS
 xNF4NDNC9kmAwr8n2L5rM0N4P7Vg+KRHlVZitJMkd7ZyGUQTFLWpmAOXgg0hq9CfJX7fbwsHW
 pfVUZp7/IP2VgRuN8ra25Q4teePeI4zDUXI9wTVnxomp4ORjZQIybEDqMtt/9D5I5O2vsZ104
 dAWVhZv2Y37CAiyWKYohHn7smoKmf/fKtzr84q4tkGCXob+gP8IdbvmNwk4KerhF0NFRv4+5n
 NsEq8KY1z/8A0u40szauyPBtB6fN0ZaA3DR6j+3g2M9AVUc8sqHjeJqcaI96xkh6Fde/wgaLE
 XTIDpv73RpOBqnmQ7l8+5V4FKZmpfUBLwADDAKtHzEr2eNHosRaOjCH1DChn100PNMDOgXSII
 TYrYKHXJ7xsmD03n5a27X8DZ15o9zyBAOhFJ96j6CH+uM/QrO3NmhXsMRcrOyY+khLjSEy/g/
 5507y1N9j+PEttzZT1D2kbKsDqINne36eEQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtw_pci_init_rx_ring function is only ever called with a fixed
constant or RTK_MAX_RX_DESC_NUM for the "len" argument. Since this
constant is defined as 512, the "if (len > TRX_BD_IDX_MASK)" check
can never happen (TRX_BD_IDX_MASK is defined as GENMASK(11, 0) or in
other words as 4095).

So, remove this check.

The true motivation for this patch is to silence a false Coverity
warning.

Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
Changelog v1 -> v2
- Remove the macro ARRAY_SIZE from the for loop (Pkshih, Brian Norris).
- Add a new check for the len variable (Pkshih, Brian Norris).

Changelog v2 -> v3
- Change the subject of the patch.
- Remove the "if" check statement (Greg KH)
- Remove the "Fixes" tag, "Addresses-Coverity-ID" tag and Cc to stable.

Changelog v3 -> v4
- Add the "Reviewed-by: Brian Norris" tag.
- Update the commit changelog to include the true motivation for the
  patch (Brian Norris).

The previous versions can be found at:

v1
https://lore.kernel.org/lkml/20210711141634.6133-1-len.baker@gmx.com/

v2
https://lore.kernel.org/lkml/20210716155311.5570-1-len.baker@gmx.com/

v3
https://lore.kernel.org/lkml/20210718084202.5118-1-len.baker@gmx.com/

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

