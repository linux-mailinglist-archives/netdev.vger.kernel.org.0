Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8B289EFA
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 09:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgJJHfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 03:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728994AbgJJHfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 03:35:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE93CC0613CF;
        Sat, 10 Oct 2020 00:35:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n14so8835811pff.6;
        Sat, 10 Oct 2020 00:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hnd/mv3jxhuZxVrX3GYV8Ajw+ecT5R2LNKIYlv6d3No=;
        b=Dm4fMwFjM1xohWdCX4FurJA/KOw5/SuFGNgpKPzBdyRfXJpJlGfpnwZhy6iqgrD1fx
         g/jx8YKenfi9lOna0Yu5mwakuQV4hyNPMT7msClic/2WWqyHohb9i6fW/5Cj8McGl7Bs
         mb8uPdr1BORea/nXWCibt4FxRP+KiGyCCa00GLILU+Ik0vab9vSy31AcqEu7pDH13v3L
         mKD18kmD88f5SNrBNRnW8D18beG3vCQYtOm50uwkM2pfCRC7f+roxS2cOUyW/a3WxD7o
         X8tLMJ1Qx1QHM2tQkapjK9WY1FGI7JqCypGahodiJhipMKrCeyN52WR7yNybK96dpik+
         CLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hnd/mv3jxhuZxVrX3GYV8Ajw+ecT5R2LNKIYlv6d3No=;
        b=jK6bko50a1qtldEmDiMrsi6a11kSiOo/ooB8k3a7v84GX1zefweNI9/rEhYjE4j8vU
         /v1ZcELiTgsvbpbEdNkyjEfYwEysUwqlyBiT3qq357gSMvANk62XDGnjMCWB21IHqpVG
         zk4iPv3sD3P6tVZKi+X/FUWvCDeOsPWq2vPW9h+iPirTXvQjneqHwydUDH3j01Ee8uTX
         WRNbms3JDn7E8zmyVBX+VUIF6xleEdo7qfnI0UP6NI49ll2a413Z7eqV1jMMSiQzkZMG
         RQt/JlmEBFbQUwrcyIaGIzxFhBQjzUiWc1Tm5Rh/aTUv4RSDgNBcM4SVagxGZn/WE57/
         0HdA==
X-Gm-Message-State: AOAM530Nt6B917ZLXboOq6I76GeBFVj+nTqox2RDGmhd2pm8BEwKlv/4
        qRB+J1DVWtmImytIylxm63g=
X-Google-Smtp-Source: ABdhPJxjM2qpy65yr3E7+lkJ1YIR5h1bfDPisi1MZLUONiuPbVdLIo3T1Al2+1wrdzdnSsXXoZ4cgA==
X-Received: by 2002:a17:90a:3fcb:: with SMTP id u11mr8666256pjm.128.1602315320134;
        Sat, 10 Oct 2020 00:35:20 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id c21sm13507834pfo.139.2020.10.10.00.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 00:35:19 -0700 (PDT)
Date:   Sat, 10 Oct 2020 16:35:14 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201010073514.GA14495@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008115808.91850-2-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-08 19:58 +0800, Coiby Xu wrote:
> Initialize devlink health dump framework for the dlge driver so the
> coredump could be done via devlink.
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/Kconfig        |  1 +
>  drivers/staging/qlge/Makefile       |  2 +-
>  drivers/staging/qlge/qlge.h         |  9 +++++++
>  drivers/staging/qlge/qlge_devlink.c | 38 +++++++++++++++++++++++++++++
>  drivers/staging/qlge/qlge_devlink.h |  8 ++++++
>  drivers/staging/qlge/qlge_main.c    | 28 +++++++++++++++++++++
>  6 files changed, 85 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/staging/qlge/qlge_devlink.c
>  create mode 100644 drivers/staging/qlge/qlge_devlink.h
> 
> diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
> index a3cb25a3ab80..6d831ed67965 100644
> --- a/drivers/staging/qlge/Kconfig
> +++ b/drivers/staging/qlge/Kconfig
> @@ -3,6 +3,7 @@
>  config QLGE
>  	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
>  	depends on ETHERNET && PCI
> +	select NET_DEVLINK
>  	help
>  	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
>  
> diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
> index 1dc2568e820c..07c1898a512e 100644
> --- a/drivers/staging/qlge/Makefile
> +++ b/drivers/staging/qlge/Makefile
> @@ -5,4 +5,4 @@
>  
>  obj-$(CONFIG_QLGE) += qlge.o
>  
> -qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
> +qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index b295990e361b..290e754450c5 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2060,6 +2060,14 @@ struct nic_operations {
>  	int (*port_initialize)(struct ql_adapter *qdev);
>  };
>  
> +
> +
> +struct qlge_devlink {
> +        struct ql_adapter *qdev;
> +        struct net_device *ndev;

This member should be removed, it is unused throughout the rest of the
series. Indeed, it's simple to use qdev->ndev and that's what
qlge_reporter_coredump() does.
