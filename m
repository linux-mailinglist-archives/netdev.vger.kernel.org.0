Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082BA4A3990
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 21:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347663AbiA3UzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 15:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiA3UzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 15:55:18 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBC0C061714;
        Sun, 30 Jan 2022 12:55:18 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id n8so8843493wmk.3;
        Sun, 30 Jan 2022 12:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hlLZVLsIpJsWYo7N/j9SaOPfoK7TOPxWS772QvTojxQ=;
        b=EfKgQDOuzkDfHJQ2xZX33bdL+bTnG4GXKakgVYA7EfEP0RgRQNq81AdwGvxcDZZ9Vp
         pwWbHal4yT1sWJt7VCAMMG/SfJLFfNxd+u0sUbM882PuNqSsKCftcylmpeGnGKAozljh
         8vrMT/FFEv/mkKV1/yNIcHYo5V6KWG74GXi1nOW44A5zFWcxLKra8ndagSZsOzoGvjRH
         pmBQq+8KwR20m5aQTotgTKJLvW6W+y4m9g5OS/UHno57t1dR/mjPpz8TPJot/pa6/tzn
         7Gv2KICmAfSC590a+/R+rG/2CJu8YfQdko/SvFvT4zzhznFqjrktvft5xolC+sdFSay9
         dXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hlLZVLsIpJsWYo7N/j9SaOPfoK7TOPxWS772QvTojxQ=;
        b=EQcLwt10q+WauvNlsGpYGFpKkAgdSxjn5KyXNqF0177NeAVvBkB4rxpSVD+/M+nCsj
         CcO97mSpEC7AyYhAQ0vk4eU9O7orHD+8le4IO6lcKBRQ6fyoUeuvKOtpMBAAAgAoGobc
         m+ihrwRVTs4O4i6u4Kce2SjUr+jof6lwyUhdtR8hV3+4pR1OnuVbQE+BmaUeLGLNBeje
         yPbo5TAOBmdTSgjsegUdGBCp41jbkzhK/Ys73hyEavk3OJT1nFGvvhhUNKyo7uN9uAuJ
         Hm7TPhAJSOTjJKeH8Wn1EpK+1zstk5AgagzHX9XGU1+trasN889aAIaJEb5xkfhGtmZf
         ZC7A==
X-Gm-Message-State: AOAM532NWVJO4vUbRFReSH6QS8EIf6nVvM9GgnhBcYpyQwJ6u0OPD0Tw
        vYnsZIIuyahA8gkOCRNjaGANHRm55cOGKVa+J02AAzpAZbQ=
X-Google-Smtp-Source: ABdhPJz98oJe1LjHmdOMZzKJMNYkD+9L+PCwl/2nY9pUuEXTxQvm6t2tqQxHKu1WRR9z2IhX1B6Wce0aIxYONl5rFbg=
X-Received: by 2002:a05:600c:3b90:: with SMTP id n16mr19675469wms.178.1643576116549;
 Sun, 30 Jan 2022 12:55:16 -0800 (PST)
MIME-Version: 1.0
References: <20220120004350.308866-1-miquel.raynal@bootlin.com> <20220120004350.308866-3-miquel.raynal@bootlin.com>
In-Reply-To: <20220120004350.308866-3-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 30 Jan 2022 15:55:05 -0500
Message-ID: <CAB_54W40ZU9kNxiGG+PpNfMtZzwaz-Er81y1WvMVvG1JGDPm7w@mail.gmail.com>
Subject: Re: [wpan-next 2/4] net: mac802154: Include the softMAC stack inside
 the IEEE 802.15.4 menu
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jan 19, 2022 at 7:43 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> From: David Girault <david.girault@qorvo.com>
>
> The softMAC stack has no meaning outside of the IEEE 802.15.4 stack and
> cannot be used without it.
>

that's why there is a "depends on" in there.

> Signed-off-by: David Girault <david.girault@qorvo.com>
> [miquel.raynal@bootlin.com: Isolate this change from a bigger commit]
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/Kconfig            | 1 -
>  net/ieee802154/Kconfig | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/Kconfig b/net/Kconfig
> index 0da89d09ffa6..a5e31078fd14 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -228,7 +228,6 @@ source "net/x25/Kconfig"
>  source "net/lapb/Kconfig"
>  source "net/phonet/Kconfig"
>  source "net/6lowpan/Kconfig"
> -source "net/mac802154/Kconfig"
>  source "net/sched/Kconfig"
>  source "net/dcb/Kconfig"
>  source "net/dns_resolver/Kconfig"
> diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
> index 31aed75fe62d..7e4b1d49d445 100644
> --- a/net/ieee802154/Kconfig
> +++ b/net/ieee802154/Kconfig
> @@ -36,6 +36,7 @@ config IEEE802154_SOCKET
>           for 802.15.4 dataframes. Also RAW socket interface to build MAC
>           header from userspace.
>
> +source "net/mac802154/Kconfig"
>  source "net/ieee802154/6lowpan/Kconfig"

The next person in a year will probably argue "but wireless do source
of wireless/mac80211 in net/Kconfig... so this is wrong".
To avoid this issue maybe we should take out the menuentry here and do
whatever wireless is doing without questioning it?

- Alex
