Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C0816B4BC
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgBXXCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:02:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33394 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbgBXXCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:02:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so6137896pfn.0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 15:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ldA4LWx49G9fDrD0CkVc1pzxiI4d+Sy4jLQFiaVM9xU=;
        b=g8TjKjLKNIBO2D8CGQcYULm47D6iMk0FIVAKiVf84LK8Q6xQY8PDl7MVYsAPvX7KEY
         AzpCL3HKDCrJFzusM4SALGWGqHr0UzdcYjOpJyv8TLlDY/JtUAwL5Dj7Sb+MO74ifL05
         mLLSpzj+3ImqGLUYpVZPX+hzzcVqWCBLcFr0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ldA4LWx49G9fDrD0CkVc1pzxiI4d+Sy4jLQFiaVM9xU=;
        b=KgTP1eUTY9rQ6P4PkT+uGiMk/3vK+ah2WrRIqTjtX3H9c98QPguYvx8lWL/UavL1N/
         zeWkRSsnv1BZZG/M3DtGksQ0Q3i8g3N1XM1EK4ErwYK/SMnybdelT72O8oa/65+5avKx
         JeixluUU+MZfWWHbsXApHVckBmJe+anPArGtuJaW5YciRnhcmawbmhCoJIONGgnwGswp
         TAw4KzlvSaJJwmTSynW4dn0hUJMjIO6NsQJR+YWfwSlqjzKIz81XnoqypMfl/qOQm3wO
         aFWO6GLLNZBrFGu+qCixSg0pDZ+tZ49Fmb/9EschnPRA8sJL+L482SbNySjMJVw9yhwW
         NuEg==
X-Gm-Message-State: APjAAAWMcI21KpIum9Yg8Nq4or3+ToYpIXN/rVfyS2daG4s05gJ6nHeS
        TJIuSIt+ODmUilQYwnn/ILt5jA==
X-Google-Smtp-Source: APXvYqzcx9K3pY/r6VjSAJPclXgYJvtvca4YnsuafbQoX3P7F/kO3KX+wZH5N5OVmthENB1g8vpPWg==
X-Received: by 2002:a65:420b:: with SMTP id c11mr53216300pgq.297.1582585362661;
        Mon, 24 Feb 2020 15:02:42 -0800 (PST)
Received: from google.com ([2620:15c:202:201:476b:691:abc3:38db])
        by smtp.gmail.com with ESMTPSA id 13sm13990169pfi.78.2020.02.24.15.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 15:02:42 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:02:40 -0800
From:   Prashant Malani <pmalani@chromium.org>
To:     You-Sheng Yang <vicamo.yang@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Grant Grundler <grundler@chromium.org>,
        You-Sheng Yang <vicamo@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: r8151: check disconnect status after long sleep
Message-ID: <20200224230240.GA9642@google.com>
References: <20200224071541.117363-1-vicamo.yang@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224071541.117363-1-vicamo.yang@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nit: The commit message title tag should be "r8152", instead of "r8151".

On Mon, Feb 24, 2020 at 03:15:41PM +0800, You-Sheng Yang wrote:
> Dell USB Type C docking WD19/WD19DC attaches additional peripherals as:
> 
>   /: Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
>       |__ Port 1: Dev 11, If 0, Class=Hub, Driver=hub/4p, 5000M
>           |__ Port 3: Dev 12, If 0, Class=Hub, Driver=hub/4p, 5000M
>           |__ Port 4: Dev 13, If 0, Class=Vendor Specific Class,
>               Driver=r8152, 5000M
> 
> where usb 2-1-3 is a hub connecting all USB Type-A/C ports on the dock.
> 
> When hotplugging such dock with additional usb devices already attached on
> it, the probing process may reset usb 2.1 port, therefore r8152 ethernet
> device is also reset. However, during r8152 device init there are several
> for-loops that, when it's unable to retrieve hardware registers due to
> being discconected from USB, may take up to 14 seconds each in practice,
> and that has to be completed before USB may re-enumerate devices on the
> bus. As a result, devices attached to the dock will only be available
> after nearly 1 minute after the dock was plugged in:
> 
>   [ 216.388290] [250] r8152 2-1.4:1.0: usb_probe_interface
>   [ 216.388292] [250] r8152 2-1.4:1.0: usb_probe_interface - got id
>   [ 258.830410] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): PHY not ready
>   [ 258.830460] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Invalid header when reading pass-thru MAC addr
>   [ 258.830464] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Get ether addr fail
> 
> This can be reproduced on all kernel versions up to latest v5.6-rc2, but
> after v5.5-rc7 the reproduce rate is dramatically lower to 1/30 or so
> while it was around 1/2.
> 
> The time consuming for-loops are at:
> https://elixir.bootlin.com/linux/v5.5/source/drivers/net/usb/r8152.c#L3206
> https://elixir.bootlin.com/linux/v5.5/source/drivers/net/usb/r8152.c#L5400
> https://elixir.bootlin.com/linux/v5.5/source/drivers/net/usb/r8152.c#L5537
> 
> Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 78ddbaf6401b..95b19ce96513 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -3221,6 +3221,8 @@ static u16 r8153_phy_status(struct r8152 *tp, u16 desired)
>  		}
>  
>  		msleep(20);
> +		if (test_bit(RTL8152_UNPLUG, &tp->flags))
> +			break;
>  	}
>  
>  	return data;
> @@ -5402,7 +5404,10 @@ static void r8153_init(struct r8152 *tp)
>  		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
>  		    AUTOLOAD_DONE)
>  			break;
> +
>  		msleep(20);
> +		if (test_bit(RTL8152_UNPLUG, &tp->flags))
> +			break;
>  	}
>  
>  	data = r8153_phy_status(tp, 0);
> @@ -5539,7 +5544,10 @@ static void r8153b_init(struct r8152 *tp)
>  		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
>  		    AUTOLOAD_DONE)
>  			break;
> +
>  		msleep(20);
> +		if (test_bit(RTL8152_UNPLUG, &tp->flags))
> +			break;
>  	}
>  
>  	data = r8153_phy_status(tp, 0);
> -- 
> 2.25.0
> 
