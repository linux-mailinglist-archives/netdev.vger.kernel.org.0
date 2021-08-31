Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205903FC04A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 03:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbhHaBC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 21:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhHaBCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 21:02:24 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEE1C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:01:30 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id y23so15133638pgi.7
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aslSDAi77rMf5bZHwtM9yUKMTbaM2ULIm11sVe+p4Hc=;
        b=qtr1fpaIfcwNozaWOuNJIzbJSQYGphmfo02eMgb53zObFpjKMpFJJdlFCc20sfm2fz
         kyQrbWh3pI4UQpBJp08+LTa19nGjIllOxZmTe4iAVUT5D5B+IRRSQIMT8gD2N1u9Ggf4
         bkccl0OafrhszZxS7lDxiQr0Ggor1n0tnskdUQxGHwQmVlS7+Wq62SKhW5lSscFDWqU+
         Zg5NtY6nw2iZLDmUToUK0woDk4AXGfrM2NFPoCnv8cabfEMZEPpwZ2DvUuxdM6stzyU9
         RaRlSHcr8N/OJ4T+0OVQu5I+nwQ1jUd9cQ/5249dIFuOvv6G+JHHGfHVshe9aZKT5F17
         I44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aslSDAi77rMf5bZHwtM9yUKMTbaM2ULIm11sVe+p4Hc=;
        b=kkmF2Itxf9ywi6PRQMNpGOLx/9vMk6v9EHGybl0zmV/Qztf5lPsibgtxg4aJ8TeDuE
         4LrAwXSPszHbHx5wVbJVi6ueDLRocZLXbNg3CXFFuyMfCHk90JKrKdCobUzuFh5URJZ8
         EUmKy7q03FX6uQuSMIEd+KULCXH0k6tTHjgICYXxQcp82IBRYuEJDKKdflLzGq2nU9Wm
         rxpCz/dgWCl/NFkMYiK8OTXlIMvD3g6ePyV12FnWll4xn+zdln8WEvR4R9xXVMnCl+0r
         HETr/Y5W3d/vTJCLpd/pL2Yz15nB07HnERTgaZUWh4ojzL5CAsDzuNoiuXjRvU34+BgL
         sg1w==
X-Gm-Message-State: AOAM532x1I9dZ+pGEm8b49oYLXpvUJbf+SDKA1Yz0V9+n8fyRXk4dBcB
        T2jbJjbojykI7xw0F1BKuHQ=
X-Google-Smtp-Source: ABdhPJyVXj/TfJFVkSGXo5pQhmuqirNPaX3MYES6mWr25AfF5Aq61Yr5lBZ8k8ZL5w5foXurhqdOkw==
X-Received: by 2002:aa7:989d:0:b0:3ef:5f81:5c2f with SMTP id r29-20020aa7989d000000b003ef5f815c2fmr25736311pfl.44.1630371689415;
        Mon, 30 Aug 2021 18:01:29 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with UTF8SMTPSA id 17sm655719pjd.3.2021.08.30.18.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 18:01:28 -0700 (PDT)
Message-ID: <25ea3d32-0525-07ff-1bfb-eeeee3ab6ad6@gmail.com>
Date:   Mon, 30 Aug 2021 18:01:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH net-next 1/5 v2] net: dsa: rtl8366rb: support bridge
 offloading
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-2-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210830214859.403100-2-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/2021 2:48 PM, Linus Walleij wrote:
> From: DENG Qingfang <dqfext@gmail.com>
> 
> Use port isolation registers to configure bridge offloading.
> 
> Tested on the D-Link DIR-685, switching between ports and
> sniffing ports to make sure no packets leak.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - introduce RTL8366RB_PORT_ISO_PORTS() to shift the port
>    mask into place so we are not confused by the enable
>    bit.
> - Use this with dsa_user_ports() to isolate the CPU port
>    from itself.
> ---
>   drivers/net/dsa/rtl8366rb.c | 87 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 87 insertions(+)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index a89093bc6c6a..50ee7cd62484 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -300,6 +300,13 @@
>   #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
>   #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
>   
> +/* Port isolation registers */
> +#define RTL8366RB_PORT_ISO_BASE		0x0F08
> +#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
> +#define RTL8366RB_PORT_ISO_EN		BIT(0)
> +#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)
> +#define RTL8366RB_PORT_ISO_PORTS(pmask)	(pmask << 1)
> +
>   /* bits 0..5 enable force when cleared */
>   #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
>   
> @@ -835,6 +842,22 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>   	if (ret)
>   		return ret;
>   
> +	/* Isolate all user ports so only the CPU port can access them */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
> +				   RTL8366RB_PORT_ISO_EN |
> +				   RTL8366RB_PORT_ISO_PORTS(BIT(RTL8366RB_PORT_NUM_CPU)));
> +		if (ret)
> +			return ret;
> +	}
> +	/* CPU port can access all ports */
> +	dev_info(smi->dev, "DSA user port mask: %08x\n", dsa_user_ports(ds));

As mentioned by Alvin, this should be a dev_dbg() or completely eliminated.

> +	ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
> +			   RTL8366RB_PORT_ISO_PORTS(dsa_user_ports(ds))|
> +			   RTL8366RB_PORT_ISO_EN);
> +	if (ret)
> +		return ret;
> +
>   	/* Set up the "green ethernet" feature */
>   	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
>   				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
> @@ -1127,6 +1150,68 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
>   	rb8366rb_set_port_led(smi, port, false);
>   }
>   
> +static int
> +rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
> +			   struct net_device *bridge)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	unsigned int port_bitmap = 0;
> +	int ret, i;
> +
> +	/* Loop over all other ports than this one */

This sentence is a bit weird, how about: Loop over all ports but this one?

> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		/* Handled last */

This comment is a bit misleading as it would suggest that the loop does 
act on 'port' when really it does that outside of the loop.

With those nitpicks fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
