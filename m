Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8631A49514
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfFQWVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:21:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:33272 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbfFQWUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:20:52 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hczzb-0006Fj-Pk; Tue, 18 Jun 2019 00:20:47 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hczzb-0001l0-Ig; Tue, 18 Jun 2019 00:20:47 +0200
Subject: Re: [PATCH v2 bpf-next 09/11] selftests/bpf: switch
 BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
To:     Song Liu <songliubraving@fb.com>, Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
 <20190617192700.2313445-10-andriin@fb.com>
 <4DCC6EC0-9B6A-49D9-8664-ADC557C5DD36@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a1f1efc8-c280-1305-72c6-e8533840b615@iogearbox.net>
Date:   Tue, 18 Jun 2019 00:20:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <4DCC6EC0-9B6A-49D9-8664-ADC557C5DD36@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25483/Mon Jun 17 09:56:00 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/17/2019 11:41 PM, Song Liu wrote:
>> On Jun 17, 2019, at 12:26 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>
>> Switch tests that already rely on BTF to BTF-defined map definitions.
>>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> 
> For 09 to 11:
> 
> Acked-by: Song Liu <songliubraving@fb.com>

I've added it to patch 10 by hand given the manual labor for dropping 11 anyway.
Please keep in mind that patchwork doesn't understand/propagate 'for 09 to 11',
and explicitly ack in future, thanks.
