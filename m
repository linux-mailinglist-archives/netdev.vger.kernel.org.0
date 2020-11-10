Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334982ACE56
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbgKJEJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731265AbgKJEJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 23:09:49 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11234C0613CF;
        Mon,  9 Nov 2020 20:09:49 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id x7so10537754ili.5;
        Mon, 09 Nov 2020 20:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Utwg1xneuTB1DBHIkBfa/pGwylx/dG7h4KQnrhH/0NM=;
        b=uBTFA/GyAp2x/Sl39FT2wp8Hzh0vnDazURfwIMHDO6wq8d6X3cvGBGumfzy+Hcp3RN
         jU5DTRtu3aNVO7QJfTTE1xfpYm/rDl3WDwf+H5bJWoJwFg+rScyudInBwmxoEvzuDuCg
         AIbzyYNfIOcCFWYBZPgkYTZPsbMML7qm0GFEkOMpQvvLC41jnQkG06ij/m6n8yKbxxMV
         rgfa7sMSJkitUNhjOSB86WPNo8B5Q4nz4bkIZ7radfTk8ypgvd5swZadEEbYByCxXKIG
         kCSTopMwsJbd2oBaatepsGI3zeZKrfcWVZ2iROYSrvw4V9r9tPSOYFiDHKfUXrFBSaG3
         XTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Utwg1xneuTB1DBHIkBfa/pGwylx/dG7h4KQnrhH/0NM=;
        b=iVtZVtd7YsvilTx1epxiYhIvKlMB6zD36S8GQzGk9K2FO4N43rAtYdoNOPZ/7YluJf
         BGFHNma/ewvzwEPSlhhIcWa8H//Y47A7HlvAxILk2C27Csv4QQBjfPC2qK1VVx9PJXZV
         CzB8jeKlEvKfZ+JuEAcnS2dn+r6Z+DYZlP6qIkBhpxbeSg5R02Nzae9G9kEEstyHo22j
         2qca6iX1EHHmFX3ZeywIKYkxhTEZeSuiyE4Ef+jLw3u+pSZtYkZme6JUP4Xyu5htWp2y
         0Pn1kogvOwX/4gfEyoBPbYj/QDnMc1bovCVhLwLGSR4hS8FqmcmJRke7dgvcc/vWEoh3
         VBGA==
X-Gm-Message-State: AOAM531ft16nADyT7d6qHRQMMglrxsjtPrWYZ8pbrAd9Jq1FzMaV11s7
        Bl6FoYMCXcMKchskb+CNazk=
X-Google-Smtp-Source: ABdhPJw13o4Oa2PLdGoZBDR6cN42/13Zwro8be5eInCsk7i0PYOhbKkURYECDl3TfmJ6gTbxuDEkLQ==
X-Received: by 2002:a05:6e02:4a9:: with SMTP id e9mr12630174ils.24.1604981388270;
        Mon, 09 Nov 2020 20:09:48 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7980:a277:20c7:aa44])
        by smtp.googlemail.com with ESMTPSA id l78sm8440977ild.30.2020.11.09.20.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 20:09:47 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
 <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
Date:   Mon, 9 Nov 2020 21:09:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201109014515.rxz3uppztndbt33k@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/20 6:45 PM, Alexei Starovoitov wrote:
> 
> I don't understand why on one side you're pointing out existing quirkiness with
> bpf usability while at the same time arguing to make it _less_ user friendly

I believe you have confused my comments with others. My comments have
focused on one aspect: The insistence by BPF maintainers that all code
bases and users constantly chase latest and greatest versions of
relevant S/W to use BPF - though I believe a lot of the tool chasing
stems from BTF. I am fairly certain I have been consistent in that theme
within this thread.

> when myself, Daniel, Andrii explained in detail what libbpf does and how it
> affects user experience?
> 
> The analogy of libbpf in iproute2 and libbfd in gdb is that both libraries

Your gdb / libbfd analogy misses the mark - by a lot. That analogy is
relevant for bpftool, not iproute2.

iproute2 can leverage libbpf for 3 or 4 tc modules and a few xdp hooks.
That is it, and it is a tiny percentage of the functionality in the package.

