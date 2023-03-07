Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B71D6AD798
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 07:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjCGGqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 01:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGGqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 01:46:34 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A70410BF
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 22:46:33 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PW5WN003qz16NmK;
        Tue,  7 Mar 2023 14:43:43 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Tue, 7 Mar
 2023 14:46:30 +0800
Subject: Re: [PATCH net-next] net: remove enum skb_free_reason
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <eric.dumazet@gmail.com>
References: <20230306204313.10492-1-edumazet@google.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3139e94a-e438-afdb-dbed-d7ba069a0844@huawei.com>
Date:   Tue, 7 Mar 2023 14:46:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230306204313.10492-1-edumazet@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/7 4:43, Eric Dumazet wrote:
> enum skb_drop_reason is more generic, we can adopt it instead.
> 
> Provide dev_kfree_skb_irq_reason() and dev_kfree_skb_any_reason().
> 
> This means drivers can use more precise drop reasons if they want to.

LGTM.
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
