Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0987146153
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 06:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAWFTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 00:19:38 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40825 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgAWFTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 00:19:37 -0500
Received: by mail-pf1-f194.google.com with SMTP id q8so965061pfh.7;
        Wed, 22 Jan 2020 21:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5KoYChdrAVEnywaOk6umNrkcUxLVAh4soDP+1zybkIw=;
        b=MAMt+hkx8kzQYK1bOTg3zO+yF9aTna1Dcsqc0k92EN2yS8jbzTX3mSI7l+3pFrszLI
         GnpGabhLZLfTd0xzKwhk6ZYNsO6mysVSQP4UOXRBLv/TK0tpRmmp6T6XzTWonWB2dW/w
         y1C26tyLD1TTaCQQhJU4pE6dx1dPUwdjtBGQSBWPP1SOZWw7cYZ1XA4b7t88mxT2RsLi
         QQbVDDlOHzCNZ5PtACMXX5CSlvFWPFjf2Myrj1fb8C73TXFawcsLB9qlPJiF0ukc4Cef
         AlROAkT9dC+3mcjD2luCZwAGM2ZBly/dYZuLH4XRbEVpCrfFtic+2Px+kRQDdYo7gMEG
         UoVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5KoYChdrAVEnywaOk6umNrkcUxLVAh4soDP+1zybkIw=;
        b=M3QWPsQKg79c6SDQ1atYyAU0GMsoaREzbE1KG4mPTppVobY9qMagmT/OMHBtfXR/E8
         hMtQ5LmCZ4GvrVVvueZe+seX9TjcnikmN4CHdjuXwukd60QzZvoipwKVBuhrZa/hLzdz
         RfJZYeQa4sfy3J9GN8TKES0Q3gDqgFZ4VTjg4WtEXhyqi+gatlKipgwQzDAxsE7zzQLT
         1R7KEMrypgIUuSYqlh8qa6AltMIHjWuDZrrVlzTTON7ozR2hBeOrsHiYtQWwHEtrv6g1
         oGlDCl8E5nz3RcsVIS/9pKX63jOsVVJ+0s+ITUFmsJAU5Lg6Xt0TAscMtIKJhxP88CgQ
         ddPg==
X-Gm-Message-State: APjAAAX+oVtDfWkwMs3SGUqmpcG5C+/g5cq0hvrINl+60gG88HUgE9D7
        JEoWgP52wBOZvqSVM4cb3ieE13FJ
X-Google-Smtp-Source: APXvYqx0UXNrAGRj0IpnERWcVQq9uWc0hjJ6AOHNdPe6nyGIjSs+HDemstFt0YMAjdcjSkqYMdC48Q==
X-Received: by 2002:a63:ba45:: with SMTP id l5mr2044688pgu.380.1579756777148;
        Wed, 22 Jan 2020 21:19:37 -0800 (PST)
Received: from f3 (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id e16sm817911pgk.77.2020.01.22.21.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 21:19:36 -0800 (PST)
Date:   Thu, 23 Jan 2020 14:19:31 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: fix spelling mistake "to" -> "too"
Message-ID: <20200123051931.GA419949@f3>
References: <20200123000707.2831321-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123000707.2831321-1-colin.king@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/01/23 00:07 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a netif_printk message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index ef8037d0b52e..115dfa2ffabd 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -1758,7 +1758,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
>  	} else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL) {
>  		if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS) {
>  			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
> -				     "Header in small, %d bytes in large. Chain large to small!\n",
> +				     "Header in small, %d bytes in large. Chain large too small!\n",

The "to" is correct here.
~chaining a large buffer to a small buffer~
