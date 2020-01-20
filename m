Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5171433CA
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgATWQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:16:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:56002 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATWQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:16:20 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1itfLE-0008Sm-VD; Mon, 20 Jan 2020 23:16:17 +0100
Received: from [178.197.248.27] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1itfLE-000EsU-MB; Mon, 20 Jan 2020 23:16:16 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: don't check for btf fd in
 test_btf
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20200118010546.74279-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3eab56a9-2720-b346-2d78-f778cb3e3add@iogearbox.net>
Date:   Mon, 20 Jan 2020 23:16:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200118010546.74279-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25701/Mon Jan 20 12:41:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/20 2:05 AM, Stanislav Fomichev wrote:
> After commit 0d13bfce023a ("libbpf: Don't require root for
> bpf_object__open()") we no longer load BTF during bpf_object__open(),
> so let's remove the expectation from test_btf that the fd is not -1.
> The test currently fails.
> 
> Before:
> BTF libbpf test[1] (test_btf_haskv.o): do_test_file:4152:FAIL bpf_object__btf_fd: -1
> BTF libbpf test[2] (test_btf_newkv.o): do_test_file:4152:FAIL bpf_object__btf_fd: -1
> BTF libbpf test[3] (test_btf_nokv.o): do_test_file:4152:FAIL bpf_object__btf_fd: -1
> 
> After:
> BTF libbpf test[1] (test_btf_haskv.o): OK
> BTF libbpf test[2] (test_btf_newkv.o): OK
> BTF libbpf test[3] (test_btf_nokv.o): OK
> 
> Fixes: 0d13bfce023a ("libbpf: Don't require root forbpf_object__open()")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
