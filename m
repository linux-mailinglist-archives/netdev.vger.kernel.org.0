Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793241C5B7B
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgEEPe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:34:56 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:32923 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbgEEPe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:34:56 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MtfRp-1jHtsv2esh-00v4dV; Tue, 05 May 2020 17:34:54 +0200
Received: by mail-qk1-f171.google.com with SMTP id f13so2735742qkh.2;
        Tue, 05 May 2020 08:34:54 -0700 (PDT)
X-Gm-Message-State: AGi0Pub2Lj7INkZdZeZmap/L7ibpyvMtORfQ2A/xm/7yxrSS2TbOdxGb
        XV2Xx/RTXaHU5FaOTe4RgnI25XMuC5CQTGfBDxg=
X-Google-Smtp-Source: APiQypJ6aNF96MJ+osF2WCBQeZWcDk6l1GVugJ56JpB8nOxW+eYqhDjSR3n8hNxMlYLYJbdvAfV1tblMIRLQi6j+tII=
X-Received: by 2002:a37:4e08:: with SMTP id c8mr4066508qkb.286.1588692893453;
 Tue, 05 May 2020 08:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200505135848.180753-1-arnd@arndb.de> <20200505140443.GK208718@lunn.ch>
In-Reply-To: <20200505140443.GK208718@lunn.ch>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 5 May 2020 17:34:37 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2Dtr5Ng7tt0ibPkNL565S+7cyYfGxfo4WUftkQ9mxgWw@mail.gmail.com>
Message-ID: <CAK8P3a2Dtr5Ng7tt0ibPkNL565S+7cyYfGxfo4WUftkQ9mxgWw@mail.gmail.com>
Subject: Re: [PATCH] [net-next] dsa: sja1105: dynamically allocate stats structure
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:yBMsXm2HGYg8sUK9ISFYJPBa5Zh9OYPYxhrn4HeznkNc9saoevk
 EBUJ6mAyWlRpoGY+nhYlpQNpoDtf3V+vmdCrzPOp7KWBD0DZjWR5D7c+QW02sB2vAOF5NKB
 AGnVIJ184N9M8wFpcWz3obPPxJ7P9ZhRLTZ4Q/Ark332CNZu5b/yKh+QVcjDEyU+4E4jVxz
 xzqh9TGTQIgHZOjIM93+A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ahYfMqjPmJ8=:Qa4mc42wjBSHKhfVxUB9N+
 3s4eJA7LpiAxcvhQV13VGaVmD3gn/Ld+IMKFWU0LlO5IDzmCUTV1K8+NYLTAmt5go8nN5odzq
 cEtLbmsTjpXK34lO+dsy08D43RoSxhJU/CuQIRRcSFYlk0Bme8wqq1qsL9Zh0RFqP+lPIxsmW
 /JRqMd13Xb4mLPhWBxRLq+QmcYH2s1zc6f2nRBb8r8s8vYyGJ7jtZa6OjsWV2wjulxWv3Kt3i
 kQ218wOwHcD/JjTQOeEoYxkeUpJ5Mzo9wDS0+Pp0aKTIy8et9jaH/57oW8IlaT60GwStFYCsR
 1qTRt+m+/5kBV1M8HD90+ArNaO/8EhbxLLiAVHruiuMMRmAiolf5wzQUFnB0JaHaT7n67eowd
 8AkeotN1ZWLX/NcDNhufoZZnpz6IHbmfZNA2Ebfvp0j9gVxSix1olkTsxTZ7d7CCMqrAPHh6v
 CrstWmRTrjeXnSSyin7OIn3YQ88M826aVhodQx33zg/8rrNRp+2XGANMaUunBdnkfhkSj5I3M
 9ozFd9hVclEJCEG+ZPMR6h85k8LSCn86wQceSHPpqo7I1+y9DxxKydGFY+0R9Us7j0XBDdKSL
 g3i/8SDG4C2sOYTZIbeS21fWU4I9VEeYiLvtHpZRrj0DSwe9sVtUYKE6yNY7PJnFu0cYjGW2q
 CqjJ0WSrMa63xkR/HkP+KHNFRgwoPJlefbXlufAiw/HwBxjRC5QAGZiu4CMVcRXkTFhHbKncg
 RcswhfLTaw4wa/NyXvG/LT1Ws4y3NA0d/teEIHtEv1hgL7aRKOsoKutUzrasidRHdH1EdIQqf
 TN88wcF3MTtFs8XkaHACJVJSpyO5MJ8fK/te0F3oHsVssf8lzw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 4:04 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > -     rc = sja1105_port_status_get(priv, &status, port);
> > +     rc = sja1105_port_status_get(priv, status, port);
> >       if (rc < 0) {
> >               dev_err(ds->dev, "Failed to read port %d counters: %d\n",
> >                       port, rc);
> > -             return;
> > +             goto out;;
>
> Hi Arnd
>
> I expect static checker people will drive by soon with a fix for the ;; :-)

I need to fix the patch up anyway, as it accidentally included an unrelated
change that fails to apply. Fixed now.

      Arnd
