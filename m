Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8251DE146
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 09:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgEVHuJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 May 2020 03:50:09 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:34053 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbgEVHuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 03:50:09 -0400
Received: from mail-qv1-f45.google.com ([209.85.219.45]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mofst-1jHtAc11eD-00p4mN; Fri, 22 May 2020 09:50:07 +0200
Received: by mail-qv1-f45.google.com with SMTP id ee19so4306718qvb.11;
        Fri, 22 May 2020 00:50:06 -0700 (PDT)
X-Gm-Message-State: AOAM533tVL5/Oy8+3fIyAqAzY9JniazxXoQZRYjLgo7kJ7flAZmAsZ+P
        2iYMb1jId4hvKgGz5ov5DkWkPfTAC1s7vOHZD40=
X-Google-Smtp-Source: ABdhPJzTX2r7xydKqbJAwhK2+QTpPNnz3LZTzzTI94w3ZoU1ZULE1GyhxQ/7OzXgkRXqp42O1WffI9SLJ6KlmPBCdgc=
X-Received: by 2002:a05:6214:1392:: with SMTP id g18mr2340434qvz.210.1590133805879;
 Fri, 22 May 2020 00:50:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200520112523.30995-1-brgl@bgdev.pl> <20200520112523.30995-7-brgl@bgdev.pl>
 <CAK8P3a3jhrQ3p1JsqMNMOOnfo9t=rAPWaOAwAdDuFMh7wUtZQw@mail.gmail.com>
 <CAMRc=MeuQk9rFDFGWK0ijsiM-r296cVz9Rth8hWhW5Aeeti_cA@mail.gmail.com>
 <CAK8P3a1nhPj6kRhwyXzDK3BGbh66XG6Fmp44QuM1NhFPPBTtPQ@mail.gmail.com> <CAMRc=MfVkbDSfEV71SD57dpYthdx5epD0FOvjRx8qQGT+SgsTQ@mail.gmail.com>
In-Reply-To: <CAMRc=MfVkbDSfEV71SD57dpYthdx5epD0FOvjRx8qQGT+SgsTQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 22 May 2020 09:49:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3qXf2NSDEoMHOQnChZmqQdVF--f_PFFHCyOKPhA=iW_w@mail.gmail.com>
Message-ID: <CAK8P3a3qXf2NSDEoMHOQnChZmqQdVF--f_PFFHCyOKPhA=iW_w@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:NcI0FmX/A+Z6gFWkHmUV9bJwebgW/Sy51Vi1J4RqmHkyFCkcGus
 S9coRpEFv4tqgpmjzXqMHjenqs1I44f3KhmXK3AmI+c/rqsg6spGWX2j2w6nkwE3lF1gWPL
 MOWGB6fkY17nBHu0aUkyuYb/iAUgczTEnV13KvbKg9GRTmRwE0ovOYrSNMnnjhnIZH88tZv
 6H0YAYT/6oplycgU9yQuw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:j+gUOz8bguc=:8Qf7PGky0zEogM8TxWn8DW
 Ne1pNtwtITOkvJDG6CwPIzbpTViXp7SHgWmkL4eXG2hy8T1ialg2ye16tVEYXgfL2Gq8B9E1o
 30VDY2/q7HCoVUJOnbCzwlBYqCZmyQU15uo3ufJUnmjvTxH4ww7NaZD/EOIh5+2DlTeiEQiD1
 wlFWBqporbp0llQz5OMZ+qsQocZlXGclq6a4nYyqy+mYgYqy4DDTes2FrA4VKbd6+wY7CtSV9
 X8BqgJCwyZWjp1O7BpJhqvsy+vV9ZlT3muNT9v3+ojCNRp5WFKnj6ifcisXlqeSczA0BC6vTQ
 69kc5XtR/dInQC3/MKLh//CVVjgZwF7GKklL/No9viS/zABMB8qSoPLaJunprJjNC/blQA6nr
 /LGBGgO6r830hVS6TwMWHZYamrm6VApOwhh03+jA8G3HRX1t4TiRQlhGPMWZ9/93XulZ+1mgk
 xTaUGf9sqRC0y3emK8kcdiT/Or2/Jz7lg4YXwRqCr/+8wogo59b6chnYWxMihexAz/oik9ymT
 tHIyV+E+96FJvda3tM8h2yMVKAbnwob7mkSUpz6+1sQE8qz6kFjfIat96JYcx9ctYzWMlnNN3
 s3IVUuxhnnn+4DaDs1ksJfkXQCT8D9TrH+hhxmqUpMm6hgjQwW6VPHoTZv0TlqKR4qGyn+Iwl
 sl7YGyZf1hwVruyP3bp8E4EM/0Oi11jiOnppnK/1tXjiIgqkKZtbOutgg/OhM10cHOQfayfjH
 6fBmk9YvPGG66TMaIyLrWgwirCE9ms7VQbw8ywx0SuUF8Wz3QewdB/1sckNU2iM2G19444g1W
 Kl4tr7kRTaRu7FPgkR/92PHjqX3bUdPaCTJYzfsxhOFLe3m1Ys=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 9:44 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> śr., 20 maj 2020 o 23:23 Arnd Bergmann <arnd@arndb.de> napisał(a):
> > On Wed, May 20, 2020 at 7:35 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > śr., 20 maj 2020 o 16:37 Arnd Bergmann <arnd@arndb.de> napisał(a):

> > > My thinking was this: if I mask the relevant interrupt (TX/RX
> > > complete) and ack it right away, the status bit will be asserted on
> > > the next packet received/sent but the process won't get interrupted
> > > and when I unmask it, it will fire right away and I won't have to
> > > recheck the status register. I noticed that if I ack it at the end of
> > > napi poll callback, I end up missing certain TX complete interrupts
> > > and end up seeing a lot of retransmissions even if I reread the status
> > > register. I'm not yet sure where this race happens.
> >
> > Right, I see. If you just ack at the end of the poll function, you need
> > to check the rings again to ensure you did not miss an interrupt
> > between checking observing both rings to be empty and the irq-ack.
> >
> > I suspect it's still cheaper to check the two rings with an uncached
> > read from memory than to to do the read-modify-write on the mmio,
> > but you'd have to measure that to be sure.
> >
>
> Unfortunately the PHY on the board I have is 100Mbps which is the
> limiting factor in benchmarking this driver. :(
>
> If you're fine with this - I'd like to fix the minor issues you
> pointed out and stick with the current approach for now. We can always
> fix the implementation in the future once a board with a Gigabit PHY
> is out. Most ethernet drivers don't use such fine-grained interrupt
> control anyway. I expect the performance differences to be miniscule
> really.

Ok, fair enough. The BQL limiting is the part that matters the most
for performance on slow lines (preventing long latencies from
buffer bloat), and  you have that now.

       Arnd
