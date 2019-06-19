Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AC84C13B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbfFSTKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:10:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36905 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfFSTKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:10:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14so419108wrr.4
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 12:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UFheggzxmMplOeeQYmoI5B0vCJ1cyWY14SZKvEdIZeI=;
        b=q2WfLwCClZoa+WhRbyKt/Y+TgErSvoQ/t5ka8vLOi11eKndyFdaMIphrq5wGGRpPx0
         w74c0Bd6HbL1fwpWqUKNj6kHbJyjS9bevT3l+au26572bSk6OLA9tz3vCKl5B7lQ3YMp
         59fj8s9I0t80eOe2RdRSoMCtic8jR1S6+NI4lJVCt/kVnhsRgdsGPkuzdO0vwRS7HGGZ
         fWL021Josk7Je+oTIjDlgfo2c+0SBwY9f/Hm7/+V4w+t6Vym486kIGSe5Aiypxhs8oIn
         XkN6ASaGDOG/TSsv0EbPrdzGLx+NVycg/i6oOwCLGJQap5BpUh3MBTqYafhQpd18vQ27
         D7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UFheggzxmMplOeeQYmoI5B0vCJ1cyWY14SZKvEdIZeI=;
        b=TSPahl4UC1uj8QMTuj2cXFsdlulAqs7vz3WrlbYK7fNodVlr9bnRmjEkqMBO4VBJHS
         kVWV/cprWHHUyLYRYA+zV792omMAfx66spXpMjt5lmYKVzUDd1C5ZHEs+iz7Ljh9Ckur
         DykjK4wfsj8wX2+8sAu/bvBlUEXC2q/r76SnqkbpjlTaHhqLDmjaoXi9bY70xBXwP5/9
         faDm22wleQJLglvhMQdlCplXtXjLzqA3BX31wUoOeUUphbaqY1i1tsjyvXG8iVe7JsQ8
         +Z/9tcE/jJSg36sZiidnvU3ZVtbcmJypWAzYag0EkQWvhP/3ohoDtGUXKq6Fy1aMZPQp
         i+5g==
X-Gm-Message-State: APjAAAWpEr700SxQlvHtnMCu92oFd1Oj2h0KB/H6JfWhetf+/8+KSoLd
        5xvEhIQvvXCThK2DeCj7nh985ciPvN63m1fEoFrm
X-Google-Smtp-Source: APXvYqzXZlrQCF4QZiuxDbGDLIvTOXeukxMx+PQ/5nfVH3ZEWFzwBQjV68ETEYVe1v6+Rjh1FKW41QrqKc5YBvCYJxs=
X-Received: by 2002:adf:dfc4:: with SMTP id q4mr14402268wrn.54.1560971434605;
 Wed, 19 Jun 2019 12:10:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190619174643.21456-1-puranjay12@gmail.com>
In-Reply-To: <20190619174643.21456-1-puranjay12@gmail.com>
From:   Bjorn Helgaas <bhelgaas@google.com>
Date:   Wed, 19 Jun 2019 14:10:22 -0500
Message-ID: <CAErSpo7-AjCAc8pGpTftd7U-W2kjp1jfbPzk3SOa=Bg5-d6W5w@mail.gmail.com>
Subject: Re: [PATCH] net: fddi: skfp: remove generic PCI defines from skfbi.h
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 12:48 PM Puranjay Mohan <puranjay12@gmail.com> wrote:
>
> skfbi.h defines its own copies of PCI_COMMAND, PCI_STATUS, etc.
> remove them in favor of the generic definitions in
> include/uapi/linux/pci_regs.h

1) Since you're sending several related patches, send them as a
"series" with a cover letter, e.g.,

  [PATCH v2 0/2] Use PCI generic definitions instead of private duplicates
  [PATCH v2 1/2] Include generic PCI definitions
  [PATCH v2 2/2] Remove unused private PCI definitions

Patches 1/2 and 2/2 should be replies to the 0/2 cover letter.  "git
send-email" will do this for you if you figure out the right options.

2) Make sure all your subject lines match.  One started with "Include"
and the other with "remove".  They should both be capitalized.

3) Start sentences with a capital letter, i.e., "Remove them" above.

4) This commit log needs to explicitly say that you're removing
*unused* symbols.  Since they're unused, you don't even need to refer
to pci_regs.h.

5) "git grep PCI_ drivers/net/fddi/skfp" says there are many more
unused PCI symbols than just the ones below.  I would just remove them
all at once.

6) Obviously you should compile this to make sure it builds.  It must
build cleanly after every patch, not just at the end.  I assume you've
done this already.

7) Please cc: linux-pci@vger.kernel.org since you're making PCI-related changes.

> Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
> ---
>  drivers/net/fddi/skfp/h/skfbi.h | 23 -----------------------
>  1 file changed, 23 deletions(-)
>
> diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
> index 89557457b352..ed144a8e78d1 100644
> --- a/drivers/net/fddi/skfp/h/skfbi.h
> +++ b/drivers/net/fddi/skfp/h/skfbi.h
> @@ -27,29 +27,6 @@
>  /*
>   * Configuration Space header
>   */
> -#define        PCI_VENDOR_ID   0x00    /* 16 bit       Vendor ID */
> -#define        PCI_DEVICE_ID   0x02    /* 16 bit       Device ID */
> -#define        PCI_COMMAND     0x04    /* 16 bit       Command */
> -#define        PCI_STATUS      0x06    /* 16 bit       Status */
> -#define        PCI_REV_ID      0x08    /*  8 bit       Revision ID */
> -#define        PCI_CLASS_CODE  0x09    /* 24 bit       Class Code */
> -#define        PCI_CACHE_LSZ   0x0c    /*  8 bit       Cache Line Size */
> -#define        PCI_LAT_TIM     0x0d    /*  8 bit       Latency Timer */
> -#define        PCI_HEADER_T    0x0e    /*  8 bit       Header Type */
> -#define        PCI_BIST        0x0f    /*  8 bit       Built-in selftest */
> -#define        PCI_BASE_1ST    0x10    /* 32 bit       1st Base address */
> -#define        PCI_BASE_2ND    0x14    /* 32 bit       2nd Base address */
> -/* Byte 18..2b:        Reserved */
> -#define        PCI_SUB_VID     0x2c    /* 16 bit       Subsystem Vendor ID */
> -#define        PCI_SUB_ID      0x2e    /* 16 bit       Subsystem ID */
> -#define        PCI_BASE_ROM    0x30    /* 32 bit       Expansion ROM Base Address */
> -/* Byte 34..33:        Reserved */
> -#define PCI_CAP_PTR    0x34    /*  8 bit (ML)  Capabilities Ptr */
> -/* Byte 35..3b:        Reserved */
> -#define        PCI_IRQ_LINE    0x3c    /*  8 bit       Interrupt Line */
> -#define        PCI_IRQ_PIN     0x3d    /*  8 bit       Interrupt Pin */
> -#define        PCI_MIN_GNT     0x3e    /*  8 bit       Min_Gnt */
> -#define        PCI_MAX_LAT     0x3f    /*  8 bit       Max_Lat */
>  /* Device Dependent Region */
>  #define        PCI_OUR_REG     0x40    /* 32 bit (DV)  Our Register */
>  #define        PCI_OUR_REG_1   0x40    /* 32 bit (ML)  Our Register 1 */
> --
> 2.21.0
>
