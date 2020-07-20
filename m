Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A66225623
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGTDU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:20:57 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:41796 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726499AbgGTDU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 23:20:57 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowAB3fwMICxVf3jTfAQ--.59253S2;
        Mon, 20 Jul 2020 11:10:00 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        snelson@pensando.io, hkallweit1@gmail.com, mhabets@solarflare.com,
        vulab@iscas.ac.cn, mst@redhat.com, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] net: vxge-main: Remove unnecessary cast in kfree()
Date:   Mon, 20 Jul 2020 03:09:59 +0000
Message-Id: <20200720030959.7365-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowAB3fwMICxVf3jTfAQ--.59253S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWxurW8uryruw4DurWUXFb_yoWkAwbE9F
        WIqr1rWrs8G3y2kw4UCrn3Zr9I9Fs8X34fuayxKrZxAayDJrZ8Ar18XFsavr95Wr1fGF9x
        Jwn2yryfW340qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF
        7I0E8cxan2IY04v7MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
        nIWIevJa73UjIFyTuYvjfUenmRUUUUU
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiAgIDA1Jhbk1DqQAAs6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecassary casts in the argument to kfree.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 9b63574b6202..3a43ec603a8b 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -1075,7 +1075,7 @@ static int vxge_mac_list_del(struct vxge_vpath *vpath, struct macInfo *mac)
 	list_for_each_safe(entry, next, &vpath->mac_addr_list) {
 		if (((struct vxge_mac_addrs *)entry)->macaddr == del_mac) {
 			list_del(entry);
-			kfree((struct vxge_mac_addrs *)entry);
+			kfree(entry);
 			vpath->mac_addr_cnt--;
 
 			if (is_multicast_ether_addr(mac->macaddr))
@@ -2912,7 +2912,7 @@ static void vxge_free_mac_add_list(struct vxge_vpath *vpath)
 
 	list_for_each_safe(entry, next, &vpath->mac_addr_list) {
 		list_del(entry);
-		kfree((struct vxge_mac_addrs *)entry);
+		kfree(entry);
 	}
 }
 
-- 
2.17.1

