Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2643CCA53
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 21:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhGRTHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 15:07:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:52406 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGRTHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 15:07:21 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m5C5J-000GiH-Bp; Sun, 18 Jul 2021 21:04:17 +0200
Received: from [185.105.41.246] (helo=linux.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m5C5I-000OnZ-UA; Sun, 18 Jul 2021 21:04:16 +0200
Subject: Re: [PATCH] libbpf: Remove from kernel tree.
To:     Michal Suchanek <msuchanek@suse.de>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
References: <20210718065039.15627-1-msuchanek@suse.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c621c6c6-ad2d-5ce0-3f8c-014daf7cad64@iogearbox.net>
Date:   Sun, 18 Jul 2021 21:04:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210718065039.15627-1-msuchanek@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26236/Sun Jul 18 10:19:21 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/21 8:50 AM, Michal Suchanek wrote:
> libbpf shipped by the kernel is outdated and has problems. Remove it.
> 
> Current version of libbpf is available at
> 
> https://github.com/libbpf/libbpf
> 
> Link: https://lore.kernel.org/bpf/b07015ebd7bbadb06a95a5105d9f6b4ed5817b2f.camel@debian.org/
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

NAK, I'm not applying any of this. If there are issues, then fix them. If
you would have checked tools/lib/bpf/ git history, you would have found
that libbpf is under active development in the upstream kernel tree and
you could have spared yourself this patch.
