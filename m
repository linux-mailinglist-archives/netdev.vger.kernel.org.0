Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DADE56AD2C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 23:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbiGGVEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 17:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbiGGVEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 17:04:34 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD752B601;
        Thu,  7 Jul 2022 14:04:33 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o9Yff-000Gco-JJ; Thu, 07 Jul 2022 23:04:23 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o9Yff-0001QW-9z; Thu, 07 Jul 2022 23:04:23 +0200
Subject: Re: [PATCH] bpf: make sure mac_header was set before using it
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>
References: <20220707123900.945305-1-edumazet@google.com>
 <165721801302.2116.12763817658962623961.git-patchwork-notify@kernel.org>
 <CAADnVQLoMzN8icCenQh7OHNRHAHMhQhujQYwSXH3Kmw6sAGOGA@mail.gmail.com>
 <CANn89iLarMJeMUivaPnYHUh3MYjEZ91USq0ncGbLFp1JNjEiaA@mail.gmail.com>
 <CAADnVQLC5Wj7TbMEUvuMRs1cB9FNsk3y5jBN8XwUMif6CUEXeg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <40c716ee-b4a8-636b-8b54-2d83b1c0aaa2@iogearbox.net>
Date:   Thu, 7 Jul 2022 23:04:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQLC5Wj7TbMEUvuMRs1cB9FNsk3y5jBN8XwUMif6CUEXeg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26596/Thu Jul  7 09:53:54 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/22 8:40 PM, Alexei Starovoitov wrote:
> On Thu, Jul 7, 2022 at 11:36 AM Eric Dumazet <edumazet@google.com> wrote:
>> On Thu, Jul 7, 2022 at 8:31 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Thu, Jul 7, 2022 at 11:20 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>>>>
>>>> Hello:
>>>>
>>>> This patch was applied to bpf/bpf.git (master)
>>>
>>> Are we sure it's bpf tree material?
>>> The fixes tag points to net-next tree.
>>
>> Fix is generic and should not harm bpf tree, or any tree if that matters.
> 
> Right. Just trying to understand the urgency/severity
> considering we're at rc5.

The Fixes tag points to the warning that has been added. I understand more
as a reference rather than the actual underlying bug that syzkaller was
able to trigger w/ classic bpf. So yeah, bpf tree seems reasonable, imho,
but also low risk from patch diff itself.

Thanks,
Daniel
