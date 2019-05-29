Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E32DD9C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 14:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfE2M7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 08:59:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:43308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfE2M7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 08:59:50 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVyBH-0003VG-Rm; Wed, 29 May 2019 14:59:47 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVyBH-000DqE-Lm; Wed, 29 May 2019 14:59:47 +0200
Subject: Re: [PATCH bpf 0/2] selftests: bpf: more sub-register zero extension
 unit tests
To:     Jiong Wang <jiong.wang@netronome.com>, alexei.starovoitov@gmail.com
Cc:     bjorn.topel@intel.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <1559123829-9318-1-git-send-email-jiong.wang@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e346c0c6-89dd-d04f-a0cf-60c15b2d2a8a@iogearbox.net>
Date:   Wed, 29 May 2019 14:59:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1559123829-9318-1-git-send-email-jiong.wang@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25464/Wed May 29 09:59:09 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/29/2019 11:57 AM, Jiong Wang wrote:
> JIT back-ends need to guarantee high 32-bit cleared whenever one eBPF insn
> write low 32-bit sub-register only. It is possible that some JIT back-ends
> have failed doing this and are silently generating wrong image.
> 
> This set completes the unit tests, so bug on this could be exposed.
> 
> Jiong Wang (2):
>   selftests: bpf: move sub-register zero extension checks into subreg.c
>   selftests: bpf: complete sub-register zero extension checks
> 
>  tools/testing/selftests/bpf/verifier/basic_instr.c |  39 --
>  tools/testing/selftests/bpf/verifier/subreg.c      | 533 +++++++++++++++++++++
>  2 files changed, 533 insertions(+), 39 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/subreg.c

Looks good, thanks for following up! Applied, thanks!
