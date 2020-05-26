Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB0D1E28C5
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389603AbgEZRZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388803AbgEZRZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:25:49 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD60C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 10:25:48 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id r16so1014568qvm.6
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 10:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HCeYsFNN1JoA0Ezw3kmNBtdHR734UXIEdjyoCma0iUY=;
        b=T6/wXgT3C5iFKrtztX31kDanIFGJrBi/0tXnanvOp5kN5Uec8d11tHfpknWWVx9QtY
         KVnDRdG9RBz1+XqV/9z9EUDFLxQUamylqZc4lJYMLYWnA8elkTiH7mlISgw3IrBXEMXl
         f4Vzz4Krcsx6MfqSQrk+h734N8Zedl7ayIkroGZHyG2X+2X1PRIaDFFtOWGp3FKn3fI4
         4ktd6ZN4/aRaxH4wb2xz5Xsp8yxJnjln7jqLgvZLTgXrc5AWwSnkb4qBvs+bSVP8HVpd
         tRcgGJRxcYmrd0X+mebm7XAYMD/UUDse1qw8YSOOXPV02pRWxKCDZuHO7pyCY1nadZfJ
         b4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HCeYsFNN1JoA0Ezw3kmNBtdHR734UXIEdjyoCma0iUY=;
        b=TkPkg7hbiTr17jPSNba3YM5Ppw2H1CBU353usRtyLeZzk+OVBqGg8pmqhbR0iq7+lC
         LP//QXf0yaFrZUzOB1cgpf1WqSOtyI2gojvOXXSy/tqfDbNI0yYlxLeDHWzKiBN59OkQ
         /G8RN80RHjybCulI1Y+Zw/EBHgoHlWWTtk+2BL8V1vq8LncaRKlMSV1fI9RncFlaPcfR
         RbEU2I+9TIUuE4ti4pUxry4tQ/C14PiayauU6qw5PsKaxBgZpBvnVKeW7P+XIRdaa9Y0
         1aNAXZAQoXSPrcwjfsEDN3HpTA6dBi+TzjgOE+cZ7LRB4imcPWQvPBZ/XHdFMoKfdnoB
         3uOQ==
X-Gm-Message-State: AOAM530LMATs65iaZv0PM2c0Y+CKaUdV9SqoyxE3MMujBCUN4mW9juEi
        t4bG+2gt2B0/LejnC+NvDfU=
X-Google-Smtp-Source: ABdhPJz2w7cE/nj7vJ1sTA4Xqau9Y2bH72Gd1sNxdNv+Y1rH+gy7FMTrm/nN9AX9uJhfcn+Lkkuv9A==
X-Received: by 2002:a0c:e904:: with SMTP id a4mr20942157qvo.94.1590513948083;
        Tue, 26 May 2020 10:25:48 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id x1sm256793qts.63.2020.05.26.10.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 10:25:47 -0700 (PDT)
Subject: Re: [PATCH] net-next: add large ecmp group nexthop tests
To:     Stephen Worley <sworley@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, sworley1995@gmail.com
References: <20200526164804.477124-1-sworley@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ee1efba2-8123-3250-a4d6-9404b8280314@gmail.com>
Date:   Tue, 26 May 2020 11:25:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526164804.477124-1-sworley@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 10:48 AM, Stephen Worley wrote:
> Add a couple large ecmp group nexthop selftests to cover
> the remnant fixed by d69100b8eee27c2d60ee52df76e0b80a8d492d34.
> 
> The tests create 100 x32 ecmp groups of ipv4 and ipv6 and then
> dump them. On kernels without the fix, they will fail due
> to data remnant during the dump.
> 
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 84 ++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks, Stephen.

