Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B93172FBC
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 05:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgB1EWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 23:22:06 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44975 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730586AbgB1EWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 23:22:06 -0500
Received: by mail-pl1-f195.google.com with SMTP id d9so705068plo.11;
        Thu, 27 Feb 2020 20:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sdMxzD9h4xt5KIJBL42oIn+fnrbFZDmEguIk1pVGYoM=;
        b=KYlsgT5XOldsbHD+HRNzl5ZRcqGgBffKs/aY4hYaLXMh1taKtzhCRAGS1T+Ab6Qahu
         4BRsJ5xUKlXqVxHf9R6vBjadyiOglkDqjODzIVJpQLEPHFTgYbgMRHUGvAwqWpxhuJkI
         ZY/x+VxPi579JZMkhlC9w9KlZtZEuw6H+zxlFrF8nSVpv0JaV543pzBvwPFbRiXdAek3
         e7JqiKlZXU+XmT2WxeOzDiD5Msyb//zTfLUk5MnyM9ULDJ+CLQcBkTPc8BNB1II01Kfx
         kGCtQDvk3D7JWd8oxfGsOp8A3PxVl6ql4k7n0VWC0KeDcpTWc14HI5D54lVrPkFIqlmh
         /eYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sdMxzD9h4xt5KIJBL42oIn+fnrbFZDmEguIk1pVGYoM=;
        b=ffJSLhiBwfn5olozu4Ndrl8c3sf+9DviIqiHEW00YB1p/LfPSxDwI0ytOEcuhd0dm6
         W+4Dx7JYq0wt79efQglemo5dn0XWmlEztnVjc4WCek5mK4ktZS02H1reXBu9tEBmCLGy
         mi/aorgWDsoCV4OjZjW51loS7F4XuDd9GLBxNJ5RHTapgqTZ4CGnfzh5TbQt8BH5jKvO
         w0XZiGcFB40IKJ3zPRYW5FGftLzYpML6FLCg5AxvN//DjMfp+o9hk4lz+RUlFql1A0Zx
         N4/pUEbv+p6nV3y5w8T9Mwjl8JoVfOcDR9p1bkSHEYZsHNn2ALhWbO7pj/3nnrZepwLG
         rzvA==
X-Gm-Message-State: APjAAAU7aKSXi7SG/smBDGXTuqYGyfFjk1r2Zwhl9b8DqBKXobVkHEEb
        XZgaDc6TgTp5JSTHhuz6682gXKCl
X-Google-Smtp-Source: APXvYqzxUNYyaKGoKvGWBWUSbvOLOVnM0gWgkFR9yZgcfIcaJw790CNfeCFltB7MpBRluvWE/sG+jA==
X-Received: by 2002:a17:90a:8902:: with SMTP id u2mr2561390pjn.79.1582863724708;
        Thu, 27 Feb 2020 20:22:04 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 13sm8762670pfi.78.2020.02.27.20.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 20:22:04 -0800 (PST)
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <c7229424-5c99-7ea7-da82-ad47a8b7fc28@gmail.com>
Date:   Thu, 27 Feb 2020 20:22:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225163025.9430-2-vadym.kochan@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/2020 8:30 AM, Vadym Kochan wrote:
> Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.
> 
> This driver implementation includes only L1 & basic L2 support.
> 
> The core Prestera switching logic is implemented in prestera.c, there is
> an intermediate hw layer between core logic and firmware. It is
> implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> related logic, in future there is a plan to support more devices with
> different HW related configurations.
> 
> The following Switchdev features are supported:
> 
>     - VLAN-aware bridge offloading
>     - VLAN-unaware bridge offloading
>     - FDB offloading (learning, ageing)
>     - Switchport configuration
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>

Very little to pick on, the driver is nice and clean, great job!

> ---

[snip]

> +#define PORT_STATS_CACHE_TIMEOUT_MS	(msecs_to_jiffies(1000))
> +#define PORT_STATS_CNT	(sizeof(struct mvsw_pr_port_stats) / sizeof(u64))

All entries in mvsw_pr_port_stats are u64 so you can use ARRAY_SIZE() here.

[snip]

> +
> +	err = register_netdev(net_dev);
> +	if (err)
> +		goto err_register_netdev;
> +
> +	list_add(&port->list, &sw->port_list);

As soon as you publish the network device it can be used by notifiers,
user-space etc, better do this as the last operation.

[snip]

> +int mvsw_pr_hw_port_stats_get(const struct mvsw_pr_port *port,
> +			      struct mvsw_pr_port_stats *stats)
> +{
> +	struct mvsw_msg_port_stats_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_STATS,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	u64 *hw_val = resp.stats;
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	stats->good_octets_received = hw_val[MVSW_PORT_GOOD_OCTETS_RCV_CNT];

This seems error prone and not scaling really well, since all stats
member are u64 and they are ordered in the same way as the response, is
not a memcpy() sufficient here?
-- 
Florian
