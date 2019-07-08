Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0610962455
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391042AbfGHPln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:41:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:45224 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388764AbfGHP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:26:10 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVWm-0000hB-4N; Mon, 08 Jul 2019 17:26:04 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVWl-0005gf-Te; Mon, 08 Jul 2019 17:26:03 +0200
Subject: Re: [PATCH v2 bpf-next] bpf: cgroup: Fix build error without
 CONFIG_NET
To:     YueHaibing <yuehaibing@huawei.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, sdf@google.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <fd312c26-db8e-cae3-1c14-869d8e3a62ae@fb.com>
 <20190703082630.51104-1-yuehaibing@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <51277a61-c2a0-02c8-5ebe-00db1a222386@iogearbox.net>
Date:   Mon, 8 Jul 2019 17:26:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190703082630.51104-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2019 10:26 AM, YueHaibing wrote:
> If CONFIG_NET is not set and CONFIG_CGROUP_BPF=y,
> gcc building fails:
> 
> kernel/bpf/cgroup.o: In function `cg_sockopt_func_proto':
> cgroup.c:(.text+0x237e): undefined reference to `bpf_sk_storage_get_proto'
> cgroup.c:(.text+0x2394): undefined reference to `bpf_sk_storage_delete_proto'
> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_getsockopt':
> (.text+0x2a1f): undefined reference to `lock_sock_nested'
> (.text+0x2ca2): undefined reference to `release_sock'
> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_setsockopt':
> (.text+0x3006): undefined reference to `lock_sock_nested'
> (.text+0x32bb): undefined reference to `release_sock'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Suggested-by: Stanislav Fomichev <sdf@fomichev.me>
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks!
