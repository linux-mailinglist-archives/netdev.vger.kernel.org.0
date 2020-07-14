Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2F721F26F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgGNNYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgGNNYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:24:36 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31CAC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:24:35 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a6so21557975wrm.4
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2sXAyH2m1w6ieNvR8PlkbC1BL11rhRAw2ti7qH59UIk=;
        b=Kl2lrL3Abc1ANv3aD2FNLXwqQb4N0zaedWW+aDbDZbBcq+z8HoFtGrJhEQyeNVKJVW
         T1ts0UT2jqRDOVwPTO1wBEJvKRGWtU/gjBbV92tCCDrj5HgYjA7QGmlv5mEFVK3919ll
         rzQEzgwilHSVIiERhHPpxgdROpeCO2i9V1Qm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2sXAyH2m1w6ieNvR8PlkbC1BL11rhRAw2ti7qH59UIk=;
        b=DX08QHzHyGNowRqzs3pEKE6/ZNQChWwVTqZ463fKsViQV5tDzu+5UUeTO9irtpJufr
         gq/D873+Z6XAYuIsd56ziovu/E0y9yA+vAG2ROotLCLXgQO3whTwnE1lyK6yodAelHNJ
         G7Es26OnjUY6/yZQJmvXU4ZMClpsxGbPiJljmB5fT2rhaVlrR7hevQOTPl+dhEaTVmwZ
         72PX+Lyse4mMMirQVcQHaE+d5/5/oOMn9pkFZQTYM68gKtI1IzyOgQfI6hLht+9W3qae
         utysokVrysE5gY1U7GDK4zAyaNwsYOQkwVEDnCgjbdXgLkvd0tL1bydR3ZVcaTEp69GU
         xd6g==
X-Gm-Message-State: AOAM53021W5ul3VZVV1W6QP4Cw9baWct2hprK9n7b0+FIAoPC7aMa2P5
        HEHszYRjEbbrK3ExZpdEA7mr8w==
X-Google-Smtp-Source: ABdhPJwyV3o8PVnSWMM85wj0QBr9HZqOJ+FQSFUpgZleNIYi2CNzHvbFQy2EqHJQ/fw87gKc6/tWMg==
X-Received: by 2002:adf:ff8d:: with SMTP id j13mr5353827wrr.11.1594733074655;
        Tue, 14 Jul 2020 06:24:34 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id p4sm31152963wrx.63.2020.07.14.06.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:24:34 -0700 (PDT)
Subject: Re: [PATCH net-next v4 10/12] bridge: uapi: mrp: Extend MRP_INFO
 attributes for interconnect status
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, ivecera@redhat.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-11-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <d30bc0f1-b64c-2bf1-fb0f-7ba1f190c4b9@cumulusnetworks.com>
Date:   Tue, 14 Jul 2020 16:24:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714073458.1939574-11-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 10:34, Horatiu Vultur wrote:
> Extend the existing MRP_INFO to return status of MRP interconnect. In
> case there is no MRP interconnect on the node then the role will be
> disabled so the other attributes can be ignored.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/uapi/linux/if_bridge.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index d840a3e37a37c..c1227aecd38fd 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -243,6 +243,11 @@ enum {
>  	IFLA_BRIDGE_MRP_INFO_TEST_INTERVAL,
>  	IFLA_BRIDGE_MRP_INFO_TEST_MAX_MISS,
>  	IFLA_BRIDGE_MRP_INFO_TEST_MONITOR,
> +	IFLA_BRIDGE_MRP_INFO_I_IFINDEX,
> +	IFLA_BRIDGE_MRP_INFO_IN_STATE,
> +	IFLA_BRIDGE_MRP_INFO_IN_ROLE,
> +	IFLA_BRIDGE_MRP_INFO_IN_TEST_INTERVAL,
> +	IFLA_BRIDGE_MRP_INFO_IN_TEST_MAX_MISS,
>  	__IFLA_BRIDGE_MRP_INFO_MAX,
>  };
>  
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


