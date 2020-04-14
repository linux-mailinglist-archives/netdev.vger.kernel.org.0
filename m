Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844951A8B56
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505150AbgDNTou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:44:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:51256 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505152AbgDNToh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:44:37 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORU0-0002RT-JV; Tue, 14 Apr 2020 21:44:32 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORU0-0006yB-Bh; Tue, 14 Apr 2020 21:44:32 +0200
Subject: Re: [PATCH] tools: bpftool: fix struct_ops command invalid pointer
 free
To:     Martin KaFai Lau <kafai@fb.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200410020612.2930667-1-danieltimlee@gmail.com>
 <20200410050333.qshidymodw3oyn6k@kafai-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f0f902f7-d3ff-bca8-a17b-d5f8f6ab6310@iogearbox.net>
Date:   Tue, 14 Apr 2020 21:44:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200410050333.qshidymodw3oyn6k@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25782/Tue Apr 14 13:57:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/20 7:03 AM, Martin KaFai Lau wrote:
> On Fri, Apr 10, 2020 at 11:06:12AM +0900, Daniel T. Lee wrote:
>>  From commit 65c93628599d ("bpftool: Add struct_ops support"),
>> a new type of command struct_ops has been added.
>>
>> This command requires kernel CONFIG_DEBUG_INFO_BTF=y, and for retrieving
>> btf info, get_btf_vmlinux() is used.
>>
>> When running this command on kernel without BTF debug info, this will
>> lead to 'btf_vmlinux' variable contains invalid(error) pointer. And by
>> this, btf_free() causes a segfault when executing 'bpftool struct_ops'.
>>
>> This commit adds pointer validation with IS_ERR not to free invalid
>> pointer, and this will fix the segfault issue.
>>
>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> Fixes: 65c93628599d ("bpftool: Add struct_ops support")
> Acked-by: Martin KaFai Lau

Applied & fixed up email, thanks!
