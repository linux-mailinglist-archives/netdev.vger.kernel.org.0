Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579438D2CA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHNMO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:14:58 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39495 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfHNMO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 08:14:58 -0400
Received: by mail-ed1-f65.google.com with SMTP id g8so666330edm.6;
        Wed, 14 Aug 2019 05:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8++ygTomekDr/huI6Na4UdsT69s4uO/+Jq9RiMWVYmQ=;
        b=JDbCh+W7ehDnya2jQSSfpfHQJVt5CxzYS+x81VvpuMzjk8aFYLyRIWQo+hMcOWO03Q
         Cvc3HTy9dNwhlREVYOHc4MDbLsh9ikt+ov+mrSmHNXpVDel4fW/ayZVlu31uMBx92vsQ
         YAlfS+6VJN7t2dwQdHgMd9YfmFzEC/SvFO4lIodH6JkvFriWAB4YEjiHNxDb27UzwW/l
         aJsAHeYvIh1MRN83F76Z0HxU5Ik8D6jiGnQypIeeBjN9RATgsZusfIw4/Js1OHWGwTxN
         4jSWLkv1rrYnEKIUxLPb48D2B7yhResn3dY135tD52Dg6gw+WodXNyehV7Jh9tHejBBi
         XTIQ==
X-Gm-Message-State: APjAAAU4JCn2j2kIVZULSGuOD3MpZU7rRnzr6q5j26hewMpZnPErtKIZ
        bEdLAgPEgsBSLa7+KVGQMJUE4s2mUnk=
X-Google-Smtp-Source: APXvYqyQbIwVHWA9ZPNr7gvMOUL6rocXBRlJdsTXSPYm4u76CU2xNrl9g5ZHmq3QBawHNEttYkDYjA==
X-Received: by 2002:a05:6402:12d1:: with SMTP id k17mr27223398edx.214.1565784896232;
        Wed, 14 Aug 2019 05:14:56 -0700 (PDT)
Received: from [10.10.2.174] (bran.ispras.ru. [83.149.199.196])
        by smtp.gmail.com with ESMTPSA id h9sm2084274edv.75.2019.08.14.05.14.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:14:55 -0700 (PDT)
Reply-To: efremov@linux.com
Subject: Re: [PATCH] MAINTAINERS: r8169: Update path to the driver
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     joe@perches.com, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
References: <69fac52e-8464-ea87-e2e5-422ae36a92c8@gmail.com>
 <20190814121209.3364-1-efremov@linux.com>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <9a92e776-9355-2c19-cd4a-49f0b0bad029@linux.com>
Date:   Wed, 14 Aug 2019 15:14:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814121209.3364-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, this is v2 of course.

Thanks,
Denis

On 8/14/19 3:12 PM, Denis Efremov wrote:
> Update MAINTAINERS record to reflect the filename change.
> The file was moved in commit 25e992a4603c ("r8169: rename
> r8169.c to r8169_main.c")
> 
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: nic_swsd@realtek.com
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a43a1f0be49f..905efeda56fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -183,7 +183,7 @@ M:	Realtek linux nic maintainers <nic_swsd@realtek.com>
>  M:	Heiner Kallweit <hkallweit1@gmail.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	drivers/net/ethernet/realtek/r8169.c
> +F:	drivers/net/ethernet/realtek/r8169*
>  
>  8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

