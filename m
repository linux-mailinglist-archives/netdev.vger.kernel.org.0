Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF52D459F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgLIPlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:41:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:35738 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgLIPlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:41:36 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kn1a5-00063e-CI; Wed, 09 Dec 2020 16:40:41 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kn1a4-000UHn-V9; Wed, 09 Dec 2020 16:40:40 +0100
Subject: Re: [PATCH bpf v4 0/7] selftests/bpf: Restore test_offload.py to
 working order
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160752225643.110217.4104692937165406635.stgit@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2263984f-68b9-c678-5cae-a26b3e96e36b@iogearbox.net>
Date:   Wed, 9 Dec 2020 16:40:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160752225643.110217.4104692937165406635.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26012/Tue Dec  8 15:38:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 2:57 PM, Toke Høiland-Jørgensen wrote:
> This series restores the test_offload.py selftest to working order. It seems a
> number of subtle behavioural changes have crept into various subsystems which
> broke test_offload.py in a number of ways. Most of these are fairly benign
> changes where small adjustments to the test script seems to be the best fix, but
> one is an actual kernel bug that I've observed in the wild caused by a bad
> interaction between xdp_attachment_flags_ok() and the rework of XDP program
> handling in the core netdev code.
> 
> Patch 1 fixes the bug by removing xdp_attachment_flags_ok(), and the reminder of
> the patches are adjustments to test_offload.py, including a new feature for
> netdevsim to force a BPF verification fail. Please see the individual patches
> for details.
> 
> Changelog:
> 
> v4:
> - Accidentally truncated the Fixes: hashes in patches 3/4 to 11 chars
> v3:
> - Add Fixes: tags
> v2:
> - Replace xdp_attachment_flags_ok() with a check in dev_xdp_attach()
> - Better packing of struct nsim_dev

Applied, thanks! I took the liberty to document the prior review with 'LGTM' as
an Ack so it's documented in the git log as well.
