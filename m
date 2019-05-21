Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A6B24DC2
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfEULQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:16:25 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:34936 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfEULQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 07:16:25 -0400
Received: by mail-yb1-f176.google.com with SMTP id k202so6962533ybk.2;
        Tue, 21 May 2019 04:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qHKESFWu3uVEowXVX/MvPCRT+aTkRC4ea2S7JZT1F1I=;
        b=cDYa5bjjEi5TiX7BKmIemQ4LmfzVf2nUsVGq64Kc/mu8g7xa6JqtsS6oDAJ+ZU+HER
         yDCjQZae2XQqGv/Pw5bvHHmGM3g8e5dTKPNPQiWYpAYaOWVM+SItOzvYjBSsffBDY8sN
         brOJ/RbEA+HJa/SANyea38MIANy2ZYu2mmPTzpLynR/MbziBvxAme8PkYlKM3bxMA0nm
         nJxsc5/ak7Uv1x+IRKS3KgH2COieezeVCSCZ1kL3wGXM/2P1gY9nx7BsEErP7DIbBrCE
         2raAMhom4F4qpS9UFBf3rsfjDiXCPu2wO3l+4sqfmAVjBKOv3zPHybzfqSKgjPKsn1fN
         xPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qHKESFWu3uVEowXVX/MvPCRT+aTkRC4ea2S7JZT1F1I=;
        b=oxAn1z8Spizo/mEhqkv4b5q4sQyOdvRpNhir3QndMlKiDlqz+vy1OP82hcXVI7yYdw
         B4ImL+cqL+9RcgQfNb3IpPVov+9KaYhI2rHRdOKlO6yP8mTpsrN1JsefVCGarJJ2b45s
         30BWHSRUslMh2pwW/UXD2bYFoVuiGgOAkiu8x2uLe8FIH4YHQ4EEQUdsjpxCMO34agmf
         NKUMHy1bcJOr5yld/fn2HPjNCK/OsLdpEG04xzMYzeCu+i2BmjqtGm1NRezV/8jfVG9q
         hOGkNbDMzmHDKXfBi00q5yAaPRc9tpD6SaR4PdbnD8WqEPIfJpYY3kwKbjwoIWZ3fN/0
         mMrg==
X-Gm-Message-State: APjAAAUW+R1/D3Exeq2b3y3+1+Sl38a0wTMZYZYa8rqALeHtBgibtblz
        1g/yOs3YPprrfMYdSjo8I1coAFePj4quov10eMM=
X-Google-Smtp-Source: APXvYqzx693vHzn03Sj+D9wBGIXnVqz/1AaF0r6ryn52oijxf7HsQVy+WYRTWMopirlPQg2lq8f8gGRY2he9l206H/Y=
X-Received: by 2002:a25:c6c9:: with SMTP id k192mr3210217ybf.2.1558437383800;
 Tue, 21 May 2019 04:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com> <20190521104512.2r67fydrgniwqaja@shell.armlinux.org.uk>
In-Reply-To: <20190521104512.2r67fydrgniwqaja@shell.armlinux.org.uk>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Tue, 21 May 2019 13:16:12 +0200
Message-ID: <CACna6ryVxFr8ho3ekY4Q_J=TamVLv9ZMDaHJFUGcEGSRrSVaHA@mail.gmail.com>
Subject: Re: ARM router NAT performance affected by random/unrelated commits
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, John Crispin <john@phrozen.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Jo-Philipp Wich <jo@mein.io>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 at 12:45, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> On Tue, May 21, 2019 at 12:28:48PM +0200, Rafa=C5=82 Mi=C5=82ecki wrote:
> > I work on home routers based on Broadcom's Northstar SoCs. Those device=
s
> > have ARM Cortex-A9 and most of them are dual-core.
> >
> > As for home routers, my main concern is network performance. That CPU
> > isn't powerful enough to handle gigabit traffic so all kind of
> > optimizations do matter. I noticed some unexpected changes in NAT
> > performance when switching between kernels.
> >
> > My hardware is BCM47094 SoC (dual core ARM) with integrated network
> > controller and external BCM53012 switch.
>
> Guessing, I'd say it's to do with the placement of code wrt cachelines.

That was my guess as well, that's why I tried "cachestat" tool.


> You could try aligning some of the cache flushing code to a cache line
> and see what effect that has.

Can you give me some extra hint on how to do that, please? I tried
searching for it a bit but I didn't find any clear article on that
matter.

--=20
Rafa=C5=82
