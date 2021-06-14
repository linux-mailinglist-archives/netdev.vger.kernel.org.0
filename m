Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93853A6791
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhFNNUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhFNNUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:20:06 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABFEC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:18:03 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id b205so7422500wmb.3
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZTA57oOz8Cdz7Ap0zeagZ1NVaajdzSi2IzO+/mv1lRI=;
        b=FarIWjuocwFevFTICawiUlOPLBkN2IDCx6tamjQ4Uvo82pD/sTH1drfgDw5Ih7tNu9
         PifDWuz4jhapKG+nwMQI/byFbG1qKJrHhzsg5p2R8SSO3huy9fwZowADDIQ8X3thBXBH
         keCY+l87rrat6v4mfdoFQ9N0Lvw1XvOxRrXh5+2p8OKQ1RawRAfAj56zPBbIl2wC7DVm
         0Cz6OcZ0MMUxzn2diYQANRXndxzk5tIxQwNkFDg6TMM/T+sw6lgS5a6B7zSab7uOQJYT
         rfvhQ5dLjv5ZDrFqbWHbJw4E2MeKb0etToK/FbesgqlwgZzIlHn7SJjG4HDlcRWjIXfh
         2J1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZTA57oOz8Cdz7Ap0zeagZ1NVaajdzSi2IzO+/mv1lRI=;
        b=RloFHMw8o5pfMyWqpWZBEYDb25FNfLGZ1mMdGGuFCaso7ZSpICEFQaDm+E8n0F3NX/
         HA3GifVI2hCEqJsENWKPU7qNtX8wny5YUF3qgXeVNphGiv/YPHfxmNtAo2OGrK7EfVe8
         MvSZN+cab+cnz/vHFP0QBoLXbPYeuNWtSkaG5KlpK2TJzeO4dFdHKU2fsM+j1Z56f3qo
         ifSQAo7i6nER+en09rGw+IjWEU0VcuAzk4lxaOr7c47ebak+nC/B7yhDrGDLc8/4D43s
         vDgp6iFEdykpRLh12cdjldjAcyfi//pkRpNcsFL3gOVkTtj43PgVQHwmWtY0N9UF7a/u
         4Fkg==
X-Gm-Message-State: AOAM533KiC/BC1rp0ofiv9xGgtGSRk8xkwcP/UUa/W1x/mdyhV7EP+93
        CqK3XYKwz556MXo2hL2/Sn50rssy60Gd+Q==
X-Google-Smtp-Source: ABdhPJzI5raTilhic38b/8STLJOYFtdiUsvq4un3+YbZDUVNkkFAx43hiKBHx78KUY8Dj9/Jk1ZuMA==
X-Received: by 2002:a7b:cb01:: with SMTP id u1mr33141372wmj.188.1623676682254;
        Mon, 14 Jun 2021 06:18:02 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:ddd2:2038:ae02:164a? ([2a01:e0a:410:bb00:ddd2:2038:ae02:164a])
        by smtp.gmail.com with ESMTPSA id n10sm16570348wre.95.2021.06.14.06.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 06:18:01 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf] MAINTAINERS: netfilter: add irc channel
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netdev <netdev@vger.kernel.org>
References: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9b60107e-dcd4-3ca0-f83d-0e51ccf5d67c@6wind.com>
Date:   Mon, 14 Jun 2021 15:18:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 28/05/2021 à 10:48, Nicolas Dichtel a écrit :
> The community #netfilter IRC channel is now live on the libera.chat network
> (https://libera.chat/).
> 
> CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
> Link: https://marc.info/?l=netfilter&m=162210948632717
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
I have no feedback on this. Is there a problem to add the irc channel in the
MAINTAINERS file?


Regards,
Nicolas

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d834bebf469..d9c7f8b5cae2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12649,6 +12649,7 @@ W:	http://www.netfilter.org/
>  W:	http://www.iptables.org/
>  W:	http://www.nftables.org/
>  Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
> +C:	irc://irc.libera.chat/netfilter
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
>  F:	include/linux/netfilter*
> 
