Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9041C8BF3
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgEGNUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:20:19 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:36923 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgEGNUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 09:20:19 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MHVWT-1jJoI23TO5-00DWcT for <netdev@vger.kernel.org>; Thu, 07 May 2020
 15:20:16 +0200
Received: by mail-qk1-f172.google.com with SMTP id b188so5888660qkd.9
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 06:20:15 -0700 (PDT)
X-Gm-Message-State: AGi0PuYmaTiQzAPp5OsFIS7gSR70LehrVrsgLwHKKe4T0RC0pawcztj9
        KdjVV69dD3M3bH487BzGRQ8ndUTj+Mreq2O+t1Y=
X-Google-Smtp-Source: APiQypL0U2yJ/Dg1rnUS/0g63qyrt1AlT1Xsq0c8GDIdF7up9+D+UGYEfBDTGvXU9IeB2pcNVxSgNZizIeuITHvhq5Q=
X-Received: by 2002:a05:620a:3c5:: with SMTP id r5mr14632505qkm.138.1588857614685;
 Thu, 07 May 2020 06:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200507114205.24621-1-geert+renesas@glider.be>
In-Reply-To: <20200507114205.24621-1-geert+renesas@glider.be>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 7 May 2020 15:19:58 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0sDAsG9cnuqMG0Au-KAW1KEx9o-sg3C_dCDh_GmJhNrA@mail.gmail.com>
Message-ID: <CAK8P3a0sDAsG9cnuqMG0Au-KAW1KEx9o-sg3C_dCDh_GmJhNrA@mail.gmail.com>
Subject: Re: [PATCH] via-rhine: Add platform dependencies
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Tony Prisk <linux@prisktech.co.nz>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:/VVGwNEkRv6zXv8sHvSwyaB+Gt0h92HNp0ejSMUSZLMabGOrllO
 +Ry8blwT6eFimgKS51A7rfWMOLkcYjMBqcbGhhksPN9cdeombK3wlm3EBmJDeIIaBxwsfDP
 igW8qy3s6CIiHHoxfRfF9+FQbYLeup9gDQraqZhl1e29pOmDzlXLaBBlMsOG5Ro3JaydZBP
 zBwHMS+OzXdMkuNvoQH5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XUEqf0tDsWo=:Ig2oZXXXzZsdX7zSx41bPa
 IB2wTG8NQrsFKGkKxJGHrCafajbWFF+7PIq25rpifdVl/xxDTo5QrQ67/rdS9Vr5Q4oB1XPnI
 SD2bKDkxW/0K57hhnMXfmjuJxSZ7iIdxTs71fOtKCBAt+4TOoyJaDNArkXd3gqA1ZadFu6tTU
 s3daOrPp3U4+a+OOPe45BIUyXD6UX2/hTxZCoBBHwMdPBtv46rUQa2nW9hsAGJ4QwRNi79Qoe
 dT2P3NkMXXUEWqKUzA6oOuqLjOFYsU2VaE1xGlsWCn9wF/ZvIGANRsfE8L/sLcbaecaH/4rIj
 Xrxj1qr3cOgnx4YeTFt1AYhpLeJ/3eAuKiRvUBqExcoL1bmB9Hfewoypjv+TNG5XwPD4k5EdJ
 1Eu/vQ8D+4otqYcjEKJOLy1plBGjdWbkuZz2+VSefyrhof+BFrNfb0lkNMZ8kbaPIrg9+xBst
 Ix7Z77fI3ESrdPoXt9E0DAJoIU3cietwIINuO/7DAL1DcqE41/jijaa1HI2mcQ8xNynvkKXe/
 3FMdcAqqcHpiqOd4apa+WyoKPGjuyF1ocaVOJNwWl8jlphmW40I1C039tmzVdT6HdeBmNkQOc
 AgPWLQMCC69v0+nJU3p6U6Tv6fzTNZVOALZ/QJRdVrrhV2MStzeUxq0hrQxTOWLKIpVMWvMX0
 QCrvbAROTRTS7xBY6U8lNDdlnis8tZvZYzoq6erEA2V2S+I0kuPm/clKTAKqKMol3CsR0EOrn
 o1PZEKugEKOyX0LqWebM61wG+E8K3JYZXADICU6aqmrsOVQiqxdDukJE0ocvTrzUQLA8Yb+em
 6n8wraachBEGIjnzebmdEqs01prXUx8B1KD6hGsRVBA7TPUYxk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 1:42 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> The VIA Rhine Ethernet interface is only present on PCI devices or
> VIA/WonderMedia VT8500/WM85xx SoCs.  Add platform dependencies to the
> VIA_RHINE config symbol, to avoid asking the user about it when
> configuring a kernel without PCI or VT8500/WM85xx support.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I suppose it might be used on VIA/Zhaoxin SoCs, but presumably those
would always show it as a PCI device.

      Arnd
