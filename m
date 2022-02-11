Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF054B2305
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348864AbiBKKYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:24:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346916AbiBKKYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:24:09 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55885220;
        Fri, 11 Feb 2022 02:24:08 -0800 (PST)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIT5s-000AVF-Pf; Fri, 11 Feb 2022 11:24:00 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIT5s-000DIF-Dm; Fri, 11 Feb 2022 11:24:00 +0100
Subject: Re: [PATCH bpf-next 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable in
 Kconfig
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
 <1644569851-20859-3-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <af2b415a-874d-0524-c5bb-b50c419a1559@iogearbox.net>
Date:   Fri, 11 Feb 2022 11:23:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1644569851-20859-3-git-send-email-yangtiezhu@loongson.cn>
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
> Currently, it is not possible to set bpf_jit_enable to 1 by default
> and the users can change it to 0 or 2, it seems bad for some users,
> make BPF_JIT_DEFAULT_ON selectable to give them a chance.

I'm not fully sure I follow the above, so you are saying that a kconfig of
!BPF_JIT_ALWAYS_ON and ARCH_WANT_DEFAULT_BPF_JIT, enables BPF_JIT_DEFAULT_ON
however in such setting you are not able to reset bpf_jit_enable back to 0 at
runtime?

Thanks,
Daniel
