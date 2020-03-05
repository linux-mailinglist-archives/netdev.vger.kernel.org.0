Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B56C17A8B6
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCEPTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:19:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:39268 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgCEPTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:19:46 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9sHZ-000311-Dl; Thu, 05 Mar 2020 16:19:29 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9sHY-000BjU-MB; Thu, 05 Mar 2020 16:19:28 +0100
Subject: Re: [PATCH bpf-next v5 0/4] eBPF JIT for RV32G
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
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
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4633123d-dc61-ab79-d2ee-e0cef66e4cea@iogearbox.net>
Date:   Thu, 5 Mar 2020 16:19:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNjrUxVqpBgC-WLHbZX7_7Gd-Lk7ghrmASTmaNySuXVUfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25742/Thu Mar  5 15:10:18 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 6:40 AM, Björn Töpel wrote:
> On Thu, 5 Mar 2020 at 06:02, Luke Nelson <lukenels@cs.washington.edu> wrote:
>>
>> This series adds an eBPF JIT for 32-bit RISC-V (RV32G) to the kernel,
>> adapted from the RV64 JIT and the 32-bit ARM JIT.
>>
> 
> Nice work! Thanks for hanging in there!
> 
> For the series,
> Acked-by: Björn Töpel <bjorn.topel@gmail.com>
> Reviewed-by: Björn Töpel <bjorn.topel@gmail.com>

Applied, thanks everyone!

P.s.: I fixed the MAINTAINERS entry in the last one to have both netdev and bpf
to be consistent with all the other JIT entries there.
