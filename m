Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF2432698
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhJRSlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhJRSlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:41:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006C7C06161C;
        Mon, 18 Oct 2021 11:38:59 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id j190so10331324pgd.0;
        Mon, 18 Oct 2021 11:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:cc:subject:from:to:date
         :message-id:in-reply-to;
        bh=2vZED9KAnb9s7JMAzl/WHynHk3EQsjC695KsbqSi6hI=;
        b=HzM1xJRu1RbzyMrNf7CGGefgRkApIDdWDgvYrX7qRxrM0eqTEmf/XXAo4nhT6Rl/4B
         nWxwS4Bbv8qhRAibfGTT9hrK8ZQVdgDVYxYjKF/JXEX7EVqyxC7NIzhVhkqKV7CoYgA3
         7vlinQWunhcAAfSfuhWCl46wS74Kc5BXUcpDxxY/x7ZxT0Hm3ERkDHm8oYmeix8lvfIR
         PsZsl3FS+Y8CQjheWextTVASfY0zQpkFoXg/1g5pYBlq3b+Xipiq6lxBF+AzX6jB1kpd
         gfpVVtCp3/fXHAu212A90Isc5xCu5O54ewR1O5ax50fuf+tqnRYhbM0YbzFqhR6Fjk8l
         68aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:cc
         :subject:from:to:date:message-id:in-reply-to;
        bh=2vZED9KAnb9s7JMAzl/WHynHk3EQsjC695KsbqSi6hI=;
        b=PslXo4ZZrXs7zs6mGxq5ipfyvBK12NYpnT0mnW8n9hckCFbM7OY0esLwhMNcKcDN/P
         ctzAJP4wNia3f02uJlbuuiuH5avSSdCRU/eVttI4GMKPPMayZ5A9jN+4tAmkG4Us9aUk
         B+XZBZtJHnUNhu9V55P7hOv+vHBpg/fBdaCLYCvrHBXARRtDquLSIcrvuBTCdbT3QUIr
         3aWyDfQ7LSgPW02vm8DZECv05T26S83Im298OICJoTSKkBtEujzhXdw26QCso4L5iz9d
         iPbrpr6iTeIj0dlRjUHSiA445wwzE22T9a3usrQaB1GLhOI5LP3rmfMyyE0Wa58yi4p3
         7HCA==
X-Gm-Message-State: AOAM532Lm/jdbu/yWvb4OjUtzJq9UCz9gHFnMh5z/cUKSjFNfyRTo8z3
        WQ3Cbdt/15eIpvJALanlL80=
X-Google-Smtp-Source: ABdhPJzxBDBATYXKbVHN3D/LrrHokiQWCKRQxQIf1czLrYWSy9i2QQJwfPGlptkBc5dvVjWp3pJY2A==
X-Received: by 2002:aa7:8b1a:0:b0:44d:37c7:dbb6 with SMTP id f26-20020aa78b1a000000b0044d37c7dbb6mr30569881pfd.11.1634582339376;
        Mon, 18 Oct 2021 11:38:59 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id 60sm150975pjz.11.2021.10.18.11.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:38:59 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 16/17] net: ipa: Add hw config describing IPA v2.x
 hardware
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Date:   Tue, 19 Oct 2021 00:05:59 +0530
Message-Id: <CF2R0LFXXG5E.FVHJJ5F1GS2R@skynet-linux>
In-Reply-To: <8a873721-9b2b-4137-ff86-729a2d6fdc63@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 4:00 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > This commit adds the config for IPA v2.0, v2.5, v2.6L. IPA v2.5 is foun=
d
> > on msm8996. IPA v2.6L hardware is found on following SoCs: msm8920,
> > msm8940, msm8952, msm8953, msm8956, msm8976, sdm630, sdm660. No
> > SoC-specific configuration in ipa driver is required.
> >=20
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
>
> I will not look at this in great detail right now. It looks
> good to me, but I didn't notice where "channel_name" got
> defined. I'm not sure what the BCR value represents either.
>

I probably messed up while splitting the commits, it should be easy
enough to fix. As for the BCR, it was simple `#define`d in
downstream, with no comments, leaving us clueless as to what the magic
number means :(

Regards,
Sireesh
> -Alex
>
> > ---
> >   drivers/net/ipa/Makefile        |   7 +-
> >   drivers/net/ipa/ipa_data-v2.c   | 369 +++++++++++++++++++++++++++++++=
+
> >   drivers/net/ipa/ipa_data-v3.1.c |   2 +-
> >   drivers/net/ipa/ipa_data.h      |   3 +
> >   drivers/net/ipa/ipa_main.c      |  15 ++
> >   drivers/net/ipa/ipa_sysfs.c     |   6 +
> >   6 files changed, 398 insertions(+), 4 deletions(-)
> >   create mode 100644 drivers/net/ipa/ipa_data-v2.c
> >=20
> > diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
> > index 4abebc667f77..858fbf76cff3 100644
> > --- a/drivers/net/ipa/Makefile
> > +++ b/drivers/net/ipa/Makefile
> > @@ -7,6 +7,7 @@ ipa-y			:=3D	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o=
 \
> >   				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
> >   				ipa_sysfs.o
> >  =20
> > -ipa-y			+=3D	ipa_data-v3.1.o ipa_data-v3.5.1.o \
> > -				ipa_data-v4.2.o ipa_data-v4.5.o \
> > -				ipa_data-v4.9.o ipa_data-v4.11.o
> > +ipa-y			+=3D	ipa_data-v2.o ipa_data-v3.1.o \
> > +				ipa_data-v3.5.1.o ipa_data-v4.2.o \
> > +				ipa_data-v4.5.o ipa_data-v4.9.o \
> > +				ipa_data-v4.11.o
> > diff --git a/drivers/net/ipa/ipa_data-v2.c b/drivers/net/ipa/ipa_data-v=
2.c
> > new file mode 100644
> > index 000000000000..869b8a1a45d6
> > --- /dev/null
> > +++ b/drivers/net/ipa/ipa_data-v2.c
> > @@ -0,0 +1,369 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
> > + * Copyright (C) 2019-2020 Linaro Ltd.
> > + */
> > +
> > +#include <linux/log2.h>
> > +
> > +#include "ipa_data.h"
> > +#include "ipa_endpoint.h"
> > +#include "ipa_mem.h"
> > +
> > +/* Endpoint configuration for the IPA v2 hardware. */
> > +static const struct ipa_gsi_endpoint_data ipa_endpoint_data[] =3D {
> > +	[IPA_ENDPOINT_AP_COMMAND_TX] =3D {
> > +		.ee_id		=3D GSI_EE_AP,
> > +		.channel_id	=3D 3,
> > +		.endpoint_id	=3D 3,
> > +		.channel_name	=3D "cmd_tx",
> > +		.toward_ipa	=3D true,
> > +		.channel =3D {
> > +			.tre_count	=3D 256,
> > +			.event_count	=3D 256,
> > +			.tlv_count	=3D 20,
> > +		},
> > +		.endpoint =3D {
> > +			.config	=3D {
> > +				.dma_mode	=3D true,
> > +				.dma_endpoint	=3D IPA_ENDPOINT_AP_LAN_RX,
> > +			},
> > +		},
> > +	},
> > +	[IPA_ENDPOINT_AP_LAN_RX] =3D {
> > +		.ee_id		=3D GSI_EE_AP,
> > +		.channel_id	=3D 2,
> > +		.endpoint_id	=3D 2,
> > +		.channel_name	=3D "ap_lan_rx",
> > +		.channel =3D {
> > +			.tre_count	=3D 256,
> > +			.event_count	=3D 256,
> > +			.tlv_count	=3D 8,
> > +		},
> > +		.endpoint	=3D {
> > +			.config	=3D {
> > +				.aggregation	=3D true,
> > +				.status_enable	=3D true,
> > +				.rx =3D {
> > +					.pad_align	=3D ilog2(sizeof(u32)),
> > +				},
> > +			},
> > +		},
> > +	},
> > +	[IPA_ENDPOINT_AP_MODEM_TX] =3D {
> > +		.ee_id		=3D GSI_EE_AP,
> > +		.channel_id	=3D 4,
> > +		.endpoint_id	=3D 4,
> > +		.channel_name	=3D "ap_modem_tx",
> > +		.toward_ipa	=3D true,
> > +		.channel =3D {
> > +			.tre_count	=3D 256,
> > +			.event_count	=3D 256,
> > +			.tlv_count	=3D 8,
> > +		},
> > +		.endpoint	=3D {
> > +			.config	=3D {
> > +				.qmap		=3D true,
> > +				.status_enable	=3D true,
> > +				.tx =3D {
> > +					.status_endpoint =3D
> > +						IPA_ENDPOINT_AP_LAN_RX,
> > +				},
> > +			},
> > +		},
> > +	},
> > +	[IPA_ENDPOINT_AP_MODEM_RX] =3D {
> > +		.ee_id		=3D GSI_EE_AP,
> > +		.channel_id	=3D 5,
> > +		.endpoint_id	=3D 5,
> > +		.channel_name	=3D "ap_modem_rx",
> > +		.toward_ipa	=3D false,
> > +		.channel =3D {
> > +			.tre_count	=3D 256,
> > +			.event_count	=3D 256,
> > +			.tlv_count	=3D 8,
> > +		},
> > +		.endpoint	=3D {
> > +			.config =3D {
> > +				.aggregation	=3D true,
> > +				.qmap		=3D true,
> > +			},
> > +		},
> > +	},
> > +	[IPA_ENDPOINT_MODEM_LAN_TX] =3D {
> > +		.ee_id		=3D GSI_EE_MODEM,
> > +		.channel_id	=3D 6,
> > +		.endpoint_id	=3D 6,
> > +		.channel_name	=3D "modem_lan_tx",
> > +		.toward_ipa	=3D true,
> > +	},
> > +	[IPA_ENDPOINT_MODEM_COMMAND_TX] =3D {
> > +		.ee_id		=3D GSI_EE_MODEM,
> > +		.channel_id	=3D 7,
> > +		.endpoint_id	=3D 7,
> > +		.channel_name	=3D "modem_cmd_tx",
> > +		.toward_ipa	=3D true,
> > +	},
> > +	[IPA_ENDPOINT_MODEM_LAN_RX] =3D {
> > +		.ee_id		=3D GSI_EE_MODEM,
> > +		.channel_id	=3D 8,
> > +		.endpoint_id	=3D 8,
> > +		.channel_name	=3D "modem_lan_rx",
> > +		.toward_ipa	=3D false,
> > +	},
> > +	[IPA_ENDPOINT_MODEM_AP_RX] =3D {
> > +		.ee_id		=3D GSI_EE_MODEM,
> > +		.channel_id	=3D 9,
> > +		.endpoint_id	=3D 9,
> > +		.channel_name	=3D "modem_ap_rx",
> > +		.toward_ipa	=3D false,
> > +	},
> > +};
> > +
> > +static struct ipa_interconnect_data ipa_interconnect_data[] =3D {
> > +	{
> > +		.name =3D "memory",
> > +		.peak_bandwidth	=3D 1200000,	/* 1200 MBps */
> > +		.average_bandwidth =3D 100000,	/* 100 MBps */
> > +	},
> > +	{
> > +		.name =3D "imem",
> > +		.peak_bandwidth	=3D 350000,	/* 350 MBps */
> > +		.average_bandwidth  =3D 0,	/* unused */
> > +	},
> > +	{
> > +		.name =3D "config",
> > +		.peak_bandwidth	=3D 40000,	/* 40 MBps */
> > +		.average_bandwidth =3D 0,		/* unused */
> > +	},
> > +};
> > +
> > +static struct ipa_power_data ipa_power_data =3D {
> > +	.core_clock_rate	=3D 200 * 1000 * 1000,	/* Hz */
> > +	.interconnect_count	=3D ARRAY_SIZE(ipa_interconnect_data),
> > +	.interconnect_data	=3D ipa_interconnect_data,
> > +};
> > +
> > +/* IPA-resident memory region configuration for v2.0 */
> > +static const struct ipa_mem ipa_mem_local_data_v2_0[IPA_MEM_COUNT] =3D=
 {
> > +	[IPA_MEM_UC_SHARED] =3D {
> > +		.offset         =3D 0,
> > +		.size           =3D 0x80,
> > +		.canary_count   =3D 0,
> > +	},
> > +	[IPA_MEM_V4_FILTER] =3D {
> > +		.offset		=3D 0x0080,
> > +		.size		=3D 0x0058,
> > +		.canary_count	=3D 0,
> > +	},
> > +	[IPA_MEM_V6_FILTER] =3D {
> > +		.offset		=3D 0x00e0,
> > +		.size		=3D 0x0058,
> > +		.canary_count	=3D 2,
> > +	},
> > +	[IPA_MEM_V4_ROUTE] =3D {
> > +		.offset		=3D 0x0140,
> > +		.size		=3D 0x002c,
> > +		.canary_count	=3D 2,
> > +	},
> > +	[IPA_MEM_V6_ROUTE] =3D {
> > +		.offset		=3D 0x0170,
> > +		.size		=3D 0x002c,
> > +		.canary_count	=3D 1,
> > +	},
> > +	[IPA_MEM_MODEM_HEADER] =3D {
> > +		.offset		=3D 0x01a0,
> > +		.size		=3D 0x0140,
> > +		.canary_count	=3D 1,
> > +	},
> > +	[IPA_MEM_AP_HEADER] =3D {
> > +		.offset		=3D 0x02e0,
> > +		.size		=3D 0x0048,
> > +		.canary_count	=3D 0,
> > +	},
> > +	[IPA_MEM_MODEM] =3D {
> > +		.offset		=3D 0x032c,
> > +		.size		=3D 0x0dcc,
> > +		.canary_count	=3D 1,
> > +	},
> > +	[IPA_MEM_V4_FILTER_AP] =3D {
> > +		.offset		=3D 0x10fc,
> > +		.size		=3D 0x0780,
> > +		.canary_count	=3D 1,
> > +	},
> > +	[IPA_MEM_V6_FILTER_AP] =3D {
> > +		.offset		=3D 0x187c,
> > +		.size		=3D 0x055c,
> > +		.canary_count	=3D 0,
> > +	},
> > +	[IPA_MEM_UC_INFO] =3D {
> > +		.offset		=3D 0x1ddc,
> > +		.size		=3D 0x0124,
> > +		.canary_count	=3D 1,
> > +	},
> > +};
> > +
> > +static struct ipa_mem_data ipa_mem_data_v2_0 =3D {
> > +	.local		=3D ipa_mem_local_data_v2_0,
> > +	.smem_id	=3D 497,
> > +	.smem_size	=3D 0x00001f00,
> > +};
> > +
> > +/* Configuration data for IPAv2.0 */
> > +const struct ipa_data ipa_data_v2_0  =3D {
> > +	.version	=3D IPA_VERSION_2_0,
> > +	.endpoint_count	=3D ARRAY_SIZE(ipa_endpoint_data),
> > +	.endpoint_data	=3D ipa_endpoint_data,
> > +	.mem_data	=3D &ipa_mem_data_v2_0,
> > +	.power_data	=3D &ipa_power_data,
> > +};
> > +
> > +/* IPA-resident memory region configuration for v2.5 */
> > +static const struct ipa_mem ipa_mem_local_data_v2_5[IPA_MEM_COUNT] =3D=
 {
> > +	[IPA_MEM_UC_SHARED] =3D {
> > +		.offset         =3D 0,
> > +		.size           =3D 0x80,
> > +		.canary_count   =3D 0,
> > +	},
> > +	[IPA_MEM_UC_INFO] =3D {
> > +		.offset		=3D 0x0080,
> > +		.size		=3D 0x0200,
> > +		.canary_count	=3D 0,
> > +	},
> > +	[IPA_MEM_V4_FILTER] =3D {
> > +		.offset		=3D 0x0288,
> > +		.size		=3D 0x0058,
> > +		.canary_count	=3D 2,
> > +	},
> > +	[IPA_MEM_V6_FILTER] =3D {
> > +		.offset		=3D 0x02e8,
> > +		.size		=3D 0x0058,
> > +		.canary_count	=3D 2,
> > +	},
> > +	[IPA_MEM_V4_ROUTE] =3D {
> > +		.offset		=3D 0x0348,
> > +		.size		=3D 0x003c,
> > +		.canary_count	=3D 2,
> > +	},
> > +	[IPA_MEM_V6_ROUTE] =3D {
> > +		.offset		=3D 0x0388,
> > +		.size		=3D 0x003c,
> > +		.canary_count	=3D 1,
> > +	},
> > +	[IPA_MEM_MODEM_HEADER] =3D {
> > +		.offset		=3D 0x03c8,
> > +		.size		=3D 0x0140,
> > +		.canary_count	=3D 1,
> > +	},
> > +	[IPA_MEM_MODEM_PROC_CTX] =3D {
> > +		.offset		=3D 0x0510,
> > +		.size		=3D 0x0200,
> > +		.canary_count	=3D 2,
> > +	},
> > +	[IPA_MEM_AP_PROC_CTX] =3D {
> > +		.offset		=3D 0x0710,
> > +		.size		=3D 0x0200,
> > +		.canary_count	=3D 0,
> > +	},
> > +	[IPA_MEM_MODEM] =3D {
> > +		.offset		=3D 0x0914,
> > +		.size		=3D 0x16a8,
> > +		.canary_count	=3D 1,
> > +	},
> > +};
> > +
> > +static struct ipa_mem_data ipa_mem_data_v2_5 =3D {
> > +	.local		=3D ipa_mem_local_data_v2_5,
> > +	.smem_id	=3D 497,
> > +	.smem_size	=3D 0x00002000,
> > +};
> > +
> > +/* Configuration data for IPAv2.5 */
> > +const struct ipa_data ipa_data_v2_5  =3D {
> > +	.version	=3D IPA_VERSION_2_5,
> > +	.endpoint_count	=3D ARRAY_SIZE(ipa_endpoint_data),
> > +	.endpoint_data	=3D ipa_endpoint_data,
> > +	.mem_data	=3D &ipa_mem_data_v2_5,
> > +	.power_data	=3D &ipa_power_data,
> > +};
> > +
> > +/* IPA-resident memory region configuration for v2.6L */
> > +static const struct ipa_mem ipa_mem_local_data_v2_6L[IPA_MEM_COUNT] =
=3D {
> > +	{
> > +		.id		=3D IPA_MEM_UC_SHARED,
> > +		.offset         =3D 0,
> > +		.size           =3D 0x80,
> > +		.canary_count   =3D 0,
> > +	},
> > +	{
> > +		.id 		=3D IPA_MEM_UC_INFO,
> > +		.offset		=3D 0x0080,
> > +		.size		=3D 0x0200,
> > +		.canary_count	=3D 0,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_V4_FILTER,
> > +		.offset		=3D 0x0288,
> > +		.size		=3D 0x0058,
> > +		.canary_count	=3D 2,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_V6_FILTER,
> > +		.offset		=3D 0x02e8,
> > +		.size		=3D 0x0058,
> > +		.canary_count	=3D 2,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_V4_ROUTE,
> > +		.offset		=3D 0x0348,
> > +		.size		=3D 0x003c,
> > +		.canary_count	=3D 2,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_V6_ROUTE,
> > +		.offset		=3D 0x0388,
> > +		.size		=3D 0x003c,
> > +		.canary_count	=3D 1,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_MODEM_HEADER,
> > +		.offset		=3D 0x03c8,
> > +		.size		=3D 0x0140,
> > +		.canary_count	=3D 1,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_ZIP,
> > +		.offset		=3D 0x0510,
> > +		.size		=3D 0x0200,
> > +		.canary_count	=3D 2,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_MODEM,
> > +		.offset		=3D 0x0714,
> > +		.size		=3D 0x18e8,
> > +		.canary_count	=3D 1,
> > +	},
> > +	{
> > +		.id		=3D IPA_MEM_END_MARKER,
> > +		.offset		=3D 0x2000,
> > +		.size		=3D 0,
> > +		.canary_count	=3D 1,
> > +	},
> > +};
> > +
> > +static struct ipa_mem_data ipa_mem_data_v2_6L =3D {
> > +	.local		=3D ipa_mem_local_data_v2_6L,
> > +	.smem_id	=3D 497,
> > +	.smem_size	=3D 0x00002000,
> > +};
> > +
> > +/* Configuration data for IPAv2.6L */
> > +const struct ipa_data ipa_data_v2_6L  =3D {
> > +	.version	=3D IPA_VERSION_2_6L,
> > +	/* Unfortunately we don't know what this BCR value corresponds to */
> > +	.backward_compat =3D 0x1fff7f,
> > +	.endpoint_count	=3D ARRAY_SIZE(ipa_endpoint_data),
> > +	.endpoint_data	=3D ipa_endpoint_data,
> > +	.mem_data	=3D &ipa_mem_data_v2_6L,
> > +	.power_data	=3D &ipa_power_data,
> > +};
> > diff --git a/drivers/net/ipa/ipa_data-v3.1.c b/drivers/net/ipa/ipa_data=
-v3.1.c
> > index 06ddb85f39b2..12d231232756 100644
> > --- a/drivers/net/ipa/ipa_data-v3.1.c
> > +++ b/drivers/net/ipa/ipa_data-v3.1.c
> > @@ -6,7 +6,7 @@
> >  =20
> >   #include <linux/log2.h>
> >  =20
> > -#include "gsi.h"
> > +#include "ipa_dma.h"
> >   #include "ipa_data.h"
> >   #include "ipa_endpoint.h"
> >   #include "ipa_mem.h"
> > diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
> > index 7d62d49f414f..e7ce2e9388b6 100644
> > --- a/drivers/net/ipa/ipa_data.h
> > +++ b/drivers/net/ipa/ipa_data.h
> > @@ -301,6 +301,9 @@ struct ipa_data {
> >   	const struct ipa_power_data *power_data;
> >   };
> >  =20
> > +extern const struct ipa_data ipa_data_v2_0;
> > +extern const struct ipa_data ipa_data_v2_5;
> > +extern const struct ipa_data ipa_data_v2_6L;
> >   extern const struct ipa_data ipa_data_v3_1;
> >   extern const struct ipa_data ipa_data_v3_5_1;
> >   extern const struct ipa_data ipa_data_v4_2;
> > diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> > index b437fbf95edf..3ae5c5c6734b 100644
> > --- a/drivers/net/ipa/ipa_main.c
> > +++ b/drivers/net/ipa/ipa_main.c
> > @@ -560,6 +560,18 @@ static int ipa_firmware_load(struct device *dev)
> >   }
> >  =20
> >   static const struct of_device_id ipa_match[] =3D {
> > +	{
> > +		.compatible	=3D "qcom,ipa-v2.0",
> > +		.data		=3D &ipa_data_v2_0,
> > +	},
> > +	{
> > +		.compatible	=3D "qcom,msm8996-ipa",
> > +		.data		=3D &ipa_data_v2_5,
> > +	},
> > +	{
> > +		.compatible	=3D "qcom,msm8953-ipa",
> > +		.data		=3D &ipa_data_v2_6L,
> > +	},
> >   	{
> >   		.compatible	=3D "qcom,msm8998-ipa",
> >   		.data		=3D &ipa_data_v3_1,
> > @@ -632,6 +644,9 @@ static void ipa_validate_build(void)
> >   static bool ipa_version_valid(enum ipa_version version)
> >   {
> >   	switch (version) {
> > +	case IPA_VERSION_2_0:
> > +	case IPA_VERSION_2_5:
> > +	case IPA_VERSION_2_6L:
> >   	case IPA_VERSION_3_0:
> >   	case IPA_VERSION_3_1:
> >   	case IPA_VERSION_3_5:
> > diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
> > index ff61dbdd70d8..f5d159f6bc06 100644
> > --- a/drivers/net/ipa/ipa_sysfs.c
> > +++ b/drivers/net/ipa/ipa_sysfs.c
> > @@ -14,6 +14,12 @@
> >   static const char *ipa_version_string(struct ipa *ipa)
> >   {
> >   	switch (ipa->version) {
> > +	case IPA_VERSION_2_0:
> > +		return "2.0";
> > +	case IPA_VERSION_2_5:
> > +		return "2.5";
> > +	case IPA_VERSION_2_6L:
> > +		"return 2.6L";
> >   	case IPA_VERSION_3_0:
> >   		return "3.0";
> >   	case IPA_VERSION_3_1:
> >=20

