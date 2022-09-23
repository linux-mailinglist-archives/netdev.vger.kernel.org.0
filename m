Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9015E7D12
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiIWObS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiIWObH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:31:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C5C13EACE
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 07:31:04 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MYvc71K9YzWh7b;
        Fri, 23 Sep 2022 22:27:03 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 22:31:02 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 23 Sep
 2022 22:31:01 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <woojung.huh@microchip.com>, <Arun.Ramadoss@microchip.com>,
        <george.mccollister@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: dsa: remove unnecessary i2c_set_clientdata()
Date:   Fri, 23 Sep 2022 22:37:39 +0800
Message-ID: <20220923143742.87093-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset https://lore.kernel.org/all/20220921140524.3831101-8-yangyingliang@huawei.com/T/
removed all set_drvdata(NULL) in driver remove function.

i2c_set_clientdata() is another wrapper of set drvdata function, to follow
the same convention, remove i2c_set_clientdata() called in driver remove
function in drivers/net/dsa/.

Yang Yingliang (3):
  net: dsa: lan9303: remove unnecessary i2c_set_clientdata()
  net: dsa: microchip: ksz9477: remove unnecessary i2c_set_clientdata()
  net: dsa: xrs700x: remove unnecessary i2c_set_clientdata()

 drivers/net/dsa/lan9303_i2c.c           | 2 --
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 --
 drivers/net/dsa/xrs700x/xrs700x_i2c.c   | 2 --
 3 files changed, 6 deletions(-)

-- 
2.25.1

