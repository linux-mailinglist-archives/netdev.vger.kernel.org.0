Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9862762465
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391074AbfGHPmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:42:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:45006 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388566AbfGHPZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:25:21 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVW0-0000cl-JM; Mon, 08 Jul 2019 17:25:16 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVW0-000WCe-Dd; Mon, 08 Jul 2019 17:25:16 +0200
Subject: Re: [PATCH bpf-next v3 0/3] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20190701173841.32249-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cc6a7a57-7c9d-7c3a-86d4-5e4a8a74b26b@iogearbox.net>
Date:   Mon, 8 Jul 2019 17:25:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190701173841.32249-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01/2019 07:38 PM, Stanislav Fomichev wrote:
> Clang can generate 8-byte stores for user_ip6 & msg_src_ip6,
> let's support that on the verifier side.
> 
> v3:
> * fix comments spelling an -> and (Andrii Nakryiko)
> 
> v2:
> * Add simple cover letter (Yonghong Song)
> * Update comments (Yonghong Song)
> * Remove [4] selftests (Yonghong Song)
> 
> Stanislav Fomichev (3):
>   bpf: allow wide (u64) aligned stores for some fields of bpf_sock_addr
>   bpf: sync bpf.h to tools/
>   selftests/bpf: add verifier tests for wide stores
> 
>  include/linux/filter.h                        |  6 ++++
>  include/uapi/linux/bpf.h                      |  6 ++--
>  net/core/filter.c                             | 22 +++++++-----
>  tools/include/uapi/linux/bpf.h                |  6 ++--
>  tools/testing/selftests/bpf/test_verifier.c   | 17 +++++++--
>  .../selftests/bpf/verifier/wide_store.c       | 36 +++++++++++++++++++
>  6 files changed, 76 insertions(+), 17 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
> 

Applied, thanks!
