Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C601285A52
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 10:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgJGIVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 04:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgJGIVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 04:21:24 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B44DC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 01:21:24 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n15so1102118wrq.2
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 01:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zd/E/JMvNyL5IHVPifyXLUZ5n8AMRVkFyGYTVNw04LA=;
        b=AeMhy1Kj+u6jPSo+Pex3GETjm+tKi/q/LqkgxXiGX72r5Sf0JfZZA4fGajWWidwrzt
         9Fm7S3P+5v6tFCZqS/ngKkcsiZTf5UzettXmUt+7g/rcvAsBhzpeGHjRF3aD76OY7HyI
         h9VCeumdobQmhczDHwCK5J+SzMmSvf+iO/fjHoQuXvIOoh+A5BlvpNb8/HF3O+Nv1xsf
         ukjkm4E/awRatMq7NgvwLvRF9GzKOx85sO16877K94mWPHOINuEa+3Xmgaw2WrDB1IwJ
         S5aYR8ElK1gLbEKYlfjXf46+rPIw4ESIE8z/+P53ZwhPFyNUWinqiZZV24WBqx0YZiCl
         CgXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zd/E/JMvNyL5IHVPifyXLUZ5n8AMRVkFyGYTVNw04LA=;
        b=r+h6NrtCJoaBW3SQ8Uo6vao4jpGBq1Spn6Oy+2rHdQkWBhZ7260y6Y4MPp3uk4kHKs
         7vaidd7YZTW7ru0Z8wIImbCddpupos6ruvq1L8FAYD2LlwhbXZdHQcWp7tipLxES/BCf
         5br8DNntlk+Aaq2utP6HvS/3lNtg8IKG05vs3DtsLJJhFWNqxyswO9dlOrTURUl78XsJ
         hB7/fVD95X7Z0oGWpRBIhNr4r3c4v8xBxra5zXux9J3EVuJs5akld61rb/HdjE6V8A71
         6c3+Q9DGKqKkv6pgI7vCyyZ47FtgNpa4JmwZI5s8Qzp/prqlRFKwrrYFzLW4bfcQBlJH
         8laA==
X-Gm-Message-State: AOAM531/ewWKfz3ESPXBbBYciLAwcTtnAmmW/6MchmJ3ePF1I0auPyfl
        B+HkPap/i/Dxg2pRRyav17aAPbe9NPk=
X-Google-Smtp-Source: ABdhPJwCscporiKc1dPxK66Dnai2G/QoP352X2MQlTqUmTnZ8/gFfv3Uh9EDyaN3wYOBb5RWxwg9dw==
X-Received: by 2002:a5d:634d:: with SMTP id b13mr2215074wrw.324.1602058882315;
        Wed, 07 Oct 2020 01:21:22 -0700 (PDT)
Received: from [192.168.8.147] ([37.172.192.62])
        by smtp.gmail.com with ESMTPSA id n9sm334446wrq.72.2020.10.07.01.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 01:21:21 -0700 (PDT)
Subject: Re: net: Initialize return value in gro_cells_receive
To:     Gregory Rose <gvrose8192@gmail.com>,
        Netdev <netdev@vger.kernel.org>
References: <e595fd44-cf8a-ce14-8cc8-e3ecd4e8922a@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9c6415e4-9d3b-2ba9-494a-c24316ec60c4@gmail.com>
Date:   Wed, 7 Oct 2020 10:21:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e595fd44-cf8a-ce14-8cc8-e3ecd4e8922a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/6/20 8:53 PM, Gregory Rose wrote:
> The 'res' return value is uninitalized and may be returned with
> some random value.  Initialize to NET_RX_DROP as the default
> return value.
> 
> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
> 
> diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
> index e095fb871d91..4e835960db07 100644
> --- a/net/core/gro_cells.c
> +++ b/net/core/gro_cells.c
> @@ -13,7 +13,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
>  {
>         struct net_device *dev = skb->dev;
>         struct gro_cell *cell;
> -       int res;
> +       int res = NET_RX_DROP;
> 
>         rcu_read_lock();
>         if (unlikely(!(dev->flags & IFF_UP)))

I do not think this is needed.

Also, when/if sending a patch fixing a bug, we require a Fixes: tag.

Thanks.
