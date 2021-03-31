Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7F034F6D6
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhCaCjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:39:14 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:50630 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhCaCi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:38:58 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id A781C980275;
        Wed, 31 Mar 2021 10:38:53 +0800 (CST)
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
Subject: [PATCH 0/4] net: Remove duplicate struct declaration
Date:   Wed, 31 Mar 2021 10:35:49 +0800
Message-Id: <20210331023557.2804128-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGExPGk5JH08YQk5KVkpNSkxKTkNISE9IQ01VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRw6Txw*LD8VCjYSMT8BDz5K
        UU0aCw1VSlVKTUpMSk5DSEhPTE9DVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFISktCNwY+
X-HM-Tid: 0a788625e766d992kuwsa781c980275
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series tried to remove duplicate struct declaration.

Wan Jiabing (4):
  net: wireless: broadcom: Remove duplicate struct declaration
  net: wireless: microchip: Remove duplicate struct declaration
  net: wireless: marvell: Remove duplicate struct declaration
  net: ethernet: stmicro: Remove duplicate struct declaration

 drivers/net/ethernet/stmicro/stmmac/hwif.h               | 1 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 1 -
 drivers/net/wireless/marvell/libertas_tf/libertas_tf.h   | 1 -
 drivers/net/wireless/microchip/wilc1000/wlan.h           | 1 -
 4 files changed, 4 deletions(-)

-- 
2.25.1

