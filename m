Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843091B1307
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgDTRaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726792AbgDTRaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:30:39 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B1BC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:30:38 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id g4so2792275ljl.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1wjTQ8kSFEtHQTXiFNn5xmo0XMmmUMj65r7WNBjKJEs=;
        b=NXWy+rZceFxcX4Q1BJl0H6GFSnc8ZUNALstxT4T+qvd8/wDRTj6ZJJvxrBNPnQNrqv
         yxCIbphz2+7r3DPHzNv2pmmsU3LBsO8/U8o4rR5OyMC7a/0ye+6Wx/LpBfCxCrhkLoYC
         qjxGOvLw3i7MDYFX+YK+9yRHVnuKJWeB0zWeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wjTQ8kSFEtHQTXiFNn5xmo0XMmmUMj65r7WNBjKJEs=;
        b=sogXs0MGDYKU0ePe6n/LQeBAuPzvbM8iRbA0tABmAyOEGotmIFE6I3x1nCDxmUbHL4
         Nk1B2DjxNQQQ6ueV/460XJYoy90+6isbgYzTqpE+5r4c68EwAhPl2tjkX4K/wlzf0aZq
         xopBF+pYq3BTY9h0V4WbuFbrs9TDXij1DheCgtRg/PBOtMhZWH8Nymu9n5w/TIA3fhnd
         qGee+lcqj5b3x7s/4V/s+uU2tc9CUfXj2NQQHcXB1SaN/W1EoFKRXvjTNdr8YB1nb4SP
         cMPncy+cfQWjUw0K6XxhdP7dyY527IId+FqSoGeFJm7NryEFWdOOjnfKv99/aYO5HCRT
         6Ilw==
X-Gm-Message-State: AGi0PuZ2dAPsh3Ft8v1cc/Ehbk21Hp7r9BjJO6nuHPu+v2TTzJnOitBP
        HEW2+MVoVaRggTJqMdHRQZ0U2w==
X-Google-Smtp-Source: APiQypKQO2gTG7fbfBVsthNRTh8bjAdJR0WFz6Vc4MxI2oM3VrAN/sw/+3NkB9IDtkhdbML676NqOA==
X-Received: by 2002:a05:651c:385:: with SMTP id e5mr10993014ljp.208.1587403837014;
        Mon, 20 Apr 2020 10:30:37 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d3sm33429lfq.63.2020.04.20.10.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 10:30:36 -0700 (PDT)
Subject: Re: [PATCH net-next 04/13] bridge: mrp: Expose function
 br_mrp_port_open
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
 <20200420150947.30974-5-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <cc388b70-701c-4600-791b-8170683a7666@cumulusnetworks.com>
Date:   Mon, 20 Apr 2020 20:30:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420150947.30974-5-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2020 18:09, Horatiu Vultur wrote:
> In case the HW is capable to detect when the MRP ring is open or closed. It is
> expected that the network driver will notify the SW that the ring is open or
> closed.
> 
> The function br_mrp_port_open is used to notify the kernel that one of the ports
> stopped receiving MRP_Test frames. The argument 'loc' has a value of '1' when
> the port stopped receiving MRP_Test and '0' when it started to receive MRP_Test.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/linux/mrp_bridge.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 include/linux/mrp_bridge.h
> 
> diff --git a/include/linux/mrp_bridge.h b/include/linux/mrp_bridge.h
> new file mode 100644
> index 000000000000..61c1f0d395c7
> --- /dev/null
> +++ b/include/linux/mrp_bridge.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +#ifndef _LINUX_MRP_BRIDGE_H
> +#define _LINUX_MRO_BRIDGE_H
> +
> +#include <linux/netdevice.h>
> +
> +/* The drivers are responsible to call this function when it detects that the
> + * MRP port stopped receiving MRP_Test frames or it started to receive MRP_Test.
> + * The argument dev represents the port and loc(Lost of Continuity) has a value
> + * of 1 when it stopped receiving MRP_Test frames and a value of 0 when it
> + * started to receive frames.
> + * Needs to be called with rcu_read_lock().
> + *
> + * This eventually notify the userspace which is required to react on these
> + * changes.
> + */
> +
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +int br_mrp_port_open(struct net_device *dev, u8 loc);
> +#else
> +static inline int br_mrp_port_open(struct net_device *dev, u8 loc)
> +{
> +}
> +#endif
> +
> +#endif
> 

I see that in order to pass this "loc" to br_ifinfo_notify() you add a new port variable,
but it's a boolean, so you can just use the port flags for it which will simplify things a lot
and remove some ifdefs along the way. And please rename it to something longer (so it's easier
to get what it does).

One question - now that it's always sent to user-space as IFLA_BRPORT_MRP_RING_OPEN attribute
wouldn't it be a problem, or is it read as a current state?
I mean you'll receive that attribute about a port even if you get a completely unrelated to MRP
notification (e.g. about a vlan change).

Thanks,
 Nik
