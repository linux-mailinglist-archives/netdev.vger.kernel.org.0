Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55576147A63
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgAXJcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:32:33 -0500
Received: from www62.your-server.de ([213.133.104.62]:45784 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXJcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:32:33 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvKG-0006Dq-UV; Fri, 24 Jan 2020 10:32:29 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvKG-000Bp8-I2; Fri, 24 Jan 2020 10:32:28 +0100
Subject: Re: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport
 tests
To:     Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-3-lmb@cloudflare.com>
 <20200123215348.zql3d5xpg2if7v6q@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw9_OGBbsXepTcp=1frEHB7Q2cD9BVXTbgt7Ci_eFyV2Egg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d5d230bd-6d62-3bb4-f663-8cec751b38a4@iogearbox.net>
Date:   Fri, 24 Jan 2020 10:32:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACAyw9_OGBbsXepTcp=1frEHB7Q2cD9BVXTbgt7Ci_eFyV2Egg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 10:00 AM, Lorenz Bauer wrote:
> On Thu, 23 Jan 2020 at 21:54, Martin Lau <kafai@fb.com> wrote:
>>
>> btw, it needs a Fixes tag.
>>
>> Patch 4 and Patch 1 also need a Fixes tag.
> 
> This makes me wonder, should these go via bpf or bpf-next? Do I have
> to split the series then?

Lets do all of these for bpf-next since timing is very close before v5.5 release.
If needed, we can later have them picked up for 5.5 stable.

Thanks,
Daniel
