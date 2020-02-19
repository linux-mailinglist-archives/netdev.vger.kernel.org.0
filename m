Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519E516445E
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbgBSMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:36:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33469 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgBSMgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 07:36:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id m10so262786wmc.0
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 04:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e1KT/bGjXdS9JX36oYOobEWFP9+9W68S7UedIsUPL3g=;
        b=wvTEMRu62ptTSLne83UAS/8TEW7UxSrhbG1LVY3oBfEBItR+m5QjfxK5dQr9NifGft
         UNKysyLr9HQd77BiQeECDkigzsckGT3nNYCiBxFXpcXhLyugZlqOBC8ApoAh3cEOfVTB
         kidpv/aznZ5R/iCDpFXdI906intbC0yWh0HF81iIMuukY1dKfW/PEhcq7k36M34bmaiq
         p/ap+2SEYw64zC9WeJRef1upliHpDswNNL36BIqKATRqQH0MhM984prn0F7ipUcl6w+S
         mmv1cmtTmcYnnnBcUQA+atbKHlmikIwLFPABmhbA/jUcfB8/hGLDezrE7QFiFD0iCAl2
         M5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e1KT/bGjXdS9JX36oYOobEWFP9+9W68S7UedIsUPL3g=;
        b=hNi+EwF7xb+hFTC3pQFXTlGsTEf9GOKMxI22LswYw+CM5FM7lr7qVs58sX8qgIfcdg
         mDT4Zc14lYmD5H6Du5FZijfumoqVKicfWvmYJ6mZvva5KOPcQL6sOX/KdTBHRmcP+Tlk
         FaBHsdtaRnW8hbfzklbzO9Zr94e4HccQAOSXm5OijTNAVeO4DMl1m85dc6hIicyYIYvD
         kHkiQT/p+3Uv5KURuMtQea3/F28nUc+mEcMD51UxhkfPT39TeabzVcWvWH4sEUbGmM3S
         RYwvSlKFGWJ3JeKhqhVuzjarndTayTpkp2TSYPGF+ilRKIf4/Mdh3jlgOpTyWI4t/PYJ
         4pTg==
X-Gm-Message-State: APjAAAWFfBlPOlUKDofRDkpX+lo05FUrDxlqTKBhSS1jGXSMGbJ4phBp
        bOEP6b3ylx1kvg21klsyiRbJMQ==
X-Google-Smtp-Source: APXvYqxBfJy9323J1kVWL0P8JS4bRHRmT/7haNAKhAZi8RRkU1GfQ+qPOMG+QE0ZIvZfwhzwoEP4Og==
X-Received: by 2002:a7b:c05a:: with SMTP id u26mr5189887wmc.74.1582115794896;
        Wed, 19 Feb 2020 04:36:34 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id c141sm2821179wme.41.2020.02.19.04.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 04:36:34 -0800 (PST)
Date:   Wed, 19 Feb 2020 14:36:31 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 10/13] net: socionext: use new helper
 tcp_v6_gso_csum_prep
Message-ID: <20200219123631.GA651277@apalos.home>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
 <6f02ce1c-aef7-6127-1724-72f7eee56810@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f02ce1c-aef7-6127-1724-72f7eee56810@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 09:09:17PM +0100, Heiner Kallweit wrote:
> Use new helper tcp_v6_gso_csum_prep in additional network drivers.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index e8224b543..6266926fe 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -1148,11 +1148,7 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
>  				~tcp_v4_check(0, ip_hdr(skb)->saddr,
>  					      ip_hdr(skb)->daddr, 0);
>  		} else {
> -			ipv6_hdr(skb)->payload_len = 0;
> -			tcp_hdr(skb)->check =
> -				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
> -						 &ipv6_hdr(skb)->daddr,
> -						 0, IPPROTO_TCP, 0);
> +			tcp_v6_gso_csum_prep(skb);
>  		}
>  
>  		tx_ctrl.tcp_seg_offload_flag = true;
> -- 
> 2.25.1
> 
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
