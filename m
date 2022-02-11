Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED014B282E
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 15:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350970AbiBKOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 09:44:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238660AbiBKOof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 09:44:35 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE047B0;
        Fri, 11 Feb 2022 06:44:33 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIX9t-0006Rr-V1; Fri, 11 Feb 2022 15:44:25 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIX9t-000KZK-Kq; Fri, 11 Feb 2022 15:44:25 +0100
Subject: Re: [PATCH bpf-next 1/2] bpf: Add some description about
 BPF_JIT_ALWAYS_ON in Kconfig
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1644569851-20859-1-git-send-email-yangtiezhu@loongson.cn>
 <1644569851-20859-2-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4b4431d4-4ad4-19b2-dd03-688165e3d470@iogearbox.net>
Date:   Fri, 11 Feb 2022 15:44:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1644569851-20859-2-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26450/Fri Feb 11 10:24:09 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 9:57 AM, Tiezhu Yang wrote:
> When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently
> set to 1 and setting any other value than that will return in failure.
> 
> Add the above description in the help text of BPF_JIT_ALWAYS_ON, and then
> we can distinguish between BPF_JIT_ALWAYS_ON and BPF_JIT_DEFAULT_ON.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   kernel/bpf/Kconfig | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index d24d518..88409f8 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -58,6 +58,9 @@ config BPF_JIT_ALWAYS_ON
>   	  Enables BPF JIT and removes BPF interpreter to avoid speculative
>   	  execution of BPF instructions by the interpreter.
>   
> +	  When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently
> +	  set to 1 and setting any other value than that will return in failure.

Small nit here: lets use the full path (/proc/sys/net/core/bpf_jit_enable) in order
to be consistent with the other descriptions in this Kconfig.

>   config BPF_JIT_DEFAULT_ON
>   	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
>   	depends on HAVE_EBPF_JIT && BPF_JIT
> 

