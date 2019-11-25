Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F4210952C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 22:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKYVf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 16:35:58 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39123 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKYVf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 16:35:57 -0500
Received: by mail-qk1-f194.google.com with SMTP id z65so9460334qka.6
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 13:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OWDjdGXmliN8qOQSgIVaBTm1qUf6x0RuNu3UXYs+OlI=;
        b=YGytedHBmDzicgZuhCzNvDI0uT59UeT/1lnfO7NCJ+b66rhmLuAqTD/ULG0Y2IsD6P
         3XwueWY6QC1PoRYCFek6tLtSFP4nb5selQCt+qxjsZDYlqx+n6fxEef0q1Co42rH5CQ1
         e1CiGhk6f7gixc17RZF6tFWn7lWZtqtZvIkv5iwLFZJjW2J1+5UFXTQ58Hj/6xf/g2RM
         SFtyvy6QOD7O44N9naDi7W15hkgmKuTCcQwLkKIQYPsv5KV8RaItSaSYm4I/OlYNobqh
         Qth0D6fdJvlaX2k4Oe9x7P/mhK6mQeFfLFwGpRue9xoiWjO6zC0rbVGFmQoqfgmb8w6f
         PUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OWDjdGXmliN8qOQSgIVaBTm1qUf6x0RuNu3UXYs+OlI=;
        b=agLs4Pplu85S7B7rvNYb7/s51y8YMs3UbfGGT+LZwvEh3JwcyW3sPyIeinFyYkvYi7
         odMwlUzgGlB1UTs1pm10kl9LEBQwV2dUxX40vluW2NSzOYVJfIyDX4FHFQGhPwTfRJDw
         4Pp0PTTF4bZm8aLOADTi2iRUUMNyqDSYmF8bIyLsop9g2Vtz5BjlsTijwkAK8j0xQzqF
         UrAX/HrUXvu233yoLQfBd1V0FJtEwvrxX6u0UKTi1ZEbqZnK8KIY9ayIwfrkBvvsnO8k
         8W0VFYijTLq00smWnxvg0MoBug6GMVDhCtGqv74qU8MILhVYUy72r0+3rEGkAvcjwx/T
         KFig==
X-Gm-Message-State: APjAAAXJIXHSmPgbYjH0Ud0+6LE9rTZH9e2JPCKW9xzAv7WEM6hXnOMr
        OT9alsT9a5EEGvc+94/houRIT7mT
X-Google-Smtp-Source: APXvYqxSVVYWCXhBZ5VoyMELIEJajxJ5/JdpkFDgT+58GbKvsA6ukfj7QDJi55jFF3hpw+VONjsl0w==
X-Received: by 2002:a37:a446:: with SMTP id n67mr15873601qke.299.1574717756494;
        Mon, 25 Nov 2019 13:35:56 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c06f:8df5:46f1:d3e5])
        by smtp.googlemail.com with ESMTPSA id o70sm4045366qke.47.2019.11.25.13.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 13:35:55 -0800 (PST)
Subject: Re: [PATCH iproute2] ip: fix oneline output
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
References: <1574611358-28795-1-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b0976170-8a27-320e-575b-43c5683ecf0f@gmail.com>
Date:   Mon, 25 Nov 2019 14:35:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1574611358-28795-1-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/19 9:02 AM, Moshe Shemesh wrote:
> Ip tool oneline option should output each record on a single line. While
> oneline option is active the variable _SL_ replaces line feeds with the
> '\' character. However, at the end of print_linkinfo() the variable _SL_
> shouldn't be used, otherwise the whole output is on a single line.
> 
...
> 
> Fixes: 3aa0e51be64b ("ip: add support for alternative name addition/deletion/list")
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  ip/ipaddress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
>

applied to iproute2-next. Thanks


