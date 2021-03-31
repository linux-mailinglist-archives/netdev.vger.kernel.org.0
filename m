Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3276034F6E0
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhCaCjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:39:52 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:52656 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhCaCjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:39:24 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id 9CD07980166;
        Wed, 31 Mar 2021 10:39:21 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Cc:     kael_w@yeah.net
Subject: [PATCH 2/4] net: wireless: microchip: Remove duplicate struct declaration
Date:   Wed, 31 Mar 2021 10:35:51 +0800
Message-Id: <20210331023557.2804128-3-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023557.2804128-1-wanjiabing@vivo.com>
References: <20210331023557.2804128-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGU1LQkJDQkMeTxlKVkpNSkxKTkNITUlJQ0pVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phg6GQw4CT8JSzYCSDlJD086
        DxkKFBZVSlVKTUpMSk5DSE1JTk1KVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFISEJNNwY+
X-HM-Tid: 0a7886265476d992kuws9cd07980166
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct wilc is declared twice. One has been declared
at 352nd line. Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/wireless/microchip/wilc1000/wlan.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index d55eb6b3a12a..0d24e711b62b 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -392,7 +392,6 @@ struct wilc_cfg_rsp {
 	u8 seq_no;
 };
 
-struct wilc;
 struct wilc_vif;
 
 int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
-- 
2.25.1

