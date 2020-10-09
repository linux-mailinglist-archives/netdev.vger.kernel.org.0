Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63462288C6D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389233AbgJIPRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:17:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:40822 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388812AbgJIPRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:17:50 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQu9U-0006vG-5J; Fri, 09 Oct 2020 17:17:48 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQu9T-000CkB-V3; Fri, 09 Oct 2020 17:17:47 +0200
Subject: Re: [PATCH bpf-next v2] bpf: add tcp_notsent_lowat bpf setsockopt
To:     Yonghong Song <yhs@fb.com>,
        "Nikita V. Shirokov" <tehnerd@tehnerd.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org
References: <20201009070325.226855-1-tehnerd@tehnerd.com>
 <a75100e2-ceec-f7d8-0f3d-decbfee95d83@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8da62558-4631-ba90-cb54-8796f0a85d72@iogearbox.net>
Date:   Fri, 9 Oct 2020 17:17:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a75100e2-ceec-f7d8-0f3d-decbfee95d83@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 5:06 PM, Yonghong Song wrote:
> On 10/9/20 12:03 AM, Nikita V. Shirokov wrote:
>> Adding support for TCP_NOTSENT_LOWAT sockoption
>> (https://lwn.net/Articles/560082/ ) in tcpbpf
>>
>> v1->v2:
>> - addressing yhs@ comments. explicitly defining TCP_NOTSENT_LOWAT in
>>    selftests if it is not defined in the system
>>
>> Signed-off-by: Nikita V. Shirokov <tehnerd@tehnerd.com>
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Applied & also copied the include/uapi/linux/bpf.h over to the
tools/include/uapi/linux/bpf.h as well, thanks!
