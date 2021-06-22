Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545CC3B0D73
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhFVTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:10:11 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:48239 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFVTKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:10:11 -0400
Received: (Authenticated sender: i.maximets@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id C16ED200002;
        Tue, 22 Jun 2021 19:07:51 +0000 (UTC)
Subject: Re: [PATCH] docs: af_xdp: consistent indentation in examples
To:     Ilya Maximets <i.maximets@ovn.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210622185647.3705104-1-i.maximets@ovn.org>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <b871fd9c-897c-26ca-f4fd-7d81b3489379@ovn.org>
Date:   Tue, 22 Jun 2021 21:07:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210622185647.3705104-1-i.maximets@ovn.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 8:56 PM, Ilya Maximets wrote:
> Examples in this document use all kinds of indentation from 3 to 5
> spaces and even mixed with tabs.  Making them all even and equal to
> 4 spaces.
> 
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---

Ugh.  Sorry, meant to send for bpf-next, but lost the subject prefix
somewhere...  Can re-send if needed.

>  Documentation/networking/af_xdp.rst | 32 ++++++++++++++---------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
> index 2ccc5644cc98..42576880aa4a 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
> @@ -290,19 +290,19 @@ round-robin example of distributing packets is shown below:
>     #define MAX_SOCKS 16
>  
>     struct {
> -        __uint(type, BPF_MAP_TYPE_XSKMAP);
> -        __uint(max_entries, MAX_SOCKS);
> -        __uint(key_size, sizeof(int));
> -        __uint(value_size, sizeof(int));
> +       __uint(type, BPF_MAP_TYPE_XSKMAP);
> +       __uint(max_entries, MAX_SOCKS);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
>     } xsks_map SEC(".maps");
>  
>     static unsigned int rr;
>  
>     SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>     {
> -	rr = (rr + 1) & (MAX_SOCKS - 1);
> +       rr = (rr + 1) & (MAX_SOCKS - 1);
>  
> -	return bpf_redirect_map(&xsks_map, rr, XDP_DROP);
> +       return bpf_redirect_map(&xsks_map, rr, XDP_DROP);
>     }
>  
>  Note, that since there is only a single set of FILL and COMPLETION
> @@ -379,7 +379,7 @@ would look like this for the TX path:
>  .. code-block:: c
>  
>     if (xsk_ring_prod__needs_wakeup(&my_tx_ring))
> -      sendto(xsk_socket__fd(xsk_handle), NULL, 0, MSG_DONTWAIT, NULL, 0);
> +       sendto(xsk_socket__fd(xsk_handle), NULL, 0, MSG_DONTWAIT, NULL, 0);
>  
>  I.e., only use the syscall if the flag is set.
>  
> @@ -442,9 +442,9 @@ purposes. The supported statistics are shown below:
>  .. code-block:: c
>  
>     struct xdp_statistics {
> -	  __u64 rx_dropped; /* Dropped for reasons other than invalid desc */
> -	  __u64 rx_invalid_descs; /* Dropped due to invalid descriptor */
> -	  __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
> +       __u64 rx_dropped; /* Dropped for reasons other than invalid desc */
> +       __u64 rx_invalid_descs; /* Dropped due to invalid descriptor */
> +       __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
>     };
>  
>  XDP_OPTIONS getsockopt
> @@ -483,15 +483,15 @@ like this:
>  .. code-block:: c
>  
>      // struct xdp_rxtx_ring {
> -    // 	__u32 *producer;
> -    // 	__u32 *consumer;
> -    // 	struct xdp_desc *desc;
> +    //     __u32 *producer;
> +    //     __u32 *consumer;
> +    //     struct xdp_desc *desc;
>      // };
>  
>      // struct xdp_umem_ring {
> -    // 	__u32 *producer;
> -    // 	__u32 *consumer;
> -    // 	__u64 *desc;
> +    //     __u32 *producer;
> +    //     __u32 *consumer;
> +    //     __u64 *desc;
>      // };
>  
>      // typedef struct xdp_rxtx_ring RING;
> 

