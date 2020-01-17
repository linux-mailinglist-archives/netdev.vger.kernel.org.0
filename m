Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF153140EE2
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 17:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAQQZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 11:25:12 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34135 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgAQQZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 11:25:11 -0500
Received: by mail-pf1-f196.google.com with SMTP id i6so12181291pfc.1
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 08:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RsIY3cPfHMiUzparlKwjQbkw1NkgGh3wBE1/ck320iM=;
        b=gARwejX/5mL9zXL+gjXu3ozzXYn3nPKeylpP4bAx3l2EUp//itkydV0rV1qGoTz3E/
         44Qs4cHpvjWI3gXWOhgpe7uT81voRBgWHSLHuiR9Opo6JFijnbtAVCN52j6aZk/6dAle
         UvB+LUdwsAa/w8zC0mm4uJ+46K1WILXVksLOZc8Di/l4KpEFOXMRi7+TzLiSaL+NBKk0
         YFNrOv0pcu6V6M/HaV4PyXCz09z2oh988n67rOkY3f3gFDge1QjMLnpbGfPCHl5V9PtN
         RwWFHeQvCh0tKHtiYdJaOVRRnh7bSp1YMNo6ZASxod7vmH/XCXcYdibh+tI683shTc+l
         UYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RsIY3cPfHMiUzparlKwjQbkw1NkgGh3wBE1/ck320iM=;
        b=dW/Svs8fFtkkrDZnZWFvjPzq222bHj2aFcGXfU4JrrMjOBhorJ2U7dt5eqEpo15t0z
         QxlvLYigK6D89kDJ2VefRpiM0v3O4PiZKm0j/Z3lAxjq3TDBGtLrwrCeNhH6Jg6sVXy+
         AjRUlTkpKnG7CpMUCYGiUKPHpjMpQW5HYwiyltF+YimvPOZkit0psVensl6eKikJTIiK
         tHF0VrmhhI+IDLEwbKFqj/LvXBN0iAlPXuOjMcwG1hYO2QhOTqab3Sz0GqfI9IJOgKCX
         ANe4iMFbQveIfL9lXvTXZcFQ2yrAIB0g4Q9FJ16F+hDZi/xAxF2BeUyITZSWRtbnmMQt
         Unmw==
X-Gm-Message-State: APjAAAUng6JRHlXiD/Gyg9HvgTV8IaQkoR8kgEkIEiAUKF1aKoUHeb9X
        y0IQFgsehHnU6A0OpRYLjCU=
X-Google-Smtp-Source: APXvYqykTzkWp0Hu0AYF2dtp3ymYoC6cer0ZVpqpRr4a2H/NPeVHzS5ryuttshN2qXcWXF+D62Xmhg==
X-Received: by 2002:aa7:8f33:: with SMTP id y19mr3564153pfr.47.1579278311334;
        Fri, 17 Jan 2020 08:25:11 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p5sm28811545pga.69.2020.01.17.08.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 08:25:10 -0800 (PST)
Subject: Re: [PATCH net] net: usb: lan78xx : implement .ndo_features_check
To:     James Hughes <james.hughes@raspberrypi.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
References: <CAE_XsMLw5xnwGv6vjMqWnHqy7KjsgooujbTz+dEzNCdVrve9Nw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e84d3a47-58d5-7971-a62f-9a2295fffbf4@gmail.com>
Date:   Fri, 17 Jan 2020 08:25:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAE_XsMLw5xnwGv6vjMqWnHqy7KjsgooujbTz+dEzNCdVrve9Nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/20 3:49 AM, James Hughes wrote:
> As reported by Eric Dumazet, there are still some outstanding
> cases where the driver does not handle TSO correctly when skb's
> are over a certain size. Most cases have been fixed, this patch
> should ensure that forwarded SKB's that are greater than
> MAX_SINGLE_PACKET_SIZE - TX_OVERHEAD are software segmented
> and handled correctly.
> 
> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> ---
>  drivers/net/usb/lan78xx.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index bc572b921fe1..a01c78d8b9a3 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -31,6 +31,7 @@
>  #include <linux/mdio.h>
>  #include <linux/phy.h>
>  #include <net/ip6_checksum.h>
> +#include <net/vxlan.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqdomain.h>
>  #include <linux/irq.h>
> @@ -3733,6 +3734,19 @@ static void lan78xx_tx_timeout(struct net_device *net)
>   tasklet_schedule(&dev->bh);
>  }
> 
> +static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
> + struct net_device *netdev,
> + netdev_features_t features)
> +{
> + if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
> + features &= ~NETIF_F_GSO_MASK;
> +
> + features = vlan_features_check(skb, features);
> + features = vxlan_features_check(skb, features);
> +
> + return features;
> +}
> +


Your patch is mangled (tabulations were replaced by one space)

Please fix and resubmit, thanks !

