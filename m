Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEF73CA065
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbhGOOT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237214AbhGOOTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:19:24 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C911EC061764;
        Thu, 15 Jul 2021 07:16:31 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id l26so6749479oic.7;
        Thu, 15 Jul 2021 07:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4VxI2L0yDJbm1mdgu23WFwFGwDvtph71lznk9ZAf7ns=;
        b=iX8PYN7gHr/H92boVQFSkt/tEHrgmCZzcXEDnFwBIBvXzU7OxhsZqreKw+UjTPeArz
         nXnPxOdf3XeapIBKhGhAa1km67S2Hex3hTKPDq2K/ahDUlhZ+mc5K8M0m2ts4O1dOFa5
         vkkQr42eUR0o+cVgvKRzDG37AFZUV1dQA2k+dchmKyg6YAi2M1ebydlK3QXCfN2+UEog
         e7+ESF9mqeEK8TIcn2Qtv3ZnXXZcKZ2Q0wX+9vJFbqhh0tebhGfrqtGwhBYkb4jY2hkR
         UFFEGyQxtncwqYljGTRnhzbX+I5euxrYGI/GOXRsHp7QyhfJQcViGASVxoC5PUrxfCe8
         H6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4VxI2L0yDJbm1mdgu23WFwFGwDvtph71lznk9ZAf7ns=;
        b=W/b7ryH/CVPJ+8Nj9qYn0wLyqEtl1O9tFqdg12xlAbUAvq0487iU4lcVfzWUaGbZ33
         8+T5JUVtWfrW5N/NnI725Tcl9e0ioriE8Izf/KCFa3c1USkyHBNrNfAJi93hU+tAejKo
         moMz91pOxIX785tbqrvHmcrhQM2OnZeSlnV2nePkj8HZ+6X87cK9Gg/61fUT+GhNup9p
         ELCdqUfxb6JLI3n3rl7zCKqC6GRK7KpdsYgIph8xEbpC8mtzZavxkCM8JUfqYOThDDlW
         rZFI1UalILQcJuy5KV5X7ugRwmRdnLezmmiABHBXIBKrh7VIznUvJwTATWQqQK743AER
         CssA==
X-Gm-Message-State: AOAM530NRtSqXUvc1FSroBBRT0142suo13Ql4hD1DkNOw371/04wLmbQ
        dK1stmGrgUDXnnltCbEPgwc=
X-Google-Smtp-Source: ABdhPJy/b6gtbTS1t6QfL9RXPPvNQQChgDPlcuKFIdFVILXHlSuVNWPoWfknIpXHkhY8SDvfKMQmfA==
X-Received: by 2002:aca:bdc4:: with SMTP id n187mr3878062oif.169.1626358591289;
        Thu, 15 Jul 2021 07:16:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id b10sm1251418oiy.4.2021.07.15.07.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 07:16:30 -0700 (PDT)
Subject: Re: [PATCH v2] net: ipv6: remove unused local variable
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rocco.yue@gmail.com
References: <20210715042034.6525-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <20986885-73a5-8e58-0eb9-54b0723467e4@gmail.com>
Date:   Thu, 15 Jul 2021 08:16:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715042034.6525-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/21 10:20 PM, Rocco Yue wrote:
> The local variable "struct net *net" in the two functions of
> inet6_rtm_getaddr() and inet6_dump_addr() are actually useless,
> so remove them.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  net/ipv6/addrconf.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

a v2 with no changelog. From what I can tell the only difference is
"net: " in the Subject line which is not what I said in the last email.

Let me try again: There are 2 trees - net for bug fixes and net-next for
development (anything that is not a bug fix). Each patch should specify
which tree the patch is for by putting 'net' or 'net-next' in the
brackets ([]). This is a cleanup not a bug fix, so this patch should be:

[PATCH net-next] ipv6: remove unused local variable

and really that should be

[PATCH net-next] ipv6: remove unnecessary local variable

If you send more versions of a patch always put a changelog - a summary
of what is different in the current patch versus the previous ones.

No need to send another version of this patch unless you get a comment
requesting change, or the maintainers ask for a re-send.

Reviewed-by: David Ahern <dsahern@kernel.org>
