Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF574A6EAB
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244995AbiBBKZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:25:55 -0500
Received: from www62.your-server.de ([213.133.104.62]:54592 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242029AbiBBKZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:25:54 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFCpg-00009B-4Z; Wed, 02 Feb 2022 11:25:48 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFCpf-00078Q-P3; Wed, 02 Feb 2022 11:25:47 +0100
Subject: Re: [PATCH bpf-next 0/5] Allow CONFIG_DEBUG_INFO_DWARF5=y +
 CONFIG_DEBUG_INFO_BTF=y
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
References: <20220201205624.652313-1-nathan@kernel.org>
 <CAEf4BzbLwMCHDncHW-hH2kgOWc9jQK7QVkcH9aOKm7n7YC2LgQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c1eb308e-1f02-492b-53f1-762daa3d8ff3@iogearbox.net>
Date:   Wed, 2 Feb 2022 11:25:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbLwMCHDncHW-hH2kgOWc9jQK7QVkcH9aOKm7n7YC2LgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26440/Tue Feb  1 10:29:16 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 8:05 AM, Andrii Nakryiko wrote:
> On Tue, Feb 1, 2022 at 12:56 PM Nathan Chancellor <nathan@kernel.org> wrote:
>>
>> This series allows CONFIG_DEBUG_INFO_DWARF5 to be selected with
>> CONFIG_DEBUG_INFO_BTF=y by checking the pahole version.
>>
>> The first four patches add CONFIG_PAHOLE_VERSION and
>> scripts/pahole-version.sh to clean up all the places that pahole's
>> version is transformed into a 3-digit form.
>>
>> The fourth patch adds a PAHOLE_VERSION dependency to DEBUG_INFO_DWARF5
>> so that there are no build errors when it is selected with
>> DEBUG_INFO_BTF.
>>
>> I build tested Fedora's aarch64 and x86_64 config with ToT clang 14.0.0
>> and GCC 11 with CONFIG_DEBUG_INFO_DWARF5 enabled with both pahole 1.21
>> and 1.23.
>>
>> Nathan Chancellor (5):
>>    MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
>>    kbuild: Add CONFIG_PAHOLE_VERSION
>>    scripts/pahole-flags.sh: Use pahole-version.sh
>>    lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
>>    lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
>>
> 
> LGTM. I'd probably combine patches 2 and 3, but it's minor. I really
> like the CONFIG_PAHOLE_VERSION and how much cleaner it makes Kconfig
> options.

+1, thanks for working on getting this enabled! I think patches 2 and 3 are
rather logically separate, so as-is is fine as well imho. Applied, thanks!
