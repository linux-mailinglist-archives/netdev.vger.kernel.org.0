Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B4BE9B80
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 13:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfJ3M1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 08:27:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33271 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfJ3M1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 08:27:05 -0400
Received: by mail-wm1-f68.google.com with SMTP id 6so4193433wmf.0
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 05:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XVKpGoUhirqwJE5BNip9AuEsjjkqPLjlUkZwutxFNvk=;
        b=AzLTn0DjJZlWH2FxEaXNPJxk9GH3nMvP/VvWXnUZ5xuRCsSjokGfK+dF2OkDbRsZ4V
         xkqhril9yLMDM89vhEluvgodsCzgWgvwKxwwpKJZLdXn+dK2F9k2U+r93olfyc7+oyAQ
         uIGlhyGTx1RImTswkpnTjLkIIone5y6eEAhlq1D0KoL93pzUCSY2V+VVTBVdqkd8tZ5P
         9o+RoNp5ffyIUFDqmtLeaIDFp4euqtI5czO4/8Y1uRB+mv6Mh6FyfQoLrCo61NV3R7iW
         V11ZJ5I0DxK9jH1r5vvn5I+jyYCdtGoL5G2ZugWk6xZACy4B5cYdvr2yc6ReBJ7AzTOD
         k6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XVKpGoUhirqwJE5BNip9AuEsjjkqPLjlUkZwutxFNvk=;
        b=MTqTCRpXBl8T+0rnFEq1dLbvy52uQbaPG9O0IBC+rjLcNSx9S/JVrvMQVXmOM79OOw
         wAcMK2KiMtN5X74oKgXWQx7uT+kxlheQHjz4moq66hxs7gy1Esbs1q6a+WbaLGPTPbmZ
         2JwD492Uz2jBlOVRAuz17gRvS/mby7JiMWi/nIQhGlRm8GhuFzgZg1IhUTwwv3u/Ewpo
         hO6oAC8eG4wHFSVpPAJFxFyzbCHVVfsusYF0HldEhXXXw3ZO4UCLqdrvVBegId+mHi39
         mUdVMblDtDo+ooakgPBvGk/NE5Ou2taUB8Gwgf8/qOcVJ+TRdXu0wseUp90ROkFQNUZC
         LskA==
X-Gm-Message-State: APjAAAUGtHZXQRYYumP+z3v67WxkDAu6K1vdz1rL0xysqgboXdvQqa44
        4Y8dJ/0DQ90PTK7hPtPCkZ6mcA==
X-Google-Smtp-Source: APXvYqzkGUr0Mx6P0pMJsEbVboXoMhHx8b/mm2CQC73mt2NxuLweNlLVP5FfJjSDyR1BPn1otqEm5g==
X-Received: by 2002:a1c:2344:: with SMTP id j65mr9245128wmj.38.1572438422957;
        Wed, 30 Oct 2019 05:27:02 -0700 (PDT)
Received: from netronome.com ([217.149.135.181])
        by smtp.gmail.com with ESMTPSA id z9sm105972wrv.1.2019.10.30.05.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 05:27:02 -0700 (PDT)
Date:   Wed, 30 Oct 2019 13:27:01 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH net-next] vxlan: drop "vxlan" parameter in
 vxlan_fdb_alloc()
Message-ID: <20191030122659.GA23163@netronome.com>
References: <909fa55ac93fa8727ee1d9ec273011056ad7d61f.1572382598.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <909fa55ac93fa8727ee1d9ec273011056ad7d61f.1572382598.git.gnault@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 09:57:10PM +0100, Guillaume Nault wrote:
> This parameter has never been used.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  drivers/net/vxlan.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 3d9bcc957f7d..5ffea8e34771 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -793,8 +793,7 @@ static int vxlan_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
>  	return eth_gro_complete(skb, nhoff + sizeof(struct vxlanhdr));
>  }
>  
> -static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan,
> -					 const u8 *mac, __u16 state,
> +static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
>  					 __be32 src_vni, __u16 ndm_flags)
>  {
>  	struct vxlan_fdb *f;
> @@ -835,7 +834,7 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
>  		return -ENOSPC;
>  
>  	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
> -	f = vxlan_fdb_alloc(vxlan, mac, state, src_vni, ndm_flags);
> +	f = vxlan_fdb_alloc(mac, state, src_vni, ndm_flags);
>  	if (!f)
>  		return -ENOMEM;
>  
> -- 
> 2.21.0
> 
