Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45205FD7F3
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJMKvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJMKve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:51:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3611FF26C
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 03:51:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mp5t85Kg2zHtmq;
        Thu, 13 Oct 2022 18:51:28 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 18:51:30 +0800
Message-ID: <fef5174d-2109-37e9-8c46-2626b3310c5e@huawei.com>
Date:   Thu, 13 Oct 2022 18:51:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
To:     netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, <edumazet@google.com>,
        <sgarzare@redhat.com>, <ast@kernel.org>, <nikolay@nvidia.com>,
        <mkl@pengutronix.de>, <cong.wang@bytedance.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
Subject: net/kcm: syz issue about general protection fault in skb_unlink
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I found that the syz issue("general protection fault in skb_unlink")
still happen in Linux -next branch.
commit: 082fce125e57cff60687181c97f3a8ee620c38f5
Link: 
https://groups.google.com/g/syzkaller-bugs/c/ZfR2B5KaQrA/m/QfnGHCYSBwAJ
Please ask:
Is there any problem with this patch? Why is this patch not merged into
the Linux -next branch or mainline?

Thank you.

Zhengchao Shao
