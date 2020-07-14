Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09CE21F233
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgGNNOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbgGNNOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:14:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF0DC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:14:46 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c80so3200995wme.0
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=g2EyQlAqpHZO5s5qqHKlAo11WIHmOqc0rUAshNEUl2M=;
        b=borORmurH5EPJJNnd7Lhs3GNt3l3WCLMftWORGj+zrxXvkT3GSAjiw6lXlF54+CB7A
         W1bX0hSTU76d2ShMudHT/6fsfXkzmfailabgVc3MOvvjv5zJX+ncFsfpxvejGZW84o8z
         3er9h9m7CAECayAUE5SjM+MucvuPrewYpQU2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g2EyQlAqpHZO5s5qqHKlAo11WIHmOqc0rUAshNEUl2M=;
        b=Uuu8n70cWmUZCJCa8qhQD5VabvcankQGgXgRNiaN3K/uPWH7X7lGHrADxKq7hIUrci
         Zo4+xs0UpQqzjPo0gXyagWzekgwhF1057n5eyH1b2JlD/ZCpRrd6REjSSQR3oeNY64Wh
         kh9Sou4VH5EPa9sk+VkfC3usknAebisdbBXmwJvZitVOwaPB65ZSKfA9S5+g5z/IJVyB
         J5dsqH3vG3JVWl6evarZIAqhmTEyYRCleNrfBWDaJMptw53Uzjo9oB8i/zoDajJLGdMD
         qEV4Z6LfbktjP09AJO7oPrgAngA9msWiXOToDTa1f3QstCqy50D5nG+xd5c5r+FB5Lq1
         PVfA==
X-Gm-Message-State: AOAM530WI04aW/CC4vxOTdQw7wSwaPkRBiWVlzx43AUAW0XRIrdNktT0
        WMWyHFfXJ9FEvxeDh0HY+AHwzAcWa756/g==
X-Google-Smtp-Source: ABdhPJwatvSqQbprk1c/oMEOGLR0UWtFeqVkvmelzVPpnXp5yBndiAquQQFvlNxWRQHf/rPgoJxbig==
X-Received: by 2002:a1c:d8:: with SMTP id 207mr4303796wma.81.1594732485190;
        Tue, 14 Jul 2020 06:14:45 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f14sm32074246wro.90.2020.07.14.06.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:14:44 -0700 (PDT)
Subject: Re: [PATCH net-next v4 03/12] bridge: mrp: Extend bridge interface
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, ivecera@redhat.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-4-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <e877ca40-8e84-ed05-f455-369ca43a179d@cumulusnetworks.com>
Date:   Tue, 14 Jul 2020 16:14:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714073458.1939574-4-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 10:34, Horatiu Vultur wrote:
> This patch adds a new flag(BR_MRP_LOST_IN_CONT) to the net bridge
> ports. This bit will be set when the port lost the continuity of
> MRP_InTest frames.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/linux/if_bridge.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index b3a8d3054af0f..6479a38e52fa9 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -49,6 +49,7 @@ struct br_ip_list {
>  #define BR_ISOLATED		BIT(16)
>  #define BR_MRP_AWARE		BIT(17)
>  #define BR_MRP_LOST_CONT	BIT(18)
> +#define BR_MRP_LOST_IN_CONT	BIT(19)
>  
>  #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
>  
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


