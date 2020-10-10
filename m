Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAE9289F03
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 09:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgJJHsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 03:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgJJHsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 03:48:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB118C0613CF;
        Sat, 10 Oct 2020 00:48:15 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so9163983pgb.10;
        Sat, 10 Oct 2020 00:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0N5myq9RqbCXporbQ6mi5leNzojgy9tudrwbZBPAQqQ=;
        b=nxDrpRp7v+4Cx8Tp0tsimpv42CN7uXj4TrBK9LOySij4k21J8K0AXWaYxN9S7u6uN+
         GKyxg1MkPHuV0ksqc2GEMLLJEEK4GVqgUw0hIl9bAFqZJc8qr7+rJ70yq/SecC1x6KJr
         JiqwTh3ziDM44op3QnrUXOzmBorXVNHMIOyNZDl+33i1UwthsJCeLXi3ZBVIeXATFiEO
         9WuUir64l+g/A2nTyeS94pwcYZocj7NMnKvEPVm0PUyf3MmLSsLrUZtx5lwMhKH4QHz3
         EEb2d5UhL9HpuPMyVit279EWOzOGTAxrSkEnUSJcu+A7iLEhV04C5+NHoWG01w3XZFVU
         7vxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0N5myq9RqbCXporbQ6mi5leNzojgy9tudrwbZBPAQqQ=;
        b=qyBzxFVihm+w7vR8LJxJbDAJ7EYqLvdkArBUtVSS7dkR/h8Xdm7mkauJL86qCRIGzY
         Elwzds5aeQdWvmAG0TEBjoCgww0e+qSjYb1SBx6wvSS2low7TOrdr2IenH3EBgv7jUR4
         fH42k+SA3hIhgOqPT42E+1MACD12p3KIAaNK4MXnXtp5HthaySShBXNEVgigSLG7Eb3E
         2CMQt4e28ctgakldqqmtTZbKADLJmztiqmbeGM80hGk0tmVATNHAhssR3qUjK+yrYt2I
         orKh1PiKQxKyHviDFNnfmlgYiXl0dpl3dBtAewObXHjp/YGSqlPWG3AebQ9OAPWeAjWt
         KgJQ==
X-Gm-Message-State: AOAM5311E8opQv6FgsL/7HxEkaCyal6NcpkbF7fM/2na25skZzBpJdXa
        qiH4bCpxllevK832el+Ul6d3kj3tQ9c6HA==
X-Google-Smtp-Source: ABdhPJzyfUtr5p1jo+SHlF3ESI2QcIH6+wPCeEp3xe1mBnkkIA4mdn87cBSRaDYJ0AGnKjTqgut3Bw==
X-Received: by 2002:aa7:8b03:0:b029:152:a364:5084 with SMTP id f3-20020aa78b030000b0290152a3645084mr15040090pfd.29.1602316095367;
        Sat, 10 Oct 2020 00:48:15 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id x18sm13531125pfj.90.2020.10.10.00.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 00:48:14 -0700 (PDT)
Date:   Sat, 10 Oct 2020 16:48:09 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/6] staging: qlge: coredump via devlink health
 reporter
Message-ID: <20201010074809.GB14495@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-3-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008115808.91850-3-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-08 19:58 +0800, Coiby Xu wrote:
>     $ devlink health dump show DEVICE reporter coredump -p -j
>     {
>         "Core Registers": {
>             "segment": 1,
>             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
> ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>         },
>         "Test Logic Regs": {
>             "segment": 2,
>             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>         },
>         "RMII Registers": {
>             "segment": 3,
>             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>         },
>         ...
>         "Sem Registers": {
>             "segment": 50,
>             "values": [ 0,0,0,0 ]
>         }
>     }
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/qlge_devlink.c | 131 ++++++++++++++++++++++++++--
>  1 file changed, 125 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
> index aa45e7e368c0..91b6600b94a9 100644
> --- a/drivers/staging/qlge/qlge_devlink.c
> +++ b/drivers/staging/qlge/qlge_devlink.c
> @@ -1,16 +1,135 @@
>  #include "qlge.h"
>  #include "qlge_devlink.h"
>  
> -static int
> -qlge_reporter_coredump(struct devlink_health_reporter *reporter,
> -			struct devlink_fmsg *fmsg, void *priv_ctx,
> -			struct netlink_ext_ack *extack)
> +static int fill_seg_(struct devlink_fmsg *fmsg,

Please include the "qlge_" prefix.

> +		    struct mpi_coredump_segment_header *seg_header,
> +		    u32 *reg_data)
>  {
> -	return 0;
> +	int i;
> +	int header_size = sizeof(struct mpi_coredump_segment_header);
> +	int regs_num = (seg_header->seg_size - header_size) / sizeof(u32);
> +	int err;
> +
> +	err = devlink_fmsg_pair_nest_start(fmsg, seg_header->description);
> +	if (err)
> +		return err;
> +	err = devlink_fmsg_obj_nest_start(fmsg);
> +	if (err)
> +		return err;
> +	err = devlink_fmsg_u32_pair_put(fmsg, "segment", seg_header->seg_num);
> +	if (err)
> +		return err;
> +	err = devlink_fmsg_arr_pair_nest_start(fmsg, "values");
> +	if (err)
> +		return err;
> +	for (i = 0; i < regs_num; i++) {
> +		err = devlink_fmsg_u32_put(fmsg, *reg_data);
> +		if (err)
> +			return err;
> +		reg_data++;
> +	}
> +	err = devlink_fmsg_obj_nest_end(fmsg);
> +	if (err)
> +		return err;
> +	err = devlink_fmsg_arr_pair_nest_end(fmsg);
> +	if (err)
> +		return err;
> +	err = devlink_fmsg_pair_nest_end(fmsg);
> +	return err;
> +}
> +
> +#define fill_seg(seg_hdr, seg_regs)			               \

considering that this macro accesses local variables, it is not really
"function-like". I think an all-caps name would be better to tip-off the
reader.

> +	do {                                                           \
> +		err = fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
> +		if (err) {					       \
> +			kvfree(dump);                                  \
> +			return err;				       \
> +		}                                                      \
> +	} while (0)
> +
> +static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
> +				  struct netlink_ext_ack *extack)
> +{
> +	int err = 0;
> +
> +	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);

Please name this variable ql_devlink, like in qlge_probe().
