Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE60446659
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 16:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhKEPta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 11:49:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:55634 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbhKEPt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 11:49:28 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mj1QT-0008ua-Ri; Fri, 05 Nov 2021 16:46:45 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mj1QT-000TP1-JG; Fri, 05 Nov 2021 16:46:45 +0100
Subject: Re: [PATCH bpf 0/4] Fix some issues for selftest
 test_xdp_redirect_multi.sh
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-kselftest@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>
References: <20211027033553.962413-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a3257169-b252-9446-1893-08ef9d1f9bcf@iogearbox.net>
Date:   Fri, 5 Nov 2021 16:46:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211027033553.962413-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26344/Fri Nov  5 09:18:44 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 5:35 AM, Hangbin Liu wrote:
> Jiri reported some issues in test_xdp_redirect_multi.sh. Like
> the test logs not cleaned after testing. The tcpdump not terminated cleanly.
> arp number count may have false positive. And the most important, after
> creating/deleting a lot interfaces, the interface index may exceed the
> DEVMAP max entry and cause program xdp_redirect_multi exec failed.
> 
> This patch set fix all these issues.
> 
> Hangbin Liu (4):
>    selftests/bpf/xdp_redirect_multi: put the logs to tmp folder
>    selftests/bpf/xdp_redirect_multi: use arping to accurate the arp
>      number
>    selftests/bpf/xdp_redirect_multi: give tcpdump a chance to terminate
>      cleanly
>    selftests/bpf/xdp_redirect_multi: limit the tests in netns
> 
>   .../selftests/bpf/test_xdp_redirect_multi.sh  | 62 +++++++++++--------
>   .../selftests/bpf/xdp_redirect_multi.c        |  4 +-
>   2 files changed, 37 insertions(+), 29 deletions(-)

Applied, thanks, been fixing up a small merge conflict in the last one due to
8fffa0e3451ab ("selftests/bpf: Normalize XDP section names in selftests"), pls
double check.
