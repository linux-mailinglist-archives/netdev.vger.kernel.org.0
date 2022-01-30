Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A24A39BB
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 22:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356333AbiA3VJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 16:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiA3VJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 16:09:13 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C90C061714;
        Sun, 30 Jan 2022 13:09:12 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m26so2585087wms.0;
        Sun, 30 Jan 2022 13:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B1IWcaAQA4ktXzUnqJdkpSCyOdcipF2cJEVU2yyzi4k=;
        b=qodROuEYXy450msL/HRTClktNFUufy6N8mOBmdOV7GgZ7XibbvyZTcIoP/UWBrhP5d
         tlaKIAO0WJ6j9CAXk0uxUlrEDRF64R7uZ5ihklLMFEcwZLlLnfJ5iY5aSP7tN4IXgUTj
         MA0p5PhVXcuH4Uj0KN67vc/EbpSdgb+4B2nb14P723HjOWBkKTfPA3er2mJf8G3bh+tC
         2ZjZhDlT5j9upT7X3/mFknj9OG2Ly8Cfn/4+FvBtKh3zbE/AfACUnhZsoxMMXqZs7XaS
         IkUCtBrq61rOxZBk+0msQ7Ac/TGyx1MjIW3Y2JaoojA0baQYzwp3U6zOZ5Q6bdJ3y0ln
         7G3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B1IWcaAQA4ktXzUnqJdkpSCyOdcipF2cJEVU2yyzi4k=;
        b=lid/FpUrVnRhNCKCcwsTR5fzg4qt23Zy1W1VD+OsNxRWymEb56z0f/WmJgMAcqYbNr
         D9j0jdrinKjnSd7jOpBgTaHfwmMlw+NhZL6hzJJDDFODQwpCRvJW2/sHeRBCxG0lvsUM
         4O9gjCL4tFM+s8YTay8YDD2ymEDW7tyERl7z/okS/EiKsCXj8R8p+g2Du+RSVcYjYjYi
         0vurFTDluqTVZFpiB+xmLcnqx/vdFAERlpZkXzq3eWNJ+16FlPRbuadGqbmipXPTrl16
         5SbNNJZWYSPOkVGNYjFhlg25GmuhZg/QbzO6q4Q3DJiRmCclo85PtOBZj20uAEyMewMd
         19Jw==
X-Gm-Message-State: AOAM530i51N+JNLAwfuwigUYBF86JJ6AHnllzr7ffO1hu6e4JZNI+XGa
        wVoy16lZWarUYhslfIP7sqdtI7xTdI9rVRfy0qM=
X-Google-Smtp-Source: ABdhPJyi1TUSg+Z0T0MqH85hdXl1YgGu43/m/Ax/Er4trZUowNzRk7NexFtRDDoZqeN+YNjqMSKL9iibMNd6SMHkkmw=
X-Received: by 2002:a7b:c455:: with SMTP id l21mr6489198wmi.91.1643576951382;
 Sun, 30 Jan 2022 13:09:11 -0800 (PST)
MIME-Version: 1.0
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com> <20220128112002.1121320-3-miquel.raynal@bootlin.com>
In-Reply-To: <20220128112002.1121320-3-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 30 Jan 2022 16:09:00 -0500
Message-ID: <CAB_54W7KOjBys4aY5Ky3N3zmSGHnW2cvfag2cubD4cMvrkHY3A@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 2/2] net: ieee802154: Move the address
 structure earlier and provide a kdoc
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 6:20 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> From: David Girault <david.girault@qorvo.com>
>
> Move the address structure earlier in the cfg802154.h header in order to
> use it in subsequent additions. Give this structure a header to better
> explain its content.
>
> Signed-off-by: David Girault <david.girault@qorvo.com>
> [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
>                             reword the comment]
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 4491e2724ff2..0b8b1812cea1 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -29,6 +29,25 @@ struct ieee802154_llsec_key_id;
>  struct ieee802154_llsec_key;
>  #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
>
> +/**
> + * struct ieee802154_addr - IEEE802.15.4 device address
> + * @mode: Address mode from frame header. Can be one of:
> + *        - @IEEE802154_ADDR_NONE
> + *        - @IEEE802154_ADDR_SHORT
> + *        - @IEEE802154_ADDR_LONG
> + * @pan_id: The PAN ID this address belongs to
> + * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
> + * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
> + */
> +struct ieee802154_addr {
> +       u8 mode;
> +       __le16 pan_id;
> +       union {
> +               __le16 short_addr;
> +               __le64 extended_addr;
> +       };
> +};
> +
>  struct cfg802154_ops {
>         struct net_device * (*add_virtual_intf_deprecated)(struct wpan_phy *wpan_phy,
>                                                            const char *name,
> @@ -277,15 +296,6 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
>         write_pnet(&wpan_phy->_net, net);
>  }
>
> -struct ieee802154_addr {
> -       u8 mode;
> -       __le16 pan_id;
> -       union {
> -               __le16 short_addr;
> -               __le64 extended_addr;
> -       };
> -};
> -

I don't see the sense of moving this around? Is there a compilation
warning/error?

- Alex
