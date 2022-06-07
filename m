Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657C153F341
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 03:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiFGBQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 21:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbiFGBQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 21:16:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD44880C2;
        Mon,  6 Jun 2022 18:16:22 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LHC5x4ZzbzRhbV;
        Tue,  7 Jun 2022 09:13:09 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 7 Jun 2022 09:16:20 +0800
Subject: Re: [PATCH net-next v4] ipv6: Fix signed integer overflow in
 __ip6_append_data
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220601084803.1833344-1-wangyufen@huawei.com>
 <4c9e3cf5122f4c2f8a2473c493891362e0a13b4a.camel@redhat.com>
 <20220602090228.1e493e47@kernel.org>
 <34c12525e133402e9d49601974b3deb390991e74.camel@redhat.com>
 <9b09cb01-07ee-6b33-5351-74a40edbda3d@huawei.com>
 <20220606072413.284b10fa@kernel.org>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <76504e45-df0a-e202-392e-cbed7ad7d70e@huawei.com>
Date:   Tue, 7 Jun 2022 09:16:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20220606072413.284b10fa@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2022/6/6 22:24, Jakub Kicinski Ð´µÀ:
> On Mon, 6 Jun 2022 10:03:27 +0800 wangyufen wrote:
>>> LGTM. Imho this can even land in a separated patch (whatever is easier)
>> Thanks for all the feedback.
>> So, Jakub will send a new patch to fix the l2tp_ip6_sendmsg issue?
> That was just a suggestion, if possible I'd prefer if you double
> checked the analysis, tested that or similar code, wrote a commit
> message etc. and sent it.
> .
OK, thanks. will send in v5.
