Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D6A8C3F6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfHMVwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:52:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39925 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfHMVwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:52:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id i63so2700844wmg.4;
        Tue, 13 Aug 2019 14:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Aq+Y2GhebEKnLBnrxQhotqb+IDj71O/k31BTDDdJ94c=;
        b=CpmOQTlBTp4oKABypS3aBgls/6oK6Kwi/RlPNB6D9pLZvAG+x6JOmW6O5ArUQg3/tq
         /JGLy5u72qq5Gnum9haNKtMN9Em05dviEf5tL/FZJSQn4KgiFCDKSYy6MuZAK5PZBrfM
         aurYzQg1X2V4YA4wYnlquLAKESp1RBLagEvlOPj+Gaw4NC7014GoY5hpgjVHkJrJBmBV
         qQRjA4PU607GOO/+Y7rTg840JQValwoVZ/bAFXVv2+Uo+Esvn3xDYXFab70PK7DHLrG1
         /o44k+qFYWf+uLtj3TEBS1eoRPsU/rxTFftqSucA8zb3F7cdQCu0pyWXjJ3UBoGHOmfG
         +55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Aq+Y2GhebEKnLBnrxQhotqb+IDj71O/k31BTDDdJ94c=;
        b=UtknEb/dpXyftUMKaNIyPvrwegBzrO/B7aoMowY/eBz7s92k4yuhPrhQbyLNL4iX5b
         L6R40ySrZEgWOGgaRb80rv7DMTLf75PmXZowzljMO6YbMhreMs3oXitz0fBD6CE//AdD
         +jQdBsX0ySUWeFlPNBk4hLWrQ8tJ4y/ieG5vqywBf6Q+znHXmLaTmXyz4LipPBsAz1ny
         HAEINXQjHUrMHOAUt1vxm6uATs1HNTMi9k3xRhpgTJW8SNJ8lYnEi6qgHLUmIPEmwvak
         cW+mJNE2NW06/P0SAzrDtfHltK6TfWhhuuiOBl8dsYzySQ39SF8GCe+4Ry8j+m+Ja7T+
         b+pg==
X-Gm-Message-State: APjAAAXR75ZknkLW1HyYPJ52QAUHqbyeIkEB1WD2P3N937654ZDkFiUG
        ckyur2JSKpTXLL++AHGn6zWskZOs
X-Google-Smtp-Source: APXvYqwYnbR/jrmC7swOOoNJx78NLELh0rDowKVHL2lNer6mbgViai3DyldbLMPnpFs1vPX0XSXPbA==
X-Received: by 2002:a1c:f106:: with SMTP id p6mr4556035wmh.148.1565733132831;
        Tue, 13 Aug 2019 14:52:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a? (p200300EA8F2F3200E1E264B7EE242D4A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a])
        by smtp.googlemail.com with ESMTPSA id a18sm7039606wrt.18.2019.08.13.14.52.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:52:12 -0700 (PDT)
Subject: Re: [PATCH] MAINTAINERS: r8169: Update path to the driver
To:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org
Cc:     joe@perches.com, nic_swsd@realtek.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
 <20190813060759.14256-1-efremov@linux.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <69fac52e-8464-ea87-e2e5-422ae36a92c8@gmail.com>
Date:   Tue, 13 Aug 2019 23:52:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813060759.14256-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.08.2019 08:07, Denis Efremov wrote:
> Update MAINTAINERS record to reflect the filename change
> from r8169.c to r8169_main.c
> 
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: nic_swsd@realtek.com
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Fixes: 25e992a4603c ("r8169: rename r8169.c to r8169_main.c")
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 99a7392ad6bc..25eb86f3261e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -183,7 +183,7 @@ M:	Realtek linux nic maintainers <nic_swsd@realtek.com>
>  M:	Heiner Kallweit <hkallweit1@gmail.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	drivers/net/ethernet/realtek/r8169.c
> +F:	drivers/net/ethernet/realtek/r8169_main.c
>  
That's better than before, but wouldn't cover e.g. changes
to r8169_firmware.c. Better may be:

F:	drivers/net/ethernet/realtek/r8169*

>  8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

Heiner

