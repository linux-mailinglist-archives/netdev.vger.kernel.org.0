Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEA93D588
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbfFKSb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:31:56 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36052 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbfFKSbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:31:55 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so18176405edq.3;
        Tue, 11 Jun 2019 11:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=etnfHBwHwyFsN2HaYveGGQaMNTp8qgHb5Y4DRDFTVNU=;
        b=ZZe4zgRPVnC3/G4iZqlclPdd7uuy4IcTboSC6hE1aHfeMWAQqhbecEQoHKgn9h624/
         rRf28XuyIMS2zgv9fdEFgxYhgoe8VpLKMF0ibRvQyLoDx4mMa6OI6YV17Rebg/KZHKKd
         OMxuwuSLI9s4po8xoM/ANTTKpXgABykPDBpkPM2aHMjBzkdOf8bckcPb6sUDhFm037gm
         miPEb1NZruxWcOtBRlA9b8cseTvqffZx36qaQsMatG8DK9iRLl/dcyAmBNGot1xLOtjs
         7CysEJTlwrrVWebxqIhQ8PdY4qpNykUfo2QYbN+6pOTbX6mWcu3QWbzg6va77iKiy8B4
         dVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=etnfHBwHwyFsN2HaYveGGQaMNTp8qgHb5Y4DRDFTVNU=;
        b=UC1O6mE4iNQ1dkNrgjZj/q0Ss7RWUmjou1t+9tqwkMkp4G5LB5a5xqc+lSxSbGOb0i
         rhxC0FLfsOHG53+uWhZ/Bx8TIs/pSs535v9h2JEdhiqTx+saOQBmLfKAwyOP19h22Vf7
         dDkAJu7O2KGlLWhbGc5aNr0m5TNZCnN+RnCO5/BHj6AMoYiCaTKBKVbAIqRH2hnZWYh7
         SLvxjnMepGD0IybYLd7bXEdzyHEskipqZ7namDvj7LadfuSKgYIlLydVw5fnG2Umqkfg
         VV80vsWvncvVJPO6NUJZoRFClsXhkGWkzsXFtVSzKurwY4RvtHLeNVz7AZRV15ZO6lTz
         9rYQ==
X-Gm-Message-State: APjAAAUcfYDW5cmjhrLadG8HdT92Q4+Dk2ojUwGGntFJCafQ/kLGqnCZ
        Eo3fOKuZ7SQ7HHikUsEbv0NzEysmormoVxIJ7FRIwA==
X-Google-Smtp-Source: APXvYqzLDXVqdpXgGxx6aiE2fM46mReLU6zN42HEqHiKNxpwIRoBr6v0iy7QLsQaAx7xF8iUxtbpzamcQhn6cBvlh6w=
X-Received: by 2002:aa7:de0e:: with SMTP id h14mr16668907edv.36.1560277914005;
 Tue, 11 Jun 2019 11:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190611135834.21080-1-yuehaibing@huawei.com>
In-Reply-To: <20190611135834.21080-1-yuehaibing@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 11 Jun 2019 21:31:43 +0300
Message-ID: <CA+h21hpJrNGJUyrWMjsLS7Z3dZdAxUhpX1nU3wm-z-v00yBO_w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Make two functions static
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 at 16:59, YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix sparse warnings:
>
> drivers/net/dsa/sja1105/sja1105_main.c:1848:6:
>  warning: symbol 'sja1105_port_rxtstamp' was not declared. Should it be static?
> drivers/net/dsa/sja1105/sja1105_main.c:1869:6:
>  warning: symbol 'sja1105_port_txtstamp' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 81e1ba5..9395e8f 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -1845,8 +1845,8 @@ static void sja1105_rxtstamp_work(struct work_struct *work)
>  }
>
>  /* Called from dsa_skb_defer_rx_timestamp */
> -bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
> -                          struct sk_buff *skb, unsigned int type)
> +static bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
> +                                 struct sk_buff *skb, unsigned int type)
>  {
>         struct sja1105_private *priv = ds->priv;
>         struct sja1105_tagger_data *data = &priv->tagger_data;
> @@ -1866,8 +1866,8 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
>   * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
>   * callback, where we will timestamp it synchronously.
>   */
> -bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
> -                          struct sk_buff *skb, unsigned int type)
> +static bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
> +                                 struct sk_buff *skb, unsigned int type)
>  {
>         struct sja1105_private *priv = ds->priv;
>         struct sja1105_port *sp = &priv->ports[port];
> --
> 2.7.4
>
>

Tested-by: Vladimir Oltean <olteanv@gmail.com>

Thanks!
-Vladimir
