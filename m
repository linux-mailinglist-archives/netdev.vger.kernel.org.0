Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A84C70D0
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbiB1PhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 10:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiB1PhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 10:37:06 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BD869CD3;
        Mon, 28 Feb 2022 07:36:27 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOi4P-000Ckj-AD; Mon, 28 Feb 2022 16:36:17 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOi4O-000583-Sz; Mon, 28 Feb 2022 16:36:16 +0100
Subject: Re: [PATCH bpf-next v4 0/4] bpf, arm64: support more atomic ops
To:     Will Deacon <will@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Hou Tao <houtao1@huawei.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Jakub Kicinski <kuba@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <20220217072232.1186625-1-houtao1@huawei.com>
 <164556514968.1490345.10884104309048795776.b4-ty@kernel.org>
 <20220222224211.GB16976@willie-the-truck>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <03278d8c-2b21-1fb0-1942-abea68c133ae@iogearbox.net>
Date:   Mon, 28 Feb 2022 16:36:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220222224211.GB16976@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26467/Mon Feb 28 10:24:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/22 11:42 PM, Will Deacon wrote:
> On Tue, Feb 22, 2022 at 10:38:02PM +0000, Will Deacon wrote:
>> On Thu, 17 Feb 2022 15:22:28 +0800, Hou Tao wrote:
>>> Atomics support in bpf has already been done by "Atomics for eBPF"
>>> patch series [1], but it only adds support for x86, and this patchset
>>> adds support for arm64.
>>>
>>> Patch #1 & patch #2 are arm64 related. Patch #1 moves the common used
>>> macro AARCH64_BREAK_FAULT into insn-def.h for insn.h. Patch #2 adds
>>> necessary encoder helpers for atomic operations.
>>>
>>> [...]
>>
>> Applied to arm64 (for-next/insn), thanks!
>>
>> [1/4] arm64: move AARCH64_BREAK_FAULT into insn-def.h
>>        https://git.kernel.org/arm64/c/97e58e395e9c
>> [2/4] arm64: insn: add encoders for atomic operations
>>        https://git.kernel.org/arm64/c/fa1114d9eba5
> 
> Daniel -- let's give this a day or so in -next, then if nothing catches
> fire you're more than welcome to pull this branch as a base for the rest
> of the series.

Thanks Will! Pulled and applied the rest to bpf-next, thanks everyone!
