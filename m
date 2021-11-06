Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF04446C09
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 03:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhKFCcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 22:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhKFCci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 22:32:38 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583AFC061570;
        Fri,  5 Nov 2021 19:29:58 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id o4so17474006oia.10;
        Fri, 05 Nov 2021 19:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Cx/5L6YHV8PLhIoo7ZFeFyDy2iN4fUwBCCwtNoKUz7g=;
        b=b4HZay8PgkTEjVD6y5tAsBytBplt9zifqTXwQq6klN7BmZYgMOXwozNQ3ep0f8/0xu
         VJtwXaNEK+ZvQo64+OS7fa8gDA/ABsQyjLah+Zm3iF5fWVsLOZkyl+8BKIfm7gp4oGTl
         VlOJFekERmFvqX7n433z25TN3JzpsBYGXbSgSZBJKj3b6EKKevD01WlR1K9RXWGPUYa/
         kk6eppmZgv2vVZ2lsApsbKrPxL3LpY6pv1bJIyyxddtjNfnOLHfbXJIrQXKhyiJGE5ip
         T0nAJ/1J5SQK68Neuq1x4hKaH3BoDfIqgRqbHoyjb15ORjFJbdJOLMe97Z269/2OUR6v
         gEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Cx/5L6YHV8PLhIoo7ZFeFyDy2iN4fUwBCCwtNoKUz7g=;
        b=AhHczj2vwPRsAxu8QkZQcdFmyCNnLh7pmNHeHYSoNN4D2jkiLf6tCmE/QpIRCTp+gK
         au3/nmc1y7/6Y86cG7cxL+p8SGOciN/9dbI4Q+GggL4FJGMFtwZ/M95fBKuOG4YLWhwp
         ySluD2oPgAc6z2O04cWbEM8EUOrzzZDdU+EjpEtyJK+RquDga12DL6tUQG5b1MpH9N81
         g9uGy3AXHLwsW2PgaIO9eQnyAJnS+2Xsq3vGPPvX9sCafjK/+TnmqybeBd60zZ+7bE26
         3CSaQBKhkBxdybvgJ7QcYG8ukg3zFmKVuBgyJs1PuVWEtRoGAdBincOEayRBf9Th+KuI
         TekQ==
X-Gm-Message-State: AOAM532JWFLkcx9+qaMp1hDsC5sAuupTeMXf5m4NNgugijXCNUjsl48L
        3u5o/A7PgzuReCfbMtzcNsY=
X-Google-Smtp-Source: ABdhPJxJXIqAVGBfSmySumplWAbCYTLW215Byq2FC9MP310fCXqFRGt9m3SS+ow8dT1kUrX8IXZhrA==
X-Received: by 2002:a05:6808:3a5:: with SMTP id n5mr12308660oie.62.1636165797014;
        Fri, 05 Nov 2021 19:29:57 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:14e0:e534:f753:ba71? ([2600:1700:dfe0:49f0:14e0:e534:f753:ba71])
        by smtp.gmail.com with ESMTPSA id h1sm939837oom.12.2021.11.05.19.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 19:29:56 -0700 (PDT)
Message-ID: <04b34a92-bc31-adcd-5357-0faf61612a31@gmail.com>
Date:   Fri, 5 Nov 2021 19:29:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 1/7] net: dsa: b53: Add BroadSync HD register definitions
Content-Language: en-US
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-2-martin.kaistra@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211104133204.19757-2-martin.kaistra@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2021 6:31 AM, Martin Kaistra wrote:
> From: Kurt Kanzenbach <kurt@linutronix.de>
> 
> Add register definitions for the BroadSync HD features of
> BCM53128. These will be used to enable PTP support.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---
>   drivers/net/dsa/b53/b53_regs.h | 38 ++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
> index b2c539a42154..c8a9d633f78b 100644
> --- a/drivers/net/dsa/b53/b53_regs.h
> +++ b/drivers/net/dsa/b53/b53_regs.h
> @@ -50,6 +50,12 @@
>   /* Jumbo Frame Registers */
>   #define B53_JUMBO_PAGE			0x40
>   
> +/* BroadSync HD Register Page */
> +#define B53_BROADSYNC_PAGE		0x90
> +
> +/* Traffic Remarking Register Page */
> +#define B53_TRAFFICREMARKING_PAGE	0x91
> +
>   /* EEE Control Registers Page */
>   #define B53_EEE_PAGE			0x92
>   
> @@ -479,6 +485,38 @@
>   #define   JMS_MIN_SIZE			1518
>   #define   JMS_MAX_SIZE			9724
>   
> +/*************************************************************************
> + * BroadSync HD Page Registers
> + *************************************************************************/
> +
> +#define B53_BROADSYNC_EN_CTRL1		0x00
> +#define B53_BROADSYNC_EN_CTRL2		0x01

This is a single register which is 16-bit wide, can you also add a 
comment to that extent like what is done for other register definitions?

> +#define B53_BROADSYNC_TS_REPORT_CTRL	0x02
> +#define B53_BROADSYNC_PCP_CTRL		0x03
> +#define B53_BROADSYNC_MAX_SDU		0x04


> +#define B53_BROADSYNC_TIMEBASE1		0x10

Single register which is 32-bit wide, no need to define the 
TIMEBASE1..4, just call it timebase.

> +#define B53_BROADSYNC_TIMEBASE2		0x11
> +#define B53_BROADSYNC_TIMEBASE3		0x12
> +#define B53_BROADSYNC_TIMEBASE4		0x13
> +#define B53_BROADSYNC_TIMEBASE_ADJ1	0x14

Likewise.

> +#define B53_BROADSYNC_TIMEBASE_ADJ2	0x15
> +#define B53_BROADSYNC_TIMEBASE_ADJ3	0x16
> +#define B53_BROADSYNC_TIMEBASE_ADJ4	0x17
> +#define B53_BROADSYNC_SLOT_CNT1		0x18
> +#define B53_BROADSYNC_SLOT_CNT2		0x19
> +#define B53_BROADSYNC_SLOT_CNT3		0x1a > +#define B53_BROADSYNC_SLOT_CNT4		0x1b

Likewise, 32-bit register.

> +#define B53_BROADSYNC_SLOT_ADJ1		0x1c
> +#define B53_BROADSYNC_SLOT_ADJ2		0x1d
> +#define B53_BROADSYNC_SLOT_ADJ3		0x1e
> +#define B53_BROADSYNC_SLOT_ADJ4		0x1f

And likewise

> +#define B53_BROADSYNC_CLS5_BW_CTRL	0x30
> +#define B53_BROADSYNC_CLS4_BW_CTRL	0x60
> +#define B53_BROADSYNC_EGRESS_TS		0x90
> +#define B53_BROADSYNC_EGRESS_TS_STS	0xd0
> +#define B53_BROADSYNC_LINK_STS1		0xe0
> +#define B53_BROADSYNC_LINK_STS2		0xe1

Likewise this is a 16-bit register.
> +
>   /*************************************************************************
>    * EEE Configuration Page Registers
>    *************************************************************************/
> 

-- 
Florian
