Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517563C5EEE
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhGLPTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:19:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:59444 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhGLPTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 11:19:38 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m2xfs-000FQK-0y; Mon, 12 Jul 2021 17:16:48 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m2xfr-00046R-Nn; Mon, 12 Jul 2021 17:16:47 +0200
Subject: Re: [PATCH bpf] bpf: fix for BUG: kernel NULL pointer dereference,
 address: 0000000000000000
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>
References: <20210708080409.73525-1-xuanzhuo@linux.alibaba.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ca12f265-1223-de25-a23b-a3d53dceb4d5@iogearbox.net>
Date:   Mon, 12 Jul 2021 17:16:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210708080409.73525-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26229/Mon Jul 12 13:09:43 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 10:04 AM, Xuan Zhuo wrote:
> These two types of xdp prog(BPF_XDP_DEVMAP, BPF_XDP_CPUMAP) will not be
> executed directly in the driver, we should not directly run these two
> XDP progs here. To run these two situations, there must be some special
> preparations, otherwise it may cause kernel exceptions.

Applied, thanks!
