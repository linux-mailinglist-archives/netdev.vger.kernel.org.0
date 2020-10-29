Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DCF29E2AF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgJ2CcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgJ2Ca5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:30:57 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F11C0613CF;
        Wed, 28 Oct 2020 19:20:58 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id k6so1792852ior.2;
        Wed, 28 Oct 2020 19:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KpAmy8R8W8FSv8OXlUtqLiCP76FJNmvLZoJQVbUNCDc=;
        b=JgAYlplVb/pEpMqWZIp3SXJtuH4Hus05Syh+tbLieu3xI98XgpOED9CBHUeKTv5Rb9
         CkqtaBgfi5noiOSEYszpMb7CfUu5R8Siw8zXnPWv4o1Ut0tENBsj+THamRrTW0K9A1I+
         50w8nrzzuklVibqhFp1RImge4KuquTutyZbZ9PXsY5rOHtlffbUdarQdbAIGEWWZhL6/
         ezxR0RODmK8prdpa9quwYJI9Z5aoEmbG6RXjzOajqFtv/7QuYQNDrxENaI95ld0xTgm5
         jXfYIVAdl2/DrdIuJQJ90loItyqjY3Zy9/688CPhcydW1AEK5PnR997H9HGFZ+WkMZFX
         Wq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KpAmy8R8W8FSv8OXlUtqLiCP76FJNmvLZoJQVbUNCDc=;
        b=FTsOEGDJ4iOS+A38iDvY2hS2Y9xyYd+gyd/6r6UWRx2d35A+Q1YhmcZCq+IrvIzuQH
         AyCRjl1DM632eygF8LTgn534bLmYv8K7antkhwhsGYlAzbpUmBDvtPnUe5VIBSTP9cIl
         2nVfBS99CsD4bRGwY/Xog540eG18UGAZgGTuIpTVLeZVGgBExVVzWjpPjD55SC5JjQn1
         3r1X3vEPo1MDX400PMYR5A/eN7IO8Dk0dmT1NM1YGg1Lg+TW+VxthBX4S3702I3061Ty
         T2V+BIkGe60pZPLAUN2bds5IqQOJfP0igtyCplQoebnT2eGrk4BdlnoOyPVP3yAKvqrt
         4T8w==
X-Gm-Message-State: AOAM5339MF2YhS6n1kv87Q/40QnWz7SAGGFxNhJXC4GFCYl90DInl4lx
        j4Q2Gklp5ZFQaCZOA/YQ15k=
X-Google-Smtp-Source: ABdhPJxwiSrxtT02874BNkFVV1g7meD23uFfPYMyc5KUmWjL45fZ8aHhPDYabLtjCjQmgcUiSxB3zw==
X-Received: by 2002:a6b:9108:: with SMTP id t8mr1844128iod.206.1603938057532;
        Wed, 28 Oct 2020 19:20:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e1b0:db06:9a2d:91c5])
        by smtp.googlemail.com with ESMTPSA id t2sm1012135iob.5.2020.10.28.19.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:20:56 -0700 (PDT)
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
 <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7a412e24-0846-bffe-d533-3407d06d83c4@gmail.com>
Date:   Wed, 28 Oct 2020 20:20:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 8:06 PM, Hangbin Liu wrote:
> On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:
>> fails to compile on Ubuntu 20.10:
>>
>> root@u2010-sfo3:~/iproute2.git# ./configure
>> TC schedulers
>>  ATM	yes
>>  IPT	using xtables
>>  IPSET  yes
>>
>> iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
>> libc has setns: yes
>> SELinux support: yes
>> libbpf support: yes
>> ELF support: yes
>> libmnl support: yes
>> Berkeley DB: no
>> need for strlcpy: yes
>> libcap support: yes
>>
>> root@u2010-sfo3:~/iproute2.git# make clean
>>
>> root@u2010-sfo3:~/iproute2.git# make -j 4
>> ...
>> /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
>> bpf_libbpf.c:(.text+0x3cb): undefined reference to
>> `bpf_program__section_name'
>> /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
>> `bpf_program__section_name'
>> /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
>> `bpf_program__section_name'
>> collect2: error: ld returned 1 exit status
>> make[1]: *** [Makefile:27: ip] Error 1
>> make[1]: *** Waiting for unfinished jobs....
>> make: *** [Makefile:64: all] Error 2
> 
> You need to update libbpf to latest version.

nope. you need to be able to handle this. Ubuntu 20.10 was just
released, and it has a version of libbpf. If you are going to integrate
libbpf into other packages like iproute2, it needs to just work with
that version.

> 
> But this also remind me that I need to add bpf_program__section_name() to
> configure checking. I will see if I missed other functions' checking.

This is going to be an on-going problem. iproute2 should work with
whatever version of libbpf is installed on that system.

