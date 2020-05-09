Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98481CC330
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgEIR2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbgEIR2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:28:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796F7C061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 10:28:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id y6so5704205pjc.4
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=bUl10CVnOta8XuaRFc0DAdAKR4qbIrkPZNsUAUa6Sdo=;
        b=HqlzjSQcdwQjx25qDyUcLV0tueTWMtiie5irtbyezl+abXBO/OR/php0KHKRLNvK+z
         ktQAcytWdFFBwTtjOoxzEPKUrBxCFMKr0YUpp5JQu3h/XgS8r3ahvQtDeVM5wNjLVQEH
         6uyecTaZYgviPT8zjUKBhu9acDA/Ttv2KceB3jvDibM4deQ7Jjjxhs41ZIVafPzPqvEB
         gq/tioIVNiH41Nf2hE1fFJdqtB37xeipLjk+dO5D2FsIwCb1XiJut0U7UpeNHb4MpIhX
         PDt5B920rdFZSmdK8iSFkeoWii3JmFeiCm1RDXPbdx/jkw1URF++Yacv2bt5CfDgDOrJ
         TjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=bUl10CVnOta8XuaRFc0DAdAKR4qbIrkPZNsUAUa6Sdo=;
        b=SWew7HScyY2m1pHcaLbr44BSBNV8TtJNN2ImhdoalN+8rZDqBtYHXh6GkrSGFSjlt9
         Zvxbc2CHrWY4LClowhxkw+e6wCQQeD9cwDuV7UGyapj9musFArIR4PcKYu2i7qJhhYuj
         62QSArn0au4Y7DE+ZodKrGm3xXwDuwm38Y+8/v2lE1zc/6UYLivwVlohToUOw0/WVbw5
         ELVci39AAeGVMHEPyr9kIslJO90i45aXfcUH+YVZ074ajiWgsuJb9iMmpygk4CIuTOs5
         7RD+llcCd0YTlMF19JSMuQ43BhtVK3335apHQNkftw8WCPy1ibUJcrKBkkMk9EiH6zzh
         rzzQ==
X-Gm-Message-State: AGi0PuZBmYom1bIPRx/gCWZWwx4lQBwxnnt6r0cY+Bf0nqQUkh3Qc4T+
        Nlf6xFBMArTEmYYyYRJfbyUxxlIK
X-Google-Smtp-Source: APiQypK0XMM37GfJZnuaU6sS8+de3OreUMk9/DdeFDbi1oQ36FGou0AsKP/dWj6lyp2bboAYXs6Ddw==
X-Received: by 2002:a17:90a:a584:: with SMTP id b4mr12304590pjq.106.1589045287986;
        Sat, 09 May 2020 10:28:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q72sm5302640pjb.53.2020.05.09.10.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 10:28:07 -0700 (PDT)
Subject: Re: [PATCH v3 1/5] net: phy: Add support for microchip SMI0 MDIO bus
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-2-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <08858b46-95f0-24d0-0e11-1eaec292187c@gmail.com>
Date:   Sat, 9 May 2020 10:28:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508154343.6074-2-m.grzeschik@pengutronix.de>
Content-Type: multipart/mixed;
 boundary="------------AD416139D0778CA4E14A5F69"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------AD416139D0778CA4E14A5F69
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/8/2020 8:43 AM, Michael Grzeschik wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> SMI0 is a mangled version of MDIO. The main low level difference is
> the MDIO C22 OP code is always 0, not 0x2 or 0x1 for Read/Write. The
> read/write information is instead encoded in the PHY address.
> 
> Extend the bit-bang code to allow the op code to be overridden, but
> default to normal C22 values. Add an extra compatible to the mdio-gpio
> driver, and when this compatible is present, set the op codes to 0.
> 
> A higher level driver, sitting on top of the basic MDIO bus driver can
> then implement the rest of the microchip SMI0 odderties.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>   drivers/net/phy/mdio-bitbang.c |  7 ++-----
>   drivers/net/phy/mdio-gpio.c    | 13 +++++++++++++
>   include/linux/mdio-bitbang.h   |  2 ++
>   3 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
> index 5136275c8e7399..11255460ecb933 100644
> --- a/drivers/net/phy/mdio-bitbang.c
> +++ b/drivers/net/phy/mdio-bitbang.c
> @@ -19,9 +19,6 @@
>   #include <linux/types.h>
>   #include <linux/delay.h>
>   
> -#define MDIO_READ 2
> -#define MDIO_WRITE 1
> -
>   #define MDIO_C45 (1<<15)
>   #define MDIO_C45_ADDR (MDIO_C45 | 0)
>   #define MDIO_C45_READ (MDIO_C45 | 3)
> @@ -158,7 +155,7 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
>   		reg = mdiobb_cmd_addr(ctrl, phy, reg);
>   		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
>   	} else
> -		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
> +		mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
>   
>   	ctrl->ops->set_mdio_dir(ctrl, 0);
>   
> @@ -189,7 +186,7 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
>   		reg = mdiobb_cmd_addr(ctrl, phy, reg);
>   		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
>   	} else
> -		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
> +		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);

There are other users of the mdio-bitbang.c file which I believe you are 
going to break here because they will not initialize op_c22_write or 
op_c22_read, and thus they will be using 0, instead of MDIO_READ and 
MDIO_WRITE. I believe you need something like the patch attached.
-- 
Florian

--------------AD416139D0778CA4E14A5F69
Content-Type: text/plain; charset=UTF-8;
 name="mdio-bb.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mdio-bb.diff"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9tZGlvLWJpdGJhbmcuYyBiL2RyaXZlcnMv
bmV0L3BoeS9tZGlvLWJpdGJhbmcuYwppbmRleCAxMTI1NTQ2MGVjYjkuLjUyOGUyNTVkMWZm
ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvcGh5L21kaW8tYml0YmFuZy5jCisrKyBiL2Ry
aXZlcnMvbmV0L3BoeS9tZGlvLWJpdGJhbmcuYwpAQCAtMTksNiArMTksOSBAQAogI2luY2x1
ZGUgPGxpbnV4L3R5cGVzLmg+CiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4KIAorI2RlZmlu
ZSBNRElPX1JFQUQgMgorI2RlZmluZSBNRElPX1dSSVRFIDEKKwogI2RlZmluZSBNRElPX0M0
NSAoMTw8MTUpCiAjZGVmaW5lIE1ESU9fQzQ1X0FERFIgKE1ESU9fQzQ1IHwgMCkKICNkZWZp
bmUgTURJT19DNDVfUkVBRCAoTURJT19DNDUgfCAzKQpAQCAtMjEyLDYgKzIxNSwxMCBAQCBz
dHJ1Y3QgbWlpX2J1cyAqYWxsb2NfbWRpb19iaXRiYW5nKHN0cnVjdCBtZGlvYmJfY3RybCAq
Y3RybCkKIAlidXMtPnJlYWQgPSBtZGlvYmJfcmVhZDsKIAlidXMtPndyaXRlID0gbWRpb2Ji
X3dyaXRlOwogCWJ1cy0+cHJpdiA9IGN0cmw7CisJaWYgKCFjdHJsLT5vdmVycmlkZV9vcF9j
MjIpIHsKKwkJY3RybC0+b3BfYzIyX3JlYWQgPSBNRElPX1JFQUQ7CisJCWN0cmwtPm9wX2My
Ml93cml0ZSA9IE1ESU9fV1JJVEU7CisJfQogCiAJcmV0dXJuIGJ1czsKIH0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3BoeS9tZGlvLWdwaW8uYyBiL2RyaXZlcnMvbmV0L3BoeS9tZGlv
LWdwaW8uYwppbmRleCBkODViYzFhOTg2NDcuLjEzZWMzMWU4OWU5NCAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9uZXQvcGh5L21kaW8tZ3Bpby5jCisrKyBiL2RyaXZlcnMvbmV0L3BoeS9tZGlv
LWdwaW8uYwpAQCAtMjcsOSArMjcsNiBAQAogI2luY2x1ZGUgPGxpbnV4L2dwaW8vY29uc3Vt
ZXIuaD4KICNpbmNsdWRlIDxsaW51eC9vZl9tZGlvLmg+CiAKLSNkZWZpbmUgTURJT19SRUFE
IDIKLSNkZWZpbmUgTURJT19XUklURSAxCi0KIHN0cnVjdCBtZGlvX2dwaW9faW5mbyB7CiAJ
c3RydWN0IG1kaW9iYl9jdHJsIGN0cmw7CiAJc3RydWN0IGdwaW9fZGVzYyAqbWRjLCAqbWRp
bywgKm1kbzsKQEAgLTEzOSw5ICsxMzYsNyBAQCBzdGF0aWMgc3RydWN0IG1paV9idXMgKm1k
aW9fZ3Bpb19idXNfaW5pdChzdHJ1Y3QgZGV2aWNlICpkZXYsCiAJICAgIG9mX2RldmljZV9p
c19jb21wYXRpYmxlKGRldi0+b2Zfbm9kZSwgIm1pY3JvY2hpcCxtZGlvLXNtaTAiKSkgewog
CQliaXRiYW5nLT5jdHJsLm9wX2MyMl9yZWFkID0gMDsKIAkJYml0YmFuZy0+Y3RybC5vcF9j
MjJfd3JpdGUgPSAwOwotCX0gZWxzZSB7Ci0JCWJpdGJhbmctPmN0cmwub3BfYzIyX3JlYWQg
PSBNRElPX1JFQUQ7Ci0JCWJpdGJhbmctPmN0cmwub3BfYzIyX3dyaXRlID0gTURJT19XUklU
RTsKKwkJYml0YmFuZy0+Y3RybC5vdmVycmlkZV9vcF9jMjIgPSAxOwogCX0KIAogCWRldl9z
ZXRfZHJ2ZGF0YShkZXYsIG5ld19idXMpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9t
ZGlvLWJpdGJhbmcuaCBiL2luY2x1ZGUvbGludXgvbWRpby1iaXRiYW5nLmgKaW5kZXggOGFl
MGIzODM1MjMzLi41MDE2ZTZmNjBkZTMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbWRp
by1iaXRiYW5nLmgKKysrIGIvaW5jbHVkZS9saW51eC9tZGlvLWJpdGJhbmcuaApAQCAtMzMs
NiArMzMsNyBAQCBzdHJ1Y3QgbWRpb2JiX29wcyB7CiAKIHN0cnVjdCBtZGlvYmJfY3RybCB7
CiAJY29uc3Qgc3RydWN0IG1kaW9iYl9vcHMgKm9wczsKKwl1bnNpZ25lZCBpbnQgb3ZlcnJp
ZGVfb3BfYzIyOwogCXU4IG9wX2MyMl9yZWFkOwogCXU4IG9wX2MyMl93cml0ZTsKIH07Cg==
--------------AD416139D0778CA4E14A5F69--
