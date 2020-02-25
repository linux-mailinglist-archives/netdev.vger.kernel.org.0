Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90F616F258
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgBYV7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:59:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:54314 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgBYV7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:59:15 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6iEO-0003fq-6M; Tue, 25 Feb 2020 22:59:08 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6iEN-000Noq-ND; Tue, 25 Feb 2020 22:59:07 +0100
Subject: Re: [PATCH bpf-next v6 0/2] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>, jasowang@redhat.com
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, songliubraving@fb.com,
        yhs@fb.com
References: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4ae12070-b6ed-af69-52ec-995d59242a42@iogearbox.net>
Date:   Tue, 25 Feb 2020 22:59:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 4:31 AM, Yuya Kusakabe wrote:
> This patch series has 2 patches.
> 
> Patch 1/2: keep vnet header zeroed if XDP is loaded for small buffer
> With this fix, we do not need to care about vnet header in XDP meta data
> support for small buffer, even though XDP meta data uses in front of
> packet as same as vnet header.
> It would be best if this patch goes into stable.
> This patch is based on the feedback by Jason Wang and Michael S. Tsirkin.
> https://lore.kernel.org/netdev/9a0a1469-c8a7-8223-a4d5-dad656a142fc@redhat.com/
> https://lore.kernel.org/netdev/20200223031314-mutt-send-email-mst@kernel.org/
> 
> Patch 2/2: add XDP meta data support
> 
> Thanks to Jason Wang, Daniel Borkmann and Michael S. Tsirkin for the feedback.
> 
> Yuya Kusakabe (2):
>    virtio_net: keep vnet header zeroed if XDP is loaded for small buffer
>    virtio_net: add XDP meta data support
> 
>   drivers/net/virtio_net.c | 56 ++++++++++++++++++++++++----------------
>   1 file changed, 34 insertions(+), 22 deletions(-)
> 

Applied, thanks!
