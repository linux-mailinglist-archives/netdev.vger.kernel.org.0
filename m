Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C1C61A559
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 00:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiKDXHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 19:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiKDXHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 19:07:22 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ED51E3F7;
        Fri,  4 Nov 2022 16:07:22 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1or5mO-000Lae-8C; Sat, 05 Nov 2022 00:07:16 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1or5mO-0003mm-3w; Sat, 05 Nov 2022 00:07:16 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: fix build-id for
 liburandom_read.so
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     KP Singh <kpsingh@kernel.org>, Artem Savkov <asavkov@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ykaliuta@redhat.com,
        linux-kernel@vger.kernel.org
References: <20221104094016.102049-1-asavkov@redhat.com>
 <CACYkzJ4E37F9iyPU0Qux4ZazHMxz0oV=dANOaDNZ4O8cuWVYhg@mail.gmail.com>
 <5e6b5345-fc44-b577-e379-cedfe3263066@iogearbox.net>
 <CAEf4BzZO+4znx4VzQ9LwzFXv0=NfQL4DKBZCGB36ojYNbRoCzQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <385ce274-712f-e1fb-8de6-f4441728c225@iogearbox.net>
Date:   Sat, 5 Nov 2022 00:07:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZO+4znx4VzQ9LwzFXv0=NfQL4DKBZCGB36ojYNbRoCzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26710/Fri Nov  4 08:53:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 11:58 PM, Andrii Nakryiko wrote:
> On Fri, Nov 4, 2022 at 10:38 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Hi Artem,
>>
>> On 11/4/22 2:29 PM, KP Singh wrote:
>>> On Fri, Nov 4, 2022 at 10:41 AM Artem Savkov <asavkov@redhat.com> wrote:
>>>>
>>>> lld produces "fast" style build-ids by default, which is inconsistent
>>>> with ld's "sha1" style. Explicitly specify build-id style to be "sha1"
>>>> when linking liburandom_read.so the same way it is already done for
>>>> urandom_read.
>>>>
>>>> Signed-off-by: Artem Savkov <asavkov@redhat.com>
>>>
>>> Acked-by: KP Singh <kpsingh@kernel.org>
>>>
>>> This was done in
>>> https://lore.kernel.org/bpf/20200922232140.1994390-1-morbo@google.com
>>
>> When you say "fix", does it actually fix a failing test case or is it more
>> of a cleanup to align liburandom_read build with urandom_read? From glancing
>> at the code, we only check build id for urandom_read.
> 
> I reworded the subject to "selftests/bpf: Use consistent build-id type
> for liburandom_read.so" and pushed. Thanks!

Ack, sgtm!
