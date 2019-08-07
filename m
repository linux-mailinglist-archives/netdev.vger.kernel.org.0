Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0820C84CC9
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388295AbfHGNVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:21:02 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44134 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388059AbfHGNVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 09:21:02 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so86166315edr.11;
        Wed, 07 Aug 2019 06:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o7gDnBpDuDwXcYQ6QlYY8efn/08+76Px3igT9oXiK5k=;
        b=mAq5BtUhI3z8QjtUP5eyHqp1lRL4rZsr/asLgLulVustVZihkiAI2jA/936C7Ne/Ed
         +xw/1ApoAaKYMSgiUNBNjXo2CB+CdcNkkNBURfQpUUq+UP0tFevI/h82lw+gaAPp7c8S
         CKxixq506MTIMdNj/oi6+ck/B1WkHpBKKjeO+T0z3AGtCcwQgua98Bzsi8QbSvWdVGEx
         VerZihDR9aiEfl3sdyDR9h8+g96A8ucnrauVnkL+4u/bf2waTqhRWO11a2nNqQJ4WNHR
         OvlarePLz5a2++24v8FYro2WWIMz2kQJIkBt2//lDo34fG0oqRghVDuWHYj+Jb5PTL2D
         R/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o7gDnBpDuDwXcYQ6QlYY8efn/08+76Px3igT9oXiK5k=;
        b=ujj0mpFg3nG3BbA1sJ6girzUrXNwTU+qxnIJI3kE32lKtuGBrAYRawTOZatd3JKIwd
         1LA7h1uULi7ca62v4dhdQW8NnOfQiDvcP69bUhXJF65XydteCH4E1hIXnbckAl4bguID
         k8ALTNR2IJiBNWGbqmlZZ/pfxzp0L6qC6OeXlff9QyaqTSyM+gIr2ZppMQ5KHUnmKkLS
         SEa4lIXrW0Bk7EI4mTWYRC636jY35aNZzSvT4JHw0VJ6qYsUWx1bdsy9tzw7f5FHr2JY
         Dv/A1reeR+kgWMD5XMN9O+F7j5EkmzudfrrrW7AGfVHbWEAE7ZmwFbGu6OY0csl2BZ9V
         Aqww==
X-Gm-Message-State: APjAAAUrc8H3IboR0rnbo0jSjg878TBOQsumrCGyEGQunZ92+qhvA6yO
        vzDNUCDE9z3qtNlekGkSbEt6mVJhuBRvWNuvUXi0dw==
X-Google-Smtp-Source: APXvYqzlJc+LZ/CNeaxM3+J0/iEtUaUJ17IdZUeXr/6iVQDtk6kNp4wINoAEOPiTbMG5Rvj71glBbrpO1B+cBWZPyzM=
X-Received: by 2002:a17:906:b7d8:: with SMTP id fy24mr8450496ejb.230.1565184060594;
 Wed, 07 Aug 2019 06:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190807130856.60792-1-yuehaibing@huawei.com> <CA+h21hrrWGrw4kiTfjowWvQ-B6sNPLAcgTaaadA02ZAmYw1SjQ@mail.gmail.com>
In-Reply-To: <CA+h21hrrWGrw4kiTfjowWvQ-B6sNPLAcgTaaadA02ZAmYw1SjQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 7 Aug 2019 16:20:49 +0300
Message-ID: <CA+h21hpt1UghzkdQ-x5k37T=SZ8Hc1euV11WyHPrYVCF-rq+Uw@mail.gmail.com>
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

On Wed, 7 Aug 2019 at 16:19, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, 7 Aug 2019 at 16:09, YueHaibing <yuehaibing@huawei.com> wrote:
> >
> > Fixes gcc '-Wunused-but-set-variable' warning:
> >
> > drivers/net/dsa/sja1105/sja1105_main.c: In function sja1105_fdb_dump:
> > drivers/net/dsa/sja1105/sja1105_main.c:1226:14: warning:
> >  variable tx_vid set but not used [-Wunused-but-set-variable]
> > drivers/net/dsa/sja1105/sja1105_main.c:1226:6: warning:
> >  variable rx_vid set but not used [-Wunused-but-set-variable]
> >
> > They are not used since commit 6d7c7d948a2e ("net: dsa:
> > sja1105: Fix broken learning with vlan_filtering disabled")
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

This patch should also go to the "net" tree.

>
> >  drivers/net/dsa/sja1105/sja1105_main.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> > index d073baf..df976b25 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_main.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> > @@ -1223,12 +1223,8 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
> >  {
> >         struct sja1105_private *priv = ds->priv;
> >         struct device *dev = ds->dev;
> > -       u16 rx_vid, tx_vid;
> >         int i;
> >
> > -       rx_vid = dsa_8021q_rx_vid(ds, port);
> > -       tx_vid = dsa_8021q_tx_vid(ds, port);
> > -
> >         for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
> >                 struct sja1105_l2_lookup_entry l2_lookup = {0};
> >                 u8 macaddr[ETH_ALEN];
> > --
> > 2.7.4
> >
> >
