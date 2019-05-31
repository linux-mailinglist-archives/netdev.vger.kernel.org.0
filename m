Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D59F8314D2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfEaSho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:37:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44124 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfEaSho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:37:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id x3so1184579pff.11;
        Fri, 31 May 2019 11:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PHwU//Edg6CtCnygiexXNCP1ikg8FtWsJLc/VqorU9g=;
        b=hPrC9kRMavWG49Lgc6A2uejCIX5/APNvkA89CQ7u8fl8CuH3xImjME1i4m62qxTOk4
         AbOHIUTBu8g1D+eizGjUiRzWlhKLEh32Omtu7dzXJXkgLjvuml2IULCaUyxAzTncvnVS
         ljSejqIEbI+UDHMMCbkB+Z2dxfp5OCJj2wGH3t2G9QwFaBj8HdnDWN5PDH49y4ihqBxz
         3JzyqVzoeRL0AcFvHbB8HqlYypq06LfaaJAqRmMagyqn9oUFF8OMpxYasqkZd9nUFlwu
         3xaGCZJEi5PIWmQK5Ym+SqOnso8YaTeqnCO1209I2whZAuuWHEZXO0UzwDmxqzd9zyFp
         sbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PHwU//Edg6CtCnygiexXNCP1ikg8FtWsJLc/VqorU9g=;
        b=UoB1e4xYbpRmSRR3y7+VETUidQGCBXZtfYtoc5zEd5OPUVx+y7tsKz4qafL8ZQZJQ4
         pAC25dZz0LLaSJxAxAg1lTlC7SF8xHM8QKB/5T2CslSgv/GcLBRNGP6IrVv6DJNPJOGa
         9gOL6IFqYUPUzuA7QiBisncu2hK+vxRiQplVeVjeXDnCVJ64tfOS3okwWYfx+p2OQjxR
         XlektR595guCnvzJA4jUlcwOyM8cVjrAmvUaQG88QTr1yP/mjSc+XhIEqjFYSM/Kac0S
         gznmdpSXDAlVp/7xEhIT6PopaOWaeMh8iMXHQsK44Rxtih8VcaYMgdwgcMZz5XLoCOv7
         Vq5w==
X-Gm-Message-State: APjAAAVs0GSGcnUx7UGcsSXQ0HfjeYh/uXxBnP1IoEJ2znZeiE8oHk3U
        TN12kKf9Q99P4oRpVYr5NzDvq/yTg8g=
X-Google-Smtp-Source: APXvYqyKOWLYq3gW6N5AH7W0jowEQvskaY+7SBoKB5fR0ej0gZyRf5wRZmvg9aKPNigzpgmU5awvHA==
X-Received: by 2002:a17:90a:ad8b:: with SMTP id s11mr11510069pjq.48.1559327863485;
        Fri, 31 May 2019 11:37:43 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id c85sm1786973pfc.149.2019.05.31.11.37.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 11:37:42 -0700 (PDT)
Subject: Re: [PATCH][next] nexthop: remove redundant assignment to err
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190530155754.31634-1-colin.king@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <27d7fdc8-f2ef-6940-ec93-736c95e82cfa@gmail.com>
Date:   Fri, 31 May 2019 12:37:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530155754.31634-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 9:57 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is initialized with a value that is never read
> and err is reassigned a few statements later. This initialization
> is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
