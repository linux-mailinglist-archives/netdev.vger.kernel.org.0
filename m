Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B57227CBE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGUKTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGUKTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:19:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1B9C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:19:40 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a15so5692218wrh.10
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 03:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=VeNDrBhjoWE2FDcc+COejQI4vRtmFQlWWQalpBKe3iw=;
        b=h3Yuu03b3a+RZR0aykxkNb/7eIfBNJUZoZW2pX1A85kBFF9CW7XRjjeF4AH1dVeZJ4
         3rsWArPRHxCbYsywDBhxyIFWIzEYzfbhbrSJoeM5PlkfFalv4FQi3zb8aCN8sYR4Xtb3
         GObl/tPMIT7qLt+unX3at5nOgs4GFIBOmVO58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=VeNDrBhjoWE2FDcc+COejQI4vRtmFQlWWQalpBKe3iw=;
        b=rRw+C9Xu2fmj15Xi1Jp4z2O6EwSwqpBjE57MaUyz8x0DunkCS/3jpV0N6O7KS2NK5P
         aJTTwmnJu+oD4OGrBbegiggUF6V/YvfyRYlWfpwweuH+KUOLKXG3lkDYEH1J2/PoiHjj
         UoC3/3Y/yCj6m38fgtHr9KC6COeji7Xz12huMgs7ZkC+kK58ROmQqBHWyCRz+OcX4CEh
         KNSb57H33mTufPdgwRoCEVashFBdTzIu8B1bP4Y7yeBv0fqXck6hzAVgKXo0MsptizDA
         tMxvYHlbcpWxi4Lx2vw2apv4HY37LQhs5XEt6M4zcuG3ut8dlRRT45bJtC1zakMI9SXd
         mnvw==
X-Gm-Message-State: AOAM531Cv6C8k1DBO1JeUrdFP2bhedvecvLvQk1H0xCIRhMiWsvJZgGn
        didc6mm+lg8DeRuZ+nJyVn0YCQ==
X-Google-Smtp-Source: ABdhPJzlj89CEZ/64j2VOxVbnlm6i5eCK/ix8hoOBzMTwL7fXedScdH/sqvkJfL+/2XPB6GssoKIZw==
X-Received: by 2002:adf:8562:: with SMTP id 89mr28112987wrh.57.1595326779538;
        Tue, 21 Jul 2020 03:19:39 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 33sm40552267wri.16.2020.07.21.03.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:19:39 -0700 (PDT)
References: <20200720194225.17de9962@canb.auug.org.au> <a97220b2-9864-eb49-6e27-0ec5b7e5b977@infradead.org> <20200721044902.24ebe681@canb.auug.org.au> <CAADnVQJNU+tm3WT+JuPoY8TTHWXxQ8OJ0sGCLQGq2Avf+Ri7Yw@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: linux-next: Tree for Jul 20 (kernel/bpf/net_namespace)
In-reply-to: <CAADnVQJNU+tm3WT+JuPoY8TTHWXxQ8OJ0sGCLQGq2Avf+Ri7Yw@mail.gmail.com>
Date:   Tue, 21 Jul 2020 12:19:38 +0200
Message-ID: <87365lxj9h.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 09:37 PM CEST, Alexei Starovoitov wrote:
> On Mon, Jul 20, 2020 at 11:49 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Hi all,
>>
>> On Mon, 20 Jul 2020 08:51:54 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
>> >
>> > on i386 or x86_64:
>> >
>> > # CONFIG_INET is not set
>> > # CONFIG_NET_NS is not set
>> >
>> > ld: kernel/bpf/net_namespace.o: in function `bpf_netns_link_release':
>> > net_namespace.c:(.text+0x32c): undefined reference to `bpf_sk_lookup_enabled'
>> > ld: kernel/bpf/net_namespace.o: in function `netns_bpf_link_create':
>> > net_namespace.c:(.text+0x8b7): undefined reference to `bpf_sk_lookup_enabled'
>> > ld: kernel/bpf/net_namespace.o: in function `netns_bpf_pernet_pre_exit':
>> > net_namespace.c:(.ref.text+0xa3): undefined reference to `bpf_sk_lookup_enabled'
>>
>> Caused by commit
>>
>>   1559b4aa1db4 ("inet: Run SK_LOOKUP BPF program on socket lookup")
>>
>> from the bpf-next tree.
>
> Jakub, please take a look.

Sorry about that. Proposed fix:

  https://lore.kernel.org/bpf/20200721100716.720477-1-jakub@cloudflare.com/  
