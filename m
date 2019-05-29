Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDE72E212
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfE2QMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:12:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36811 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfE2QMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:12:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id u22so1943813pfm.3;
        Wed, 29 May 2019 09:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xkkSoeIJ5NlHJgTUsmglQ/r401Y8KOeJXycUoDLqA0w=;
        b=LD3U8XaRujtilCrXVCJc0zq4EJkGKx6tHIt/HRmSp0Nxib86CcafYSR2riNyx16+Qn
         97tYzQl2BUBoJZFdUJa2yojNZ7l5GUnm0Tm+6NQaaY6IEZJVA7HCNL27czjhN5CuypEJ
         FDT3vp3zeSIVTaR+xsi+rq8KodBOUsBY4DkeMfx73iLHkMLX3FTEkNpQahgOD75XZdt7
         w7W9mItTBFESZ37hfKgvnPovkPI5GVhZhZJdei98545eI8m7wn9p907HisUWdN9/k7S/
         c+D2S0qqR9v1TY0aCFBorRssrtz6zGABB3LTcjw9KiGEgt92QSmpCE3IZqc19Qu1pavO
         yHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xkkSoeIJ5NlHJgTUsmglQ/r401Y8KOeJXycUoDLqA0w=;
        b=nZRo4SetSBXIqwuJVrRawm2C8W3oja69A7rMKC9MilKAB1dhafsbs9gIaYTIkhyMDd
         z24IWyVS/2i2RxZ8jnqHbJO6bqj6TtE0XTWHz3l4rjbw/NoljgARbBEJP0jMbihD5tul
         4YB5miNs7ThLkxjhStBLwDEA9g352gyagmueqby38wbU2Y9RoXTchKNOuC7UmTqxNJcd
         RmO8fnfXdIZ/60i4/ytnlEQ0+H6D1LO9AR49kodIONHZAjUclO+HHraKJcPmceMxPNIJ
         S3w2BaRiR8kgNhiWWUOaWpU8e2yYau1ZQsLnrqrboed26pMyvaTJDzzGDwOlOmIs+c5K
         HKyw==
X-Gm-Message-State: APjAAAWJstw4kl7EzqaLkGh+U4Qy/bgGRA4O75tAhD3GQaC6WL60chO9
        IF/d/zL7RdocaDE8YzwwDEI=
X-Google-Smtp-Source: APXvYqyRKYhfkHRZ5CactAZltsaeDn4rCjzo1VgAWWQYoRhR/oz2+Vkk/7tDriW4LM9FjnsdX2XpcA==
X-Received: by 2002:a62:d41c:: with SMTP id a28mr52493954pfh.31.1559146355284;
        Wed, 29 May 2019 09:12:35 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:31f1:bcc4:54e4:3069? ([2601:282:800:fd80:31f1:bcc4:54e4:3069])
        by smtp.googlemail.com with ESMTPSA id 1sm73299pfn.165.2019.05.29.09.12.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 09:12:34 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/4] rdma: Add an option to query,set net
 namespace sharing sys parameter
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        stephen@networkplumber.org, leonro@mellanox.com
References: <20190521142244.8452-1-parav@mellanox.com>
 <20190521142244.8452-2-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <014b3e56-9aa0-4b20-158c-d4907078d224@gmail.com>
Date:   Wed, 29 May 2019 10:12:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190521142244.8452-2-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/19 8:22 AM, Parav Pandit wrote:
> diff --git a/rdma/sys.c b/rdma/sys.c
> new file mode 100644
> index 00000000..78e5198f
> --- /dev/null
> +++ b/rdma/sys.c
> @@ -0,0 +1,143 @@
> +/*
> + * sys.c	RDMA tool
> + *
> + *              This program is free software; you can redistribute it and/or
> + *              modify it under the terms of the GNU General Public License
> + *              as published by the Free Software Foundation; either version
> + *              2 of the License, or (at your option) any later version.
> + */

Please use the SPDX line like the other rdma files.

> +
> +#include "rdma.h"
> +
> +static int sys_help(struct rd *rd)
> +{
> +	pr_out("Usage: %s system show [ netns ]\n", rd->filename);
> +	pr_out("       %s system set netns { shared | exclusive }\n", rd->filename);
> +	return 0;
> +}
> +
> +static const char *netns_modes_str[] = {
> +	"exclusive",
> +	"shared",
> +};
> +
> +static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
> +	struct rd *rd = data;
> +
> +	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
> +
> +	if (tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]) {
> +		const char *mode_str;
> +		uint8_t netns_mode;
> +
> +		netns_mode =
> +			mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]);
> +
> +		if (netns_mode <= ARRAY_SIZE(netns_modes_str))
> +			mode_str = netns_modes_str[netns_mode];
> +		else
> +			mode_str = "unknown";
> +
> +		if (rd->json_output)
> +			jsonw_string_field(rd->jw, "netns", mode_str);
> +		else
> +			pr_out("netns %s\n", mode_str);
> +	}
> +	return MNL_CB_OK;
> +}
> +
> +static int sys_show_no_args(struct rd *rd)
> +{
> +	uint32_t seq;
> +	int ret;
> +
> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SYS_GET,
> +		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
> +	ret = rd_send_msg(rd);
> +	if (ret)
> +		return ret;
> +
> +	ret = rd_recv_msg(rd, sys_show_parse_cb, rd, seq);
> +	return ret;

since you are fixing the header, why not just
	return rd_recv_msg(rd, sys_show_parse_cb, rd, seq);

like the other functions?

