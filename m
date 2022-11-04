Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4A6619EF0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiKDRil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiKDRic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:38:32 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADAF1EAD2;
        Fri,  4 Nov 2022 10:38:30 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1or0e7-000Dj2-8U; Fri, 04 Nov 2022 18:38:23 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1or0e7-000L6l-5F; Fri, 04 Nov 2022 18:38:23 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: fix build-id for
 liburandom_read.so
To:     KP Singh <kpsingh@kernel.org>, Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ykaliuta@redhat.com,
        linux-kernel@vger.kernel.org
References: <20221104094016.102049-1-asavkov@redhat.com>
 <CACYkzJ4E37F9iyPU0Qux4ZazHMxz0oV=dANOaDNZ4O8cuWVYhg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5e6b5345-fc44-b577-e379-cedfe3263066@iogearbox.net>
Date:   Fri, 4 Nov 2022 18:38:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACYkzJ4E37F9iyPU0Qux4ZazHMxz0oV=dANOaDNZ4O8cuWVYhg@mail.gmail.com>
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

Hi Artem,

On 11/4/22 2:29 PM, KP Singh wrote:
> On Fri, Nov 4, 2022 at 10:41 AM Artem Savkov <asavkov@redhat.com> wrote:
>>
>> lld produces "fast" style build-ids by default, which is inconsistent
>> with ld's "sha1" style. Explicitly specify build-id style to be "sha1"
>> when linking liburandom_read.so the same way it is already done for
>> urandom_read.
>>
>> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> 
> Acked-by: KP Singh <kpsingh@kernel.org>
> 
> This was done in
> https://lore.kernel.org/bpf/20200922232140.1994390-1-morbo@google.com

When you say "fix", does it actually fix a failing test case or is it more
of a cleanup to align liburandom_read build with urandom_read? From glancing
at the code, we only check build id for urandom_read.

Cheers,
Daniel
