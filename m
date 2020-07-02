Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A573D21207A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgGBKBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGBKBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:01:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38FDC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 03:01:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 17so27168317wmo.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 03:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=P8VRDASVxiHXInnBJtuHCeHYaC40885qiMW2neBVGgE=;
        b=QS1Ajp3cV7aOZj2W/e8M7r19JKqzcKjR9Nbbui47IRXJsgYLKZYFd18KBNAHM/1Xh6
         kKAurfe2x5ZGNsjp8VGOXf+rzXBnax/oYbBY3V1KXhHZ/Ay6pwqSM9xwHMcsAE2ii8FD
         7mScoEd8ZomV9oC0vYU/2nLHjjQ9QMnePWuo8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P8VRDASVxiHXInnBJtuHCeHYaC40885qiMW2neBVGgE=;
        b=hecXDXjqdESqt6TJ3hx/C/3/Tbj4ZOFS89bSaa7EEXOt9jpdfustO/qKxokSdyIFHb
         p35oUb9LskHYEnff9TH9NpvtGMD+Z/aIeNQ+NYrFeXocoz1EhWXVaUCQjYXbxv1AKm2d
         hXVfyVcViePUlzjSRKOkyHg+qCH6/kwa+LjADjQYqUgq0RWSxML517N5CXG5JUzuwte/
         WDE6Bt/z9Z0JOQ1qXqXmXIHU7q9uFAQPKtqn1WtNI5+dbBWxSenHawtHqIaKDjGbU4l5
         pW7cBL5bta/D6a8GGKF2+NJhKpfmfNUdwBYFxs1JKNTi60p85jbumR3YqeCOEEQ7a/xG
         7Low==
X-Gm-Message-State: AOAM531+guHGw4fa1Q79eR46XzC03MDFXurUzJ2WFwOLdUv4xj7kTKse
        EKHFFhuzyEzifJHws4z/oteYiweANGmO+g==
X-Google-Smtp-Source: ABdhPJzhkVTUIaRQdXBalg5IODovnlwavdJDf81WJwJeMaH242RWoZQ3g+wpVdJ5oER726YW8k2Egg==
X-Received: by 2002:a7b:ca43:: with SMTP id m3mr23750275wml.120.1593684090438;
        Thu, 02 Jul 2020 03:01:30 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g195sm10340168wme.38.2020.07.02.03.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 03:01:27 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/3] bridge: uapi: mrp: Extend MRP attributes
 to get the status
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        UNGLinuxDriver@microchip.com
References: <20200702081307.933471-1-horatiu.vultur@microchip.com>
 <20200702081307.933471-2-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <4b46f59a-2676-6efd-fddf-c0fcbebdce0f@cumulusnetworks.com>
Date:   Thu, 2 Jul 2020 13:01:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702081307.933471-2-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2020 11:13, Horatiu Vultur wrote:
> Add MRP attribute IFLA_BRIDGE_MRP_INFO to allow the userspace to get the
> current state of the MRP instances. This is a nested attribute that
> contains other attributes like, ring id, index of primary and secondary
> port, priority, ring state, ring role.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/uapi/linux/if_bridge.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index caa6914a3e53a..c114c1c2bd533 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -166,6 +166,7 @@ enum {
>  	IFLA_BRIDGE_MRP_RING_STATE,
>  	IFLA_BRIDGE_MRP_RING_ROLE,
>  	IFLA_BRIDGE_MRP_START_TEST,
> +	IFLA_BRIDGE_MRP_INFO,
>  	__IFLA_BRIDGE_MRP_MAX,
>  };
>  
> @@ -228,6 +229,22 @@ enum {
>  
>  #define IFLA_BRIDGE_MRP_START_TEST_MAX (__IFLA_BRIDGE_MRP_START_TEST_MAX - 1)
>  
> +enum {
> +	IFLA_BRIDGE_MRP_INFO_UNSPEC,
> +	IFLA_BRIDGE_MRP_INFO_RING_ID,
> +	IFLA_BRIDGE_MRP_INFO_P_IFINDEX,
> +	IFLA_BRIDGE_MRP_INFO_S_IFINDEX,
> +	IFLA_BRIDGE_MRP_INFO_PRIO,
> +	IFLA_BRIDGE_MRP_INFO_RING_STATE,
> +	IFLA_BRIDGE_MRP_INFO_RING_ROLE,
> +	IFLA_BRIDGE_MRP_INFO_TEST_INTERVAL,
> +	IFLA_BRIDGE_MRP_INFO_TEST_MAX_MISS,
> +	IFLA_BRIDGE_MRP_INFO_TEST_MONITOR,
> +	__IFLA_BRIDGE_MRP_INFO_MAX,
> +};
> +
> +#define IFLA_BRIDGE_MRP_INFO_MAX (__IFLA_BRIDGE_MRP_INFO_MAX - 1)
> +
>  struct br_mrp_instance {
>  	__u32 ring_id;
>  	__u32 p_ifindex;
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

