Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C346CE9
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfFNXYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:24:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:41504 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFNXY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:24:29 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvYL-0008Ll-NO; Sat, 15 Jun 2019 01:24:13 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvYL-000HLG-Hh; Sat, 15 Jun 2019 01:24:13 +0200
Subject: Re: [PATCH bpf-next] bpf: Fix build error without CONFIG_INET
To:     YueHaibing <yuehaibing@huawei.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com
Cc:     linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20190612091847.23708-1-yuehaibing@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d4b83351-91ef-d53f-5c78-e03cd8284fb0@iogearbox.net>
Date:   Sat, 15 Jun 2019 01:24:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190612091847.23708-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25480/Fri Jun 14 10:12:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2019 11:18 AM, YueHaibing wrote:
> If CONFIG_INET is not set, building fails:
> 
> kernel/bpf/verifier.o: In function `check_mem_access':
> verifier.c: undefined reference to `bpf_xdp_sock_is_valid_access'
> kernel/bpf/verifier.o: In function `convert_ctx_accesses':
> verifier.c: undefined reference to `bpf_xdp_sock_convert_ctx_access'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: fada7fdc83c0 ("bpf: Allow bpf_map_lookup_elem() on an xskmap")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks!
