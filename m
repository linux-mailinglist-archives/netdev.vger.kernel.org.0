Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867C357292
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFZU0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:26:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:33222 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZU0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:26:43 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgEV3-0007jc-2z; Wed, 26 Jun 2019 22:26:37 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgEV2-00039f-Sc; Wed, 26 Jun 2019 22:26:36 +0200
Subject: Re: [PATCH bpf-next V6 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     Tariq Toukan <tariqt@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <577bb8f5-aa67-f0e2-0f5e-fdc72b18fd7e@iogearbox.net>
Date:   Wed, 26 Jun 2019 22:26:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/26/2019 04:35 PM, Tariq Toukan wrote:
[...]
> v6 changes:
> 
> As Maxim is out of office, I rebased the series on behalf of him,
> solved some conflicts, and re-spinned.

Thanks for taking over the rebase, Tariq!

> Series generated against bpf-next commit:
> 572a6928f9e3 xdp: Make __mem_id_disconnect static
> 
> 
> Maxim Mikityanskiy (16):
>   net/mlx5e: Attach/detach XDP program safely
>   xsk: Add API to check for available entries in FQ
>   xsk: Add getsockopt XDP_OPTIONS
>   libbpf: Support getsockopt XDP_OPTIONS
>   xsk: Change the default frame size to 4096 and allow controlling it
>   xsk: Return the whole xdp_desc from xsk_umem_consume_tx
>   net/mlx5e: Replace deprecated PCI_DMA_TODEVICE
>   net/mlx5e: Calculate linear RX frag size considering XSK
>   net/mlx5e: Allow ICO SQ to be used by multiple RQs
>   net/mlx5e: Refactor struct mlx5e_xdp_info
>   net/mlx5e: Share the XDP SQ for XDP_TX between RQs
>   net/mlx5e: XDP_TX from UMEM support
>   net/mlx5e: Consider XSK in XDP MTU limit calculation
>   net/mlx5e: Encapsulate open/close queues into a function
>   net/mlx5e: Move queue param structs to en/params.h
>   net/mlx5e: Add XSK zero-copy support

Series applied, thanks!
