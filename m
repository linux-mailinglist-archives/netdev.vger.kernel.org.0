Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839E05E5B86
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiIVGkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIVGkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:40:10 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9582A2612
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:40:06 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MY5FT0M3mzKPwV
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:38:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.102.38])
        by APP2 (Coremail) with SMTP id Syh0CgD3SXNCAyxjJffZBA--.57152S4;
        Thu, 22 Sep 2022 14:40:04 +0800 (CST)
From:   Wei Yongjun <weiyongjun@huaweicloud.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: vertexcom: mse102x: Silence no spi_device_id warnings
Date:   Thu, 22 Sep 2022 06:57:17 +0000
Message-Id: <20220922065717.1448498-1-weiyongjun@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgD3SXNCAyxjJffZBA--.57152S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CF48CF4rKF4rXF4rJr17trb_yoW8GFW8pF
        45GayUuF95Wr43Gws3Jw48XFWkKa92ya4Sg3Wjyw1S93ZrAFW8Za9rtFW3Zr1DJFWUGw1I
        qFWUZryDAF95XrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
        Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIY
        CTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 5zhl50pqjm3046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

SPI devices use the spi_device_id for module autoloading even on
systems using device tree, after commit 5fa6863ba692 ("spi: Check
we have a spi_device_id for each DT compatible"), kernel warns as
follows since the spi_device_id is missing:

SPI driver mse102x has no spi_device_id for vertexcom,mse1021
SPI driver mse102x has no spi_device_id for vertexcom,mse1022

Add spi_device_id entries to silence the warnings, and ensure driver
module autoloading works.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 30a2f38491fe..aeed2a093e34 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -750,6 +750,13 @@ static const struct of_device_id mse102x_match_table[] = {
 };
 MODULE_DEVICE_TABLE(of, mse102x_match_table);
 
+static const struct spi_device_id mse102x_ids[] = {
+	{ "mse1021" },
+	{ "mse1022" },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, mse102x_ids);
+
 static struct spi_driver mse102x_driver = {
 	.driver = {
 		.name = DRV_NAME,
@@ -758,6 +765,7 @@ static struct spi_driver mse102x_driver = {
 	},
 	.probe = mse102x_probe_spi,
 	.remove = mse102x_remove_spi,
+	.id_table = mse102x_ids,
 };
 module_spi_driver(mse102x_driver);
 
-- 
2.34.1

