Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121244A90D6
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 23:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355876AbiBCWsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 17:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355873AbiBCWsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 17:48:30 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46703C06173D;
        Thu,  3 Feb 2022 14:48:30 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id i62so5266838ioa.1;
        Thu, 03 Feb 2022 14:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NPWueLzrJFboH2nkL8a0Kt0j0fw6ZnAd3HPnO4FSgfI=;
        b=nNf9+fu88OwLVGrq/dioOKFvP8s5k1wgcmIA0VUpL0g/hy3TXFhPHc3wyxof87N4DL
         S9dL8n744p7DgMvaszLhpk9UVzZlvM5uJiSCAVoNXKxZRhHRCZ5usgYm+ADuK5wBJ7S+
         ZoQ5hbKvmmwCIaIw1VDnkp23h88AIQsgGO3ay9gXodcD/FyRXW5eWSQ90mj7/VLn2pw3
         +kJE5ubZEPHAr4k25BXA/C6+fQBvBdlewAVTX4AYxKrxeu25bhW/gpAK1IjjTJkq43AV
         3qwzE/xtfapMQtuJxxyieb3Bv4dnGSY36SyNzXCnQqwQebVz2GG0UPbms3eFfpfeVZDe
         Zj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NPWueLzrJFboH2nkL8a0Kt0j0fw6ZnAd3HPnO4FSgfI=;
        b=T+7P1yUOKJOH3grwPntv8eRb+GSdk8oFsPAz915c083Ga8edww92z2mQBfAvFF6OXd
         hBTvJl57/poULFw9gvJoolJN2TIDdBm8eMQsHbsBuFGHQyVAnCBAjGqxT0THfqKEYy+A
         aoHki1mRVTq+yDSUTgFOJ0LcaEbpLsqJ6ncbY/OpiTNKb4uptyojaYKlw0UWqeSSx4Rb
         I/xgd+0FmQCt70HaflyQNXE9YRJZiIGspuLyixMCm3oUoQvw8t1Ka32Xoq7H++1b51cV
         DIusnwtzcaTprV2WRYDJdx5OMwd/DGXL+GiAPVjKxeX7DwqxcjaJPsDl+PxflteqI053
         Dg0Q==
X-Gm-Message-State: AOAM532IzcMknInscxo2gwISd9VL+/Ma8YSSHgzMiSjlii2QqW5Fmqep
        3GUbeQjp0UFjs6Mv5M0rNu75p01dU6Y=
X-Google-Smtp-Source: ABdhPJzLaSuHyHZqPOm0OepBhbWkNuI2kyqYoTEolXQTeVDEglvTAlTZmmCRq7UGOlLTNrZN6aVkfw==
X-Received: by 2002:a02:6d5a:: with SMTP id e26mr77543jaf.262.1643928509716;
        Thu, 03 Feb 2022 14:48:29 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id x14sm106528ilj.33.2022.02.03.14.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 14:48:29 -0800 (PST)
Message-ID: <df19b376-49a3-1ef2-0664-a23a48e128dc@gmail.com>
Date:   Thu, 3 Feb 2022 15:48:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] net: don't include ndisc.h from ipv6.h
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, oliver@neukum.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, stefan@datenfreihafen.org,
        jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org
References: <20220203043457.2222388-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220203043457.2222388-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 9:34 PM, Jakub Kicinski wrote:
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index 082f30256f59..cda1f205f391 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -15,7 +15,6 @@
>  #include <linux/refcount.h>
>  #include <linux/jump_label_ratelimit.h>
>  #include <net/if_inet6.h>
> -#include <net/ndisc.h>
>  #include <net/flow.h>
>  #include <net/flow_dissector.h>
>  #include <net/snmp.h>
> diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
> index 0a4779175a52..5052c66e22d2 100644
> --- a/include/net/ipv6_frag.h
> +++ b/include/net/ipv6_frag.h
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef _IPV6_FRAG_H
>  #define _IPV6_FRAG_H
> +#include <linux/icmpv6.h>
>  #include <linux/kernel.h>
>  #include <net/addrconf.h>
>  #include <net/ipv6.h>
> diff --git a/include/net/ndisc.h b/include/net/ndisc.h
> index 53cb8de0e589..07d48bd6c0bd 100644
> --- a/include/net/ndisc.h
> +++ b/include/net/ndisc.h
> @@ -71,7 +71,6 @@ do {								\
>  
>  struct ctl_table;
>  struct inet6_dev;
> -struct net_device;

ndisc_parse_options references net_device. This part seems unrelated to
the patch intent.

>  struct net_proto_family;
>  struct sk_buff;
>  struct prefix_info;


