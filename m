Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F58324804
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbhBYArg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:47:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:38714 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbhBYAr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 19:47:29 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF4nT-0000J2-K3; Thu, 25 Feb 2021 01:46:27 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF4nT-000Mzt-72; Thu, 25 Feb 2021 01:46:27 +0100
Subject: Re: [PATCH v8 bpf-next 0/5] xsk: build skb by page (aka generic
 zerocopy xmit)
To:     Alexander Lobakin <alobakin@pm.me>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20210218204908.5455-1-alobakin@pm.me>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <925e70eb-3cc6-a135-decc-22167f2ecaf0@iogearbox.net>
Date:   Thu, 25 Feb 2021 01:46:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210218204908.5455-1-alobakin@pm.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26090/Wed Feb 24 13:09:42 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/21 9:49 PM, Alexander Lobakin wrote:
> This series introduces XSK generic zerocopy xmit by adding XSK umem
> pages as skb frags instead of copying data to linear space.
> The only requirement for this for drivers is to be able to xmit skbs
> with skb_headlen(skb) == 0, i.e. all data including hard headers
> starts from frag 0.
> To indicate whether a particular driver supports this, a new netdev
> priv flag, IFF_TX_SKB_NO_LINEAR, is added (and declared in virtio_net
> as it's already capable of doing it). So consider implementing this
> in your drivers to greatly speed-up generic XSK xmit.
[...]

Applied, thanks!
