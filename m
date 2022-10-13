Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF005FD857
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 13:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJML16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 07:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJML14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 07:27:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A2F7E816
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 04:27:54 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mp6Zr4NFfz1P7Hy;
        Thu, 13 Oct 2022 19:23:16 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 19:27:52 +0800
Message-ID: <d5cc5d48-5ab3-3697-fbcd-607eb5855ddc@huawei.com>
Date:   Thu, 13 Oct 2022 19:27:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: net/kcm: syz issue about general protection fault in skb_unlink
To:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, <edumazet@google.com>,
        <sgarzare@redhat.com>, <ast@kernel.org>, <nikolay@nvidia.com>,
        <mkl@pengutronix.de>, <cong.wang@bytedance.com>
References: <fef5174d-2109-37e9-8c46-2626b3310c5e@huawei.com>
 <45b601aebda1225b38b62c95b2c12e0fce76ee80.camel@redhat.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <45b601aebda1225b38b62c95b2c12e0fce76ee80.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/13 19:13, Paolo Abeni wrote:
> On Thu, 2022-10-13 at 18:51 +0800, shaozhengchao wrote:
>> I found that the syz issue("general protection fault in skb_unlink")
>> still happen in Linux -next branch.
>> commit: 082fce125e57cff60687181c97f3a8ee620c38f5
>> Link:
>> https://groups.google.com/g/syzkaller-bugs/c/ZfR2B5KaQrA/m/QfnGHCYSBwAJ
>> Please ask:
>> Is there any problem with this patch? Why is this patch not merged into
>> the Linux -next branch or mainline?
> 
> I never submitted the patch formally. So much time has passed that I
> don't recall exactly why. Possibly the patch fell outside my radar
> after hitting a syzkaller infrastructure issue.
> 
> Apart from that, the patch is quite invasinve, especially for a
> subsystem with no selftest and that I don't know particularly well.
> 
> As a possible option I can try to post it for net-next, when it will
> re-open - assuming there is agreement on that.
> 
> Cheers,
> 
> Paolo
> 
> 
Hi Paolo:
	Thank you for your reply. I'd like to see your patch.:)
If needed, I can provide a reproduction program.

Zhengchao Shao

