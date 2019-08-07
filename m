Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5373984CC1
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbfHGNT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:19:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41546 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387957AbfHGNT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 09:19:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so86154260eds.8;
        Wed, 07 Aug 2019 06:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsS99LwnBC3iQ8HWvvQz+DMgbBjpR0gNdAlatU6bOeA=;
        b=VHHxvIM/f0VQ9SJFvUdoIzgQy3iZlKRCaxFeEfrXRUlstF9eR1j3imfN5H74UiMmja
         7EhgHjidOeKuIzTjJ1/poY+/a6aM+vjU1LzNOCvbe1ajrJNz3qljEqpqSR7bXSGHfKNP
         LRtAl1bu6KGV3wpPLV2htTq1o69HqEFFDyb80rJ1J35re6JSpGVvbO7cCNmL0XendxtC
         Z5BvqumswsLxdr805Pkp7RSXIRK6+3uSdQ4IWTO0stjuq539ejVARGrdiWfjrioEia5D
         mzw4iNY6pBJPYiMLNRcEy2rRvE1xblZqJ9jOqJKsAKZKXPoGEwefJ7PMcsEpvqUtBxRu
         SfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsS99LwnBC3iQ8HWvvQz+DMgbBjpR0gNdAlatU6bOeA=;
        b=CQkB+3DBIBmVMd5GTBLYd+8kWAmlM0D/OIx2b8gbxU7HhE7iSLlBHe3bXtg26GfZWG
         K22mLvYkJ2BR/HBgfjyGYW0O2PKrm0ompdWfsJ47zQkhVKMLcZ9QvHxu+YD7pRWOUzTe
         NzF7XdM2FHzMqZjgMKcTkEyMsQSL8rLVyzu9wt47XV2sSaw+AY9SpQpEykqPEGSZX2t0
         /7RLKiUgl6XE9dUBdgDvDB8/XqdbJcsEh3p2diEWAL9GIuEqLdFGzl8JHOrPU5BElAO8
         OgHnzegxRLMzfQAH7NzDeHnolTeX9+94FMM6MEfiQhX5l1wAqhcxmJeg5r2qsy20+op5
         oWOw==
X-Gm-Message-State: APjAAAVZiA4x37AZMkSP3OJVACUYPih2iKn+1vhWGbS2+AadLm3Y4Mr+
        lKXbhkD7i39e2uW8sBpMgiZugb7SPzUioxcN074=
X-Google-Smtp-Source: APXvYqx0eZkI6QO0WgJDZP9/db3DJXaNcEwIkkpd0jQp9gcp+BcQMHgWwwXO26vqbFfQLU0aCXszTwzgZHd0I1WabI0=
X-Received: by 2002:a17:906:c459:: with SMTP id ck25mr8135070ejb.32.1565183997044;
 Wed, 07 Aug 2019 06:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190807130856.60792-1-yuehaibing@huawei.com>
In-Reply-To: <20190807130856.60792-1-yuehaibing@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 7 Aug 2019 16:19:45 +0300
Message-ID: <CA+h21hrrWGrw4kiTfjowWvQ-B6sNPLAcgTaaadA02ZAmYw1SjQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: remove set but not used
 variables 'tx_vid' and 'rx_vid'
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

On Wed, 7 Aug 2019 at 16:09, YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/dsa/sja1105/sja1105_main.c: In function sja1105_fdb_dump:
> drivers/net/dsa/sja1105/sja1105_main.c:1226:14: warning:
>  variable tx_vid set but not used [-Wunused-but-set-variable]
> drivers/net/dsa/sja1105/sja1105_main.c:1226:6: warning:
>  variable rx_vid set but not used [-Wunused-but-set-variable]
>
> They are not used since commit 6d7c7d948a2e ("net: dsa:
> sja1105: Fix broken learning with vlan_filtering disabled")
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/sja1105/sja1105_main.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index d073baf..df976b25 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -1223,12 +1223,8 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
>  {
>         struct sja1105_private *priv = ds->priv;
>         struct device *dev = ds->dev;
> -       u16 rx_vid, tx_vid;
>         int i;
>
> -       rx_vid = dsa_8021q_rx_vid(ds, port);
> -       tx_vid = dsa_8021q_tx_vid(ds, port);
> -
>         for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
>                 struct sja1105_l2_lookup_entry l2_lookup = {0};
>                 u8 macaddr[ETH_ALEN];
> --
> 2.7.4
>
>
