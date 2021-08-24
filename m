Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557163F571E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhHXEWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhHXEWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:22:39 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABF8C061575;
        Mon, 23 Aug 2021 21:21:55 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 17so18599195pgp.4;
        Mon, 23 Aug 2021 21:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rvUZEnul7L55oPOZwCk74JuCeMARhJs+Derj0KICpk4=;
        b=Mifi4PxvNrStTcYMda/GNUxbl+R6IKnl8c/lfERHWhYd1Ow0kyN5vUUVq0rEYl67BQ
         FdobDS4QzE84E47T6oyl7idcj/gVPNfZJg+aTt6BX247neJKR2xsVMYjtdaBjOApZT2p
         ltRoqrNZ/ahqXIPNbUCANgMLdf/V3vR4PI08/gZUtQgc7ic/akJzBjPAdaT5Rp5M4A4I
         1Yiim6IHTGk9q/Qcosc8os7ecgl6hMyn72ck5QKqEJfX4c7/n2CmGIHi2szndIfwErWk
         qRrAlN7Jt5fcRJYqUjasvT2kr6bTgGPUsTb4GuWrzQJiS5VwpV77wnWrlI/muvNC3Nd9
         i/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rvUZEnul7L55oPOZwCk74JuCeMARhJs+Derj0KICpk4=;
        b=Ah/uGrbJGeT4D0UfRmTYblZwqb4rk8cEPjrPLEwZaGt0yJG6ZMASL6h2KjXhPkN3db
         PYKmggP2itnVoNlfX/9UdD+st/4tjHBxbrETz6R7V0azI0pJ3iuqaG3NzAHCp3SCPb1T
         U4RaXFC06FfmY90oiu9yu8/JgnR3s/56p1RQ6QhCOk+7SItCLP/e5CIoWVUdFYDzelK2
         fwSYwdIO0Ew4YmWXaFkimQkjt3otWQvfNJ89zMHY4BtRRNfZo2AEYlvCh2422XdjP7DW
         T9UJwyiy1zEMz8YF7lieijoGJtz+ICws30E6qVQql8LLkrn86b840l0jmnqQAtiURy5/
         QPjA==
X-Gm-Message-State: AOAM532l8ytJZHXNLL8l7dtcE+E4E1u2UQ//v5IUZv+yGFjHfkLtxkLV
        Fdnups/OhbLj9amojXO0w+W1XIW4Cb0=
X-Google-Smtp-Source: ABdhPJyDTjcKkG/a2++YExktMk0LJZqv0DINEyHSGdALteGFnMPr32jrRluH/h4z8mbSDt9Mp8iG1A==
X-Received: by 2002:aa7:8c19:0:b0:3e1:4b9e:cf89 with SMTP id c25-20020aa78c19000000b003e14b9ecf89mr37447540pfd.58.1629778915211;
        Mon, 23 Aug 2021 21:21:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id 143sm17253748pfx.1.2021.08.23.21.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 21:21:54 -0700 (PDT)
Subject: Re: [PATCH] ipv6: correct comments about fib6_node sernum
To:     zhang kai <zhangkaiheb@126.com>, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210823034900.22967-1-zhangkaiheb@126.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e5cf1e97-e6ed-5e55-2f40-6a04db4a0e1a@gmail.com>
Date:   Mon, 23 Aug 2021 21:21:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210823034900.22967-1-zhangkaiheb@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/21 9:49 PM, zhang kai wrote:
> correct comments in set and get fn_sernum
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  include/net/ip6_fib.h | 4 ++--
>  net/ipv6/ip6_fib.c    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 



Reviewed-by: David Ahern <dsahern@kernel.org>
