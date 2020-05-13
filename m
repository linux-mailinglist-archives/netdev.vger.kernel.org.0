Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506D71D27E8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgENGd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:33:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55160 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgENGd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 02:33:27 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A1FBF46CEA0571D84181;
        Thu, 14 May 2020 14:33:24 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 14:33:14 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next] hinic: update huawei ethernet driver maintainer
Date:   Wed, 13 May 2020 22:50:49 +0000
Message-ID: <20200513225049.7080-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

update huawei ethernet driver maintainer from aviad to Bin luo

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e581ae499057..8e51860e0204 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7811,7 +7811,7 @@ F:	Documentation/devicetree/bindings/iio/humidity/hts221.txt
 F:	drivers/iio/humidity/hts221*
 
 HUAWEI ETHERNET DRIVER
-M:	Aviad Krawczyk <aviad.krawczyk@huawei.com>
+M:	Bin Luo <luobin9@huawei.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/hinic.rst
-- 
2.17.1

