Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2351D42C6
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgEOBLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbgEOBLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:11:08 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F10C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 18:11:08 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id d7so98380eja.7
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 18:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FxPFDod2gcEb80K2fhbVVwtOoC9Ay7UbJ/RTu43VUNc=;
        b=sPbAAstU7uXhEqZFKEOv3b2LuI9b7gbNImhlWycNnMZW5x6Mou4936x3i/d7FsYlFO
         TNHrJL+L8SyO25naydHSDomivIigtdAFt6JUM7jzRB3+GOwOT4HADKz9wL/w5GLpI5T/
         rApZy3rOzhMqULBJZjjgm+jV2SSk1ZmkqFOWTz7NV63Vnr6ZxctBnUIpDRFyGzfcSXTF
         dTd2NuWl/lqZXgISe5rZ44muKtUadmwyZMYGzootNimZullYIGSy6dtwh3qr5UzyMEIi
         7jVw4aZEjmBUZo++PaAEnNKokIPfBopsX227YleeAaY8Z7n/2+ly1HKdL/WE9iBcVxcR
         2gLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FxPFDod2gcEb80K2fhbVVwtOoC9Ay7UbJ/RTu43VUNc=;
        b=sLpucw7tzVKy0UBuCeP/KI4VyyIGAVNcHHQUSTg+m0k679CwC6aio5U3M6ja89VS+R
         d3pVTqZodKm6TGR6yOFbqNlB7hrtcEoFHN19noMuo+TMSfErt0cEdSmA17+2i4YwK1K9
         IM9tbjnt/+8795DTzxNXEXU13bZyV8G7pgQYq+jx8ApYbYZB3oya/BWRQEpyVUOts+QB
         BeW6TvzB1/pui+9AUp1ZofKydFgKC4KVLVFxunqOeFEItghC7ZEFK4HOM+6tj3tdiE+2
         zNIjrZPsoa47EkecK5lfIo7MiIBYQCDfLMIjNQPFsQKO74ffZX1gghBo9VvwKn4KmSqY
         pkBw==
X-Gm-Message-State: AOAM5322+1IvQaWIEm4XDoChZIhxrsLyPJyx1+tVgQLyaK+1HfgRYe5O
        FXs/MEGs9sh5NpiXZ8ys2t0P+cK0
X-Google-Smtp-Source: ABdhPJy8eJzUTYl4qQT9cI4p5YDtCdmiGVuJKj4XpT1abIKLfzY1/WZeCWETWOCMsEmSIBIKyi/JtQ==
X-Received: by 2002:a17:906:dbcf:: with SMTP id yc15mr672475ejb.176.1589505066541;
        Thu, 14 May 2020 18:11:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f4sm64838ejk.26.2020.05.14.18.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 18:11:05 -0700 (PDT)
Subject: Re: [PATCH] MAINTAINERS: Add Jakub to networking drivers.
To:     David Miller <davem@davemloft.net>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org
References: <20200514.131403.168568797789507233.davem@davemloft.net>
 <20200514212408.GC499265@lunn.ch>
 <20200514.180532.854900635490849048.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <79bab78a-4464-29e3-60ac-c8405e60ad5a@gmail.com>
Date:   Thu, 14 May 2020 18:11:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514.180532.854900635490849048.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/2020 6:05 PM, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Thu, 14 May 2020 23:24:08 +0200
> 
>> Now there are two of you, do you think you can do a bit better than
>> Odd Fixes?
> 
> Your expectations are really high :-)

I think Andrew was just shy of suggesting himself to be added there,
right Andrew ;)?

> 
> Yeah I guess we can put Maintained in there, I'll do that right now.
> 
> ====================
> [PATCH] MAINTAINERS: Mark networking drivers as Maintained.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4b270dbdf09b..2c59cc557f2b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11720,7 +11720,7 @@ NETWORKING DRIVERS
>  M:	"David S. Miller" <davem@davemloft.net>
>  M:	Jakub Kicinski <kuba@kernel.org>
>  L:	netdev@vger.kernel.org
> -S:	Odd Fixes
> +S:	Maintained
>  W:	http://www.linuxfoundation.org/en/Net
>  Q:	http://patchwork.ozlabs.org/project/netdev/list/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> 

-- 
Florian
