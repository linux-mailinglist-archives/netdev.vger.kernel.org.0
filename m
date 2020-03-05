Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4642D17B1DB
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgCEWrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:47:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:51744 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgCEWrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 17:47:14 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9zGd-0007qj-P2; Thu, 05 Mar 2020 23:46:59 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9zGd-000UwR-1P; Thu, 05 Mar 2020 23:46:59 +0100
Subject: Re: [PATCH bpf-next v5 0/4] eBPF JIT for RV32G
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
References: <20200305050207.4159-1-luke.r.nels@gmail.com>
 <CAJ+HfNjrUxVqpBgC-WLHbZX7_7Gd-Lk7ghrmASTmaNySuXVUfg@mail.gmail.com>
 <4633123d-dc61-ab79-d2ee-e0cef66e4cea@iogearbox.net>
 <CAJ+HfNg_cP8DC+C0UGHnumde6+YhqBoTB909A9XwFMPv82tqWw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d95a83aa-d91c-6e5f-b9ec-0de0af23770a@iogearbox.net>
Date:   Thu, 5 Mar 2020 23:46:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNg_cP8DC+C0UGHnumde6+YhqBoTB909A9XwFMPv82tqWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25742/Thu Mar  5 15:10:18 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 5:53 PM, Björn Töpel wrote:
> On Thu, 5 Mar 2020 at 16:19, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
> [...]
>> Applied, thanks everyone!
>>
>> P.s.: I fixed the MAINTAINERS entry in the last one to have both netdev and bpf
>> to be consistent with all the other JIT entries there.
> 
> Ah, I asked specifically Xi and Luke to *remove* the netdev entry, due
> to the bpf_devel_QA.rst change. :-)

Ah right, although all the BPF entries in MAINTAINERS file have both lists
mentioned today. I think it doesn't hurt to have potentially more eyes for
reviews.

Thanks,
Daniel
