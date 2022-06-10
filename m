Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1F546DF7
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348521AbiFJUE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347324AbiFJUEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:04:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0463C4A3;
        Fri, 10 Jun 2022 13:04:22 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzkrk-0004ln-KS; Fri, 10 Jun 2022 22:04:20 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzkrk-000NXv-Aq; Fri, 10 Jun 2022 22:04:20 +0200
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev <netdev@vger.kernel.org>, john.fastabend@gmail.com
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
 <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e82d41e4-c1c0-7387-8c83-b71ecb9d92d2@iogearbox.net>
Date:   Fri, 10 Jun 2022 22:04:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220610193418.4kqpu7crwfb5efzy@apollo.legion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26568/Fri Jun 10 10:06:23 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne, hi Kumar,

On 6/10/22 9:34 PM, Kumar Kartikeya Dwivedi wrote:
> On Sat, Jun 11, 2022 at 12:37:50AM IST, Joanne Koong wrote:
>> On Fri, Jun 10, 2022 at 10:23 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>>> On Fri, Jun 10, 2022 at 5:58 AM Kumar Kartikeya Dwivedi
>>> <memxor@gmail.com> wrote:
>>>> On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
>>>>> On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
>>>>> <memxor@gmail.com> wrote:
[...]
>>>> I can have a look at resurrecting it later this month, if you're ok with waiting
>>>> until then, otherwise if someone else wants to pick this up before that it's
>>>> fine by me, just let me know so we avoid duplicated effort. Note that the
>>>> approach in v2 is dead/unlikely to get accepted by the TC maintainers, so we'd
>>>> have to implement the way Daniel mentioned in [0].
>>>
>>> Sounds great! We'll wait and check back in with you later this month.
>>>
>> After reading the linked thread (which I should have done before
>> submitting my previous reply :)),  if I'm understanding it correctly,
>> it seems then that the work needed for tc bpf_link will be in a new
>> direction that's not based on the code in this v2 patchset. I'm
>> interested in learning more about bpf link and tc - I can pick this up
>> to work on. But if this was something you wanted to work on though,
>> please don't hesitate to let me know; I can find some other bpf link
>> thing to work on instead if that's the case.

The tc ingress/egress overhaul we also discussed at lsf/mm/bpf in our session
with John and pretty much is along the lines as in the earlier link you sent.
We need it from Cilium & Tetragon as well, so it's wip from our side at the
moment, modulo the bpf link part. Would you be okay if I pinged you once something
that is plateable is ready?

Thanks,
Daniel
