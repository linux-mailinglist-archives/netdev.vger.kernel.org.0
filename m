Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF14BD327
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 02:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245371AbiBUBaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 20:30:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245351AbiBUBav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 20:30:51 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4DB23BF1;
        Sun, 20 Feb 2022 17:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=VFWu6FF6B226VEQnYoQRekqNHswkG9aByXJfytB6bzo=; b=b3OfuSUR6AMVVVnb3vshC/GIgR
        QQv0uw4IqiEF6OfbOTeJJ7TdNYh6FIF2fhn/F+wgMZBYdVkr0sjum1CvBws7tajyADMWfYhtQGvy6
        PAeRfFke5eqoePVuydlFtpl9kaRldpUGThh78AxnBsGi4kVOR2SpptOBthBmnYMVs/L6JyYvl2l4e
        CTquI+wtbdgxKTFp/GPGDi8sARz6LBGhLDmczToqDXwK0G9m3eD3z0uNIPD4wlo5Vfsv7H7rFLhXZ
        qD8pHG3/YwiSjSVd9dFNgq58aoB7cVTu/eW78aRgitFEBFI1KKW8NkrO3HWfXZHwiV4NG1OfJwAUT
        3Osyni/Q==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nLxWg-00BWc0-AU; Mon, 21 Feb 2022 01:30:07 +0000
Message-ID: <a7c2bc3c-16e6-735f-4bc8-b57a48daec7d@infradead.org>
Date:   Sun, 20 Feb 2022 17:29:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] bpf: cleanup comments
Content-Language: en-US
To:     Song Liu <song@kernel.org>, trix@redhat.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220220184055.3608317-1-trix@redhat.com>
 <CAPhsuW7j9SK5OJxK-ZnDYgwVhoPJGP8K+1Q+pUJ8mGUA41ZvHQ@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CAPhsuW7j9SK5OJxK-ZnDYgwVhoPJGP8K+1Q+pUJ8mGUA41ZvHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/20/22 17:28, Song Liu wrote:
> On Sun, Feb 20, 2022 at 10:41 AM <trix@redhat.com> wrote:
>>
>> From: Tom Rix <trix@redhat.com>
>>
>> Add leading space to spdx tag
>> Use // for spdx c file comment
>>
>> Replacements
>> resereved to reserved
>> inbetween to in between
>> everytime to every time
> 
> I think everytime could be a single word? Other than that,

Nope. :)

> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
>> intutivie to intuitive
>> currenct to current
>> encontered to encountered
>> referenceing to referencing
>> upto to up to
>> exectuted to executed
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>  kernel/bpf/bpf_local_storage.c | 2 +-
>>  kernel/bpf/btf.c               | 6 +++---
>>  kernel/bpf/cgroup.c            | 8 ++++----
>>  kernel/bpf/hashtab.c           | 2 +-
>>  kernel/bpf/helpers.c           | 2 +-
>>  kernel/bpf/local_storage.c     | 2 +-
>>  kernel/bpf/reuseport_array.c   | 2 +-
>>  kernel/bpf/syscall.c           | 2 +-
>>  kernel/bpf/trampoline.c        | 2 +-
>>  9 files changed, 14 insertions(+), 14 deletions(-)

-- 
~Randy
