Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A64649758D
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 21:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbiAWUpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 15:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240098AbiAWUpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 15:45:12 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC08AC06173B;
        Sun, 23 Jan 2022 12:45:11 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v13so9962575wrv.10;
        Sun, 23 Jan 2022 12:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JjOTyMYqSntifnM/IFbfpSh6njlmCNgHOt+K/JvQg2U=;
        b=caCbhYHo8KZJJy3wEBf561/PsU9EHiFELjtAJVLNPOLOkuhw/1ZYc5AVOnZ5aqaxsV
         dlTmx/AXTZ51H199Qd+l3ndeicUH77/TT/w2YksIfOVctmrrCxPr1huwvGveV7YPf1J7
         hpjMscLXmLc9WMpM6Ne23UTxMe3PJ77ZWl7jB8/mwYpHOZsTYmz+EJ4F5xnopr4RUmMe
         +k/xtj1ZRYrhEi6u1XMwB3ENRjg31H67JHTwFRChCj0PT1jMse4dYrUu7rzv6zT5tcNH
         ifo1OSUFNO3uSNgCy7kMWvve0sArZwXgW7/0xB9mxwmVOiqFzc3tgco3Q9WULhss0FOh
         eRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JjOTyMYqSntifnM/IFbfpSh6njlmCNgHOt+K/JvQg2U=;
        b=uQ7zjXQf0zF7eZ/P7HI3UAulNCAIxiRvNV+bLH+VKJR3iZRqTGvmpMxUftsNIxJ2uY
         6tej5ETXTAXMVn/F4JDJaM6bwaJqF8oMMgNTsMIzjexUmIlDEmbbl6gvio6wdVL3Adqo
         +ezDgi/h/GMno2LtrxiLlnCaahOO7MuQzaF/Mwjp3S051iyLyA957n+IvVk0lb4FpJi1
         cGqCfMHKtIQiRV/WBUdzTBOdHAO/b91lueokQMPqsMgEkbz0eSHxdOS+2QzoTG0k8YC4
         poDGrblgDKzmXUiALodR9UCSVGK+g0/ARYUqHpAi2pS5GhB7SWh2rmH18VvsKWjs6Wr7
         /Teg==
X-Gm-Message-State: AOAM532iP8N49HGDFWW0jYt5PjWbPNoRGeec8j28O3xsDJ0fw4nMTqiv
        F3h7Kw8KeMTGPEAgkRYL3Huu8kQdgmo22vPrg1s=
X-Google-Smtp-Source: ABdhPJypeRGFPhoSRKAiSw+ZAsEH42Er4jXYNgdJlfdB+IiUUCP1Atm18MMjWpJHybJT7A4yW7YWobWOq4PAYJFaUzg=
X-Received: by 2002:adf:fa8d:: with SMTP id h13mr11728924wrr.154.1642970710307;
 Sun, 23 Jan 2022 12:45:10 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com> <20220120112115.448077-7-miquel.raynal@bootlin.com>
In-Reply-To: <20220120112115.448077-7-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 15:44:59 -0500
Message-ID: <CAB_54W5DfNa8QSTiejL=1ywEShkK07bwvJeHkhcVowLtOtZrUw@mail.gmail.com>
Subject: Re: [wpan-next v2 6/9] net: ieee802154: Use the IEEE802154_MAX_PAGE
 define when relevant
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
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

On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> This define already exist but is hardcoded in nl-phy.c. Use the
> definition when relevant.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/ieee802154/nl-phy.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
> index dd5a45f8a78a..02f6a53d0faa 100644
> --- a/net/ieee802154/nl-phy.c
> +++ b/net/ieee802154/nl-phy.c
> @@ -30,7 +30,8 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
>  {
>         void *hdr;
>         int i, pages = 0;
> -       uint32_t *buf = kcalloc(32, sizeof(uint32_t), GFP_KERNEL);
> +       uint32_t *buf = kcalloc(IEEE802154_MAX_PAGE + 1, sizeof(uint32_t),
> +                               GFP_KERNEL);
>
>         pr_debug("%s\n", __func__);
>
> @@ -47,7 +48,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
>             nla_put_u8(msg, IEEE802154_ATTR_PAGE, phy->current_page) ||
>             nla_put_u8(msg, IEEE802154_ATTR_CHANNEL, phy->current_channel))
>                 goto nla_put_failure;
> -       for (i = 0; i < 32; i++) {
> +       for (i = 0; i <= IEEE802154_MAX_PAGE; i++) {
>                 if (phy->supported.channels[i])
>                         buf[pages++] = phy->supported.channels[i] | (i << 27);
>         }

Where is the fix here?

- Alex
