Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60C54197EA
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhI0P3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:29:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:39748 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbhI0P2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:28:16 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mUsWR-000FdL-9B; Mon, 27 Sep 2021 17:26:27 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mUsWQ-000R5W-Se; Mon, 27 Sep 2021 17:26:26 +0200
Subject: Re: [PATCH RESEND bpf] bpf, s390: Fix potential memory leak about
 jit_data
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1632726374-7154-1-git-send-email-yangtiezhu@loongson.cn>
 <e9665315bc2f244d50d026863476e72e3d9b8067.camel@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c02febfc-03e6-848a-8fb0-5bd6802c1869@iogearbox.net>
Date:   Mon, 27 Sep 2021 17:26:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e9665315bc2f244d50d026863476e72e3d9b8067.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26305/Mon Sep 27 11:04:42 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 1:33 PM, Ilya Leoshkevich wrote:
> On Mon, 2021-09-27 at 15:06 +0800, Tiezhu Yang wrote:
>> Make sure to free jit_data through kfree() in the error path.
>>
>> Fixes: 1c8f9b91c456 ("bpf: s390: add JIT support for multi-function
>> programs")
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
>>
>> RESEND due to the following reason:
>> [Can not connect to recipient's server because of unstable
>> network or firewall filter. rcpt handle timeout, last handle
>> info: Can not connect to vger.kernel.org]
>>
>>   arch/s390/net/bpf_jit_comp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Nice catch, thanks!
> 
> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

Given s390, I presume this would be routed to Linus via Heiko/Vasily?

Thanks,
Daniel
