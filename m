Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F9D8D682
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfHNOsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:48:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43772 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfHNOsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:48:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id v12so5920248pfn.10;
        Wed, 14 Aug 2019 07:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=S0PKkzS+u3LtwRK0AR6XUJMj1yqa0xdQ2uanteb5fC0=;
        b=sQM4VfFLvn25TVYXiWOtcjotvAhyTEXVeLfR5u3JjOMA2hJ54Q09fdaIrSCoqwh+LA
         07piD3dPQQshVizY5Lon6hvSoABAGnKmiYEIGja0QpGMwN08qZY/i6nPqUTLUDxOGB0S
         GYNZqYuLrPpQKIkDkzQF6EHQRq2TUm9LQzh3n+MmBo3A4H1w8z/yMgmZHdx+k5AXu71W
         dEN9ewXfAUXiBZSu4rACdoWk+PXdVU1B3y8yvPYSrfu+p2PrRwabYkDNp7aPs71JDXG8
         qZjPizmt7qjQxj/6oAmQdDu1p/U6kwQmnYOJd5yh1GrCLH7IGR+ef+nafNiDPdOyB1hw
         55aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=S0PKkzS+u3LtwRK0AR6XUJMj1yqa0xdQ2uanteb5fC0=;
        b=gjQm/gu/Pkelf9pXa2mndd0lWngKmK7KbAcTeZd+D56S2Prg9pmbH/0jYE4Ss2yqYi
         T8XLNsjDuAfTYN4rSrXiT2a/DHnDam+sZprL03cGm8SDNWk8+b3Rp4+DgvtS8WRaF/wE
         ptZJW1h4SJqwtK8p1th/Wqi7g7YIEs9vbPKBiJgJx6Vc6x6PSXBHs1UoEqAYq4GgVKJ+
         t+V20JdeCzebjNzqpG4f1aOlQkIBBX254kjSHtzTCooxrsCKMq51DTCcNYa9LJGFr/+z
         uESo7h2n/Zc1ycMvnLVQ4sttNXPTaQTdJeM22EIKBgPKgUFpqWKDfU9+V57TYqLN02gS
         PJDg==
X-Gm-Message-State: APjAAAXy496Rm7bxWnTfPn+fZIClWpC/81yjlxOIVY4sHrIHZ7z3o+92
        IbUgyJApWSAAvAVpdW/uvq0=
X-Google-Smtp-Source: APXvYqwru1vkZWwlBfz7B/06Y+bnrjh88s8RNYiJ5/2hO9wsYeiA2OtcSsBxgwgVwGCzTrUoKgi32Q==
X-Received: by 2002:a63:6ec1:: with SMTP id j184mr18477470pgc.232.1565794110139;
        Wed, 14 Aug 2019 07:48:30 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id 124sm5861pfw.142.2019.08.14.07.48.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 07:48:29 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, brouer@redhat.com, maximmi@mellanox.com,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 3/8] i40e: add support for AF_XDP need_wakeup
 feature
Date:   Wed, 14 Aug 2019 07:48:28 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <3B2C7C21-4AAC-4126-A31D-58A61D941709@gmail.com>
In-Reply-To: <1565767643-4908-4-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-4-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> This patch adds support for the need_wakeup feature of AF_XDP. If the
> application has told the kernel that it might sleep using the new bind
> flag XDP_USE_NEED_WAKEUP, the driver will then set this flag if it has
> no more buffers on the NIC Rx ring and yield to the application. For
> Tx, it will set the flag if it has no outstanding Tx completion
> interrupts and return to the application.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c 
> b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index d0ff5d8..42c9012 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -626,6 +626,15 @@ int i40e_clean_rx_irq_zc(struct i40e_ring 
> *rx_ring, int budget)
>
>  	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
>  	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
> +
> +	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
> +		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
> +			xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
> +		else
> +			xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
> +
> +		return (int)total_rx_packets;
> +	}
>  	return failure ? budget : (int)total_rx_packets;

Can you elaborate why we're not returning the total budget on failure
for the wakeup case?

