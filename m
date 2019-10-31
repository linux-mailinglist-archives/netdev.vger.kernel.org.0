Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D77EBA34
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbfJaXNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:13:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43192 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbfJaXNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:13:21 -0400
Received: by mail-lf1-f65.google.com with SMTP id j5so5952879lfh.10
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 16:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bcEx7b2yw90vM4bTQIavKv9TtXtDv7rCZ0KqJRWMUbc=;
        b=iZLH/YmX/ewsZDUgMEBqBTEQAIihsVuLZ43LU9u+2SD8Y9IGAdcRZwX16DaKzfvgsl
         nKcvb58r82Ps2hlDPpWnUZtXN7RTBfXAUOHM+w2a1TFWrEg1j38QmWKldO5D6+0h3ZJy
         JmX+eHgX8XKS1wnuZpUEpBDHEwBpV0VNTw2hYBGPmTcaqJ+sYHm2IjgCBhctmUr9S/Qy
         auZGaWBjchNfQ+XmJlXzcLAlTXHacFmoD1eWp0hxlvI9S2PteODygxN31JphJ7qxiwZy
         nFXhzfEcvbXb8Ru9tR4e4Vu1r4fiy7JWz5K4aBd/QcQJ86mVKtR2lX3eZcXPJ34769hs
         y/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bcEx7b2yw90vM4bTQIavKv9TtXtDv7rCZ0KqJRWMUbc=;
        b=egFmLJwOUd0c9TLAdD8a+azQXW92wo8ArmFdb8M080d7oDJio3D3h4xpsw7xEda9oP
         vsNEqpGHaflVk9igY+FXCGy/BWq1vz0jGVgLdQjjHTvMrUe5lX1qgJi4iisMbMH0Lbvk
         RT3iGzF6UpWFArGq3w9x5gKsBXCzOxVERP/s2YopB2ayLmo/5wNNDOtWc8CSNoGxfcHe
         hhavevSUX9M6Bcr+qSJYPG61gyTRG5yQDBinsbx6iQDuu7WAs4A1qmCcnjKhPQmAgcsA
         1DEUV1VbZrLJYIZB9IB2JxE+f6fGZS4site38qiYUWwaMZJPxgfIEG8ymFwPhM88YxV3
         S1Uw==
X-Gm-Message-State: APjAAAV61H0DmqB1MlHRSkjn51t6rqE9S+EMkbqjaA41wj3qkZeMOtEQ
        a+D4HN37Uhzmx5sQ7n5gq7+UfH4ldefskkOo4hKR8DSBCJG7Mw==
X-Google-Smtp-Source: APXvYqyssxVuuIu3obBX3XYx26/8U1f2xbFUBeCy6yB7GyUre459k1iFhr0eDOqzDaRblM7M2ZYDRb8PWgmnhm2yPSk=
X-Received: by 2002:a19:ca13:: with SMTP id a19mr5143648lfg.133.1572563599806;
 Thu, 31 Oct 2019 16:13:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191021000824.531-1-linus.walleij@linaro.org>
 <20191021000824.531-8-linus.walleij@linaro.org> <5c3a0c832defddf8d1ddbf51dba255c73004bcb6.camel@perches.com>
In-Reply-To: <5c3a0c832defddf8d1ddbf51dba255c73004bcb6.camel@perches.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 1 Nov 2019 00:13:08 +0100
Message-ID: <CACRpkdbp_dSLTs-ZcRqckbez_3G7a1CtZSu+dJrTSdtVz=JXJg@mail.gmail.com>
Subject: Re: [PATCH 07/10] net: ehernet: ixp4xx: Use devm_alloc_etherdev()
To:     Joe Perches <joe@perches.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 12:24 AM Joe Perches <joe@perches.com> wrote:
> On Mon, 2019-10-21 at 02:08 +0200, Linus Walleij wrote:

> > diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/eth=
ernet/xscale/ixp4xx_eth.c
>
> Maybe it's better to avoid changing this driver.
> Is this device still sold?  It's 15+ years old.

I am converting the whole platform to device tree so I need to
change this and many other drivers.

The rationale has been explained elsewhere but here it is for your
convenience:

A major reason why IXP4xx silicon is still produced and deployed is
the operating conditions. If you look at for example the Gateworks
Cambria GW2358-4 network processor you notice the strictly
military operating conditions:

Temperature: -40=C2=B0C to +85=C2=B0C
Humidity (non-condensing): 20% to 90%
MTBF (mean time before failure): 60 Years at 55=C2=B0C

We have good reasons to believe that these are used in critical
systems that are not consumer products and do not adhere to
consumer product life cycle expectations. Think more like this:
https://www.c4isrnet.com/air/2019/10/17/the-us-nuclear-forces-dr-strangelov=
e-era-messaging-system-finally-got-rid-of-its-floppy-disks/

Yours,
Linus Walleij
