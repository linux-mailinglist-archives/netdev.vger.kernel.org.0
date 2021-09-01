Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8373FD158
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbhIACbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:31:17 -0400
Received: from mail-m17644.qiye.163.com ([59.111.176.44]:10682 "EHLO
        mail-m17644.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241128AbhIACbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:31:16 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2021 22:31:15 EDT
Received: from wanjb-virtual-machine.localdomain (unknown [58.213.83.158])
        by mail-m17644.qiye.163.com (Hmail) with ESMTPA id B238E3201AC;
        Wed,  1 Sep 2021 10:21:05 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Wan Jiabing <wanjiabing@vivo.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Subject: [PATCH] net: ixp46x: Remove duplicate include of module.h
Date:   Wed,  1 Sep 2021 10:20:57 +0800
Message-Id: <20210901022059.4126-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWUJLSx1WS0lKGkpOTENLQk
        8ZVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjI6Ezo5Fz9WLUgsT0IRIRAS
        MjEaCTVVSlVKTUhLT01JQ01NSUJJVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJSkhVQ0hVSk5DWVdZCAFZQUpNQk43Bg++
X-HM-Tid: 0a7b9f28f1edd99akuwsb238e3201ac
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove repeated include of linux/module.h as it has been included
at line 8.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index ecece21315c3..39234852e01b 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -16,7 +16,6 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ixp4xx/cpu.h>
-#include <linux/module.h>
 #include <mach/ixp4xx-regs.h>
 
 #include "ixp46x_ts.h"
-- 
2.25.1

