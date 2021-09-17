Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEF240FEE5
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbhIQSAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhIQSAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:00:50 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DD5C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:59:28 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id a10so20009587qka.12
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=FQgZkjFAxYcdhvUIQhgPdBhEgZvwxrmOKK0o+fS62ns=;
        b=EcZfVWqVcscnFky0aojWAiIY8BfDTRD8BOZMA5YCHBZAu0zyuN7NXFCX2WpDIOYROp
         WCs0HugKjWCuyw0l0oTfXtic9a1WK1mqnCo+JStXN03lJruOuCVK/oL3Qw8RZez1SzOL
         S5O+b5McDAyJBIqioTXUOtGarnvOabtQ7SLu0CaMWFitOI7ZwGG9LhPrj6FWjZZQnrnK
         49UY6aKurNXO7yDqBSf/XxH4Pym/SS8d6v1vJUJItrawfrfAF7h9lWHsN7aIebBB2g3W
         wtE+nS7lSv3Jff6RXfVnZ/KsyRjy+rnpYmQOP5G/ctJIiE83+WI7mjsY76bb3O3zFM52
         sXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=FQgZkjFAxYcdhvUIQhgPdBhEgZvwxrmOKK0o+fS62ns=;
        b=zNYhNYqKG/kO9EJJO5103CTtsMbwZrrgKefDnS56Nyg6CQTgDLg9ygRcQEmoFkGSRE
         /6a7Ji6xUNcOJgUknkKxBuB3RM9ZfJuOAtTnv4uLmSj6/Ethr4FIK9ltrn4pK8fxH+DK
         VTGDxBwVNXCeVo2QjYmVhYlWZyBRnt4x85OmBjv2NRhmaCkqsd6uG4w+Co3Rp5h54Cxe
         hn+W0KLTfP0PWMX1gHo++BiE29sXdxSD78VtnGe4F0RkSyP+CyR82Goactvt/JJAfNcS
         LF9s05h/nBoTccG14sER2izegBKj8Rn+fWcTQy8t5J2N26Jrub/saHt/v7zjlmVJIzbt
         j6Hg==
X-Gm-Message-State: AOAM531+gKVEoGtTKB/0KHDlMiHMWFiLIT2Abn4d/zAK1qcwj0BNd/kW
        6r/AGse31zXDTle4b5LkWTzX8+9pakOqyiFdqnpFUg==
X-Google-Smtp-Source: ABdhPJzztRLAS5HIEMDJhyZSQJBPyd4EhqiA8tvKMD/uEVwxA76rSnb3IOxBUY/lOCVfvby6z13G+KrM/E9+3P4vKY0=
X-Received: by 2002:a25:99c8:: with SMTP id q8mr15374692ybo.63.1631901567062;
 Fri, 17 Sep 2021 10:59:27 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 17 Sep 2021 19:59:15 +0200
Message-ID: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Maciej Zenczykowski <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been browsing some usb ethernet dongle related stuff in the
kernel (trying to figure out which options to enable in Android 13
5.~15 kernels), and I've come across the following patch (see topic,
full patch quoted below).

Doesn't it entirely defeat the purpose of the patch it claims to fix
(and the patch that fixed)?
Certainly the reasoning provided (in general device drivers should not
be enabled by default) doesn't jive with me.
The device driver is CDC_ETHER and AFAICT this is just a compatibility
option for it.

Shouldn't it be reverted (ie. the 'default y' line be re-added) ?

AFAICT the logic should be:
  if we have CDC ETHER (aka. ECM), but we don't have R8152 then we
need to have R8153_ECM.

Alternatively, maybe there shouldn't be a config option for this at all?

Instead r8153_ecm should simply be part of cdc_ether.ko iff r8152=3Dn

I'm not knowledgeable enough about Kconfig syntax to know how to
phrase the logic...
Maybe there shouldn't be a Kconfig option at all, and just some Makefile if=
'ery.

Something like:

obj-$(CONFIG_USB_RTL8152) +=3D r8152.o
obj-$(CONFIG_USB_NET_CDCETHER) +=3D cdc_ether.o obj-
ifndef CONFIG_USB_RTL8152
obj-$(CONFIG_USB_NET_CDCETHER) +=3D r8153_ecm.o
endif

Though it certainly would be nice to use 8153 devices with the
CDCETHER driver even with the r8152 driver enabled...

Cheers,
- Maciej

--- --- ---

commit 7da17624e7948d5d9660b910f8079d26d26ce453
Author: Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Wed Jan 13 15:43:09 2021 +0100

    nt: usb: USB_RTL8153_ECM should not default to y

    In general, device drivers should not be enabled by default.

    Fixes: 657bc1d10bfc23ac ("r8153_ecm: avoid to be prior to r8152 driver"=
)
    Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
    Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Link: https://lore.kernel.org/r/20210113144309.1384615-1-geert+renesas@=
glider.be
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 1e3719028780..fbbe78643631 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -631,7 +631,6 @@ config USB_NET_AQC111
 config USB_RTL8153_ECM
        tristate "RTL8153 ECM support"
        depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=3Dn)
-       default y
        help
          This option supports ECM mode for RTL8153 ethernet adapter, when
          CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not

Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
