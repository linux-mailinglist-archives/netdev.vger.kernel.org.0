Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BDB389B3E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhETCQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:16:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4541 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhETCPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:15:49 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FltXD3kswzkYDv;
        Thu, 20 May 2021 10:11:40 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:14:26 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:14:26 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Karsten Keil <isdn@linux-pingi.de>,
        Leon Romanovsky <leon@kernel.org>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 0/1] mISDN: Remove obsolete PIPELINE_DEBUG debugging information
Date:   Thu, 20 May 2021 10:14:10 +0800
Message-ID: <20210520021412.8100-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 --> v2:
Remove all obsolete PIPELINE_DEBUG debugging information.

v1:
Mark local variable 'incomplete' as __maybe_unused in dsp_pipeline_build()


Zhen Lei (1):
  mISDN: Remove obsolete PIPELINE_DEBUG debugging information

 drivers/isdn/mISDN/dsp_pipeline.c | 46 ++-----------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

-- 
2.25.1


