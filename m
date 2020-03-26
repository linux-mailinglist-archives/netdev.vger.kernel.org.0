Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7350E193CEB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCZKWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:22:30 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:32810 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbgCZKW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 06:22:29 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 06:22:28 EDT
Received: from ubuntu.localdomain (unknown [223.104.3.202])
        by APP-05 (Coremail) with SMTP id zQCowACXnW2GgHxeO1BvAA--.21050S2;
        Thu, 26 Mar 2020 18:14:31 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qlcnic: Fix bad kzalloc null test
Date:   Thu, 26 Mar 2020 18:14:29 +0800
Message-Id: <20200326101429.18876-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowACXnW2GgHxeO1BvAA--.21050S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XF45KF4rGw4xXryxur4UJwb_yoWftwc_KF
        4Ivw1xXan8J3s0gw47Kr13J342va4DW3Z5Aw4Igay5Jw1DAF45Zr92kryfAw1xW3y5uF98
        GF13J3y3Aws7AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbFAYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I
        3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxV
        WUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAF
        wI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcI
        k0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
        Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8v_M3UUUUU==
X-Originating-IP: [223.104.3.202]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgQHA10TesnOWwAAsu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In qlcnic_83xx_get_reset_instruction_template, the variable
of null test is bad, so correct it.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index 07f9067affc6..cda5b0a9e948 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -1720,7 +1720,7 @@ static int qlcnic_83xx_get_reset_instruction_template(struct qlcnic_adapter *p_d
 
 	ahw->reset.seq_error = 0;
 	ahw->reset.buff = kzalloc(QLC_83XX_RESTART_TEMPLATE_SIZE, GFP_KERNEL);
-	if (p_dev->ahw->reset.buff == NULL)
+	if (ahw->reset.buff == NULL)
 		return -ENOMEM;
 
 	p_buff = p_dev->ahw->reset.buff;
-- 
2.17.1

