Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E909F64D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 00:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfH0Wno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 18:43:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:34028 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfH0Wnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 18:43:43 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2kBa-0004N0-Dd; Wed, 28 Aug 2019 00:43:34 +0200
Received: from [178.197.249.36] (helo=pc-63.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2kBa-00024h-3q; Wed, 28 Aug 2019 00:43:34 +0200
Subject: Re: [PATCH bpf-next 0/4] bpf: precision tracking tests
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20190823055215.2658669-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b86d7cc7-4188-1a47-7dde-e9970be098c4@iogearbox.net>
Date:   Wed, 28 Aug 2019 00:43:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190823055215.2658669-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25554/Tue Aug 27 10:24:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 7:52 AM, Alexei Starovoitov wrote:
> Add few additional tests for precision tracking in the verifier.
> 
> Alexei Starovoitov (4):
>    bpf: introduce verifier internal test flag
>    tools/bpf: sync bpf.h
>    selftests/bpf: verifier precise tests
>    selftests/bpf: add precision tracking test
> 
>   include/linux/bpf_verifier.h                  |   1 +
>   include/uapi/linux/bpf.h                      |   3 +
>   kernel/bpf/syscall.c                          |   1 +
>   kernel/bpf/verifier.c                         |   5 +-
>   tools/include/uapi/linux/bpf.h                |   3 +
>   tools/testing/selftests/bpf/test_verifier.c   |  68 +++++++--
>   .../testing/selftests/bpf/verifier/precise.c  | 142 ++++++++++++++++++
>   7 files changed, 211 insertions(+), 12 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/verifier/precise.c
> 

Applied, thanks!
