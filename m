Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FBD2E815C
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 18:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgLaRLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 12:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgLaRLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 12:11:46 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA7DC061575
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 09:11:05 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id d189so22336666oig.11
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 09:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ePcgNf33XFHWON220pJ1/+i4UhOlknm11ciZSbOXD/o=;
        b=BIkFkinGKVFFYs1tUvA5mngC7aspkyr34YXvywRVOVz3AO4Pkfegnpy0B6ihczoWTQ
         oHcD+A6N+r5Ym/8v8aORepmVnQeKZrmbphj9Bl4jyeJjMw4hiu1mOjlItdkzz4ow9X0S
         4TlEQqE9hpT8cfa7nTQFXy7gAkmgxDY60B41J3AnLZfdBrcHCsdRws1IHA1ApvmLQJrG
         qf1Sy28tKyoUOYdJMbzWiywgY56vFXXcWWou1sNiHoJForpFj66BQ7zb8079VR2yJ0n9
         PyQ5KHvsA7Ynkcu4G4k6qtry/Hv8Z3NSsCo1qEtmMdddfyM6HC+vk+nielU3pdQREK5O
         JKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ePcgNf33XFHWON220pJ1/+i4UhOlknm11ciZSbOXD/o=;
        b=jckimaAmfGa2HonJ2y0TCmskOog81DkahcAU9YXOmf/5tKJ6m8VyY7Z26FbpFeElOV
         qGoAoMwH3yUR7iubqqLzPKGg0/Ki0+gk1ScqNjiv7G4GldyY/sDgGp3yEijYCPAf91JY
         +j99OhJgj0oeojokKOOd76mw35gpc1QOSZvrzjAiFLj6ohPxmIOMvjC79/t0dZaRYRAA
         R+ET58TIo2u/RH91+wS0PdM4HP7muBXjFoPPaT3rHN+W539FJakF5hLHF3U+jfk9bEvB
         1yS2LUhaSaidhZUSyDegWiPnlIQSzIUNUvlyPi+CSdRl4pZk3HAm/+zQayedN3Vj7x+B
         YCaA==
X-Gm-Message-State: AOAM533nBLvMm7x14C4Jjoyskaa3Vfvdkuz5E0aWfCAnUQGvcSsLjRCv
        jmjxQRPRa74xebsVdVCFxt0XYMwsPN4=
X-Google-Smtp-Source: ABdhPJwbz4ayIuV7P0j6dmaNg9tBD4CVtbi7E9nr5Yt3KwUC6dvCNvk4tGoUx9aYHAH0nwMyZNYaRA==
X-Received: by 2002:aca:3b03:: with SMTP id i3mr8491571oia.170.1609434665450;
        Thu, 31 Dec 2020 09:11:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:98e1:c150:579a:a69c])
        by smtp.googlemail.com with ESMTPSA id 186sm10560708ood.6.2020.12.31.09.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Dec 2020 09:11:04 -0800 (PST)
Subject: Re: [PATCH iproute2-next 7/9] dcb: Support -n to suppress translation
 to nice names
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
References: <cover.1608746691.git.me@pmachata.org>
 <9a23b6698bd8f223f7789149e8196712d5d624ae.1608746691.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8ae5ec88-937e-2e05-b0f2-a99c72e74a06@gmail.com>
Date:   Thu, 31 Dec 2020 10:11:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9a23b6698bd8f223f7789149e8196712d5d624ae.1608746691.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/20 11:25 AM, Petr Machata wrote:
> diff --git a/dcb/dcb.c b/dcb/dcb.c
> index a59b63ac9159..e6cda7337924 100644
> --- a/dcb/dcb.c
> +++ b/dcb/dcb.c
> @@ -467,7 +467,8 @@ static void dcb_help(void)
>  		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
>  		"where  OBJECT := { buffer | ets | maxrate | pfc }\n"
>  		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
> -		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
> +		"                  | -n | --no-nice-names | -p | --pretty\n"


iproute2 commands really should have a consistent user interface.
Unfortunately -N and -n are inconsistent with the newer commands like
devlink. dcb has not been released yet so time to fix this.

devlink is the only one using the horribly named 'no-nice-names', and we
should avoid propagating that to dcb. At a minimum it should be
'numeric' which is consistent with the others.

My preference is also to have dcb follow ip and tc (vs ss) with '-n' to
mean -netns and -N' to mean numeric.

