Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1741462052D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 01:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiKHAw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 19:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiKHAw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 19:52:58 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50969252A2;
        Mon,  7 Nov 2022 16:52:57 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N5qMN3GlBzRp4C;
        Tue,  8 Nov 2022 08:52:48 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 08:52:55 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 08:52:54 +0800
Subject: Re: [PATCH bpf v2 4/5] bpf: Add kernel function call support in
 32-bit ARM for EABI
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <asavkov@redhat.com>, <delyank@fb.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
 <20221107092032.178235-5-yangjihong1@huawei.com>
 <Y2j7J9mJxmKJ4ZpP@shell.armlinux.org.uk>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <8469b2d5-276b-9715-cf62-a5a724d438d7@huawei.com>
Date:   Tue, 8 Nov 2022 08:52:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <Y2j7J9mJxmKJ4ZpP@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 2022/11/7 20:33, Russell King (Oracle) wrote:
> On Mon, Nov 07, 2022 at 05:20:31PM +0800, Yang Jihong wrote:
>> +bool bpf_jit_supports_kfunc_call(void)
>> +{
>> +	return true;
> 
> It would be far cleaner to make this:
> 
> 	return IS_ENABLED(CONFIG_AEABI);
> 
> So userspace knows that it isn't supported on OABI.
> 
Thanks for the suggestion, will change.

Thanks,
Yang
.
