Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D221868CF
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgCPKSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:18:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:40846 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730478AbgCPKSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 06:18:53 -0400
IronPort-SDR: cvWWwriEjLIdhNPZZjOiO7QkOeOVNC+dRsR3JZCwrJPu7mrB6uiiXg4ZGQuKPdYInBb7HWFz7W
 UtY8b9DJrDeQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 03:18:51 -0700
IronPort-SDR: DiHKYa6hCdHjDOIQjqIpJbdc96jgMiCLkEHOmFrS8NT7201dXZQIwCUA1I6ZySvJwD34lx4yiB
 uOBsKj5BCh0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,560,1574150400"; 
   d="scan'208";a="354976934"
Received: from shallens-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.41.122])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 03:18:49 -0700
Subject: Re: [PATCH net-next] i40e: trivial fixup of comments in i40e_xsk.c
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
References: <158435379870.2479973.8293720099992666964.stgit@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <384f0f02-ad31-979c-5714-dce3f8f6a27a@intel.com>
Date:   Mon, 16 Mar 2020 11:18:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <158435379870.2479973.8293720099992666964.stgit@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-16 11:16, Jesper Dangaard Brouer wrote:
> The comment above i40e_run_xdp_zc() was clearly copy-pasted from
> function i40e_xsk_umem_setup, which is just above.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks!

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index 0b7d29192b2c..30dfb0d3d185 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -184,8 +184,6 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
>    * @rx_ring: Rx ring
>    * @xdp: xdp_buff used as input to the XDP program
>    *
> - * This function enables or disables a UMEM to a certain ring.
> - *
>    * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
>    **/
>   static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
> @@ -474,7 +472,7 @@ void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
>   }
>   
>   /**
> - * i40e_construct_skb_zc - Create skbufff from zero-copy Rx buffer
> + * i40e_construct_skb_zc - Create skbuff from zero-copy Rx buffer
>    * @rx_ring: Rx ring
>    * @bi: Rx buffer
>    * @xdp: xdp_buff
> 
> 
