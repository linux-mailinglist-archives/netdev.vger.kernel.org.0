Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949366BD89
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 15:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfGQNpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 09:45:18 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33439 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfGQNpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 09:45:18 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so45844682iog.0
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 06:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mbl8YmmO8Lpw3elEOfJHgecO7gWqGVg4O7JvZVM5PPU=;
        b=O20ad61anrYtioh62yaK5z00XokZYSy4jT56hrN65DZhjmIuqGMhOJq/fFSSDHMUj3
         N9+woqVNvNClZV/hdb4Ir5kYj1HUAkePCSYUalYJQKGGbVuOFTwjn+ks88p3jd79L4Vs
         q+NzotFx70i5qTS5Uf+DXaj7VXHcZ6GRNAEel2JMBZlV2VfLX79AV/T+hvuTpgcXa2bc
         RzMFFjBaRJaa0EpFIBlwIeTQRAoUe3Ci76DZPnU0I0ToS0dpgGAaxtqRK5KgyHnaD0xw
         qwazK/esKqZTGh45fM4J9JWBNdulZbL2BJ4wiTIYV2r0zeiqRCB+1tvNm2iSmQNiEEwP
         EDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mbl8YmmO8Lpw3elEOfJHgecO7gWqGVg4O7JvZVM5PPU=;
        b=b05XBkx/f/h3jHGM/3FlIxP4IdyLJRdVhaGDdN0fGIFKPjGBZA1R91few//KN9qmy3
         wGJk9k++VlHsaPKLsNVSVof0jLQVJaxALD5K75sd68xyqhGVIpB6aiyZzbfxqMlS2jO9
         WdSHCv3N5YwVl5PCPfN8BXBQGwzB9pDb4vhchzcqcbIbT0F3iHlbrIf1TroaDacFzAds
         Simx7IfoYvCPb73XtiM1LvCHWVwOoILmfjraIluUiUCSZTyUDXa/mUgRvQpoeRAvOD89
         2q9kTaCLHgjBsq1G6Xjz9yYRv8Ss5brT4eajOuIqzwd7yepICjIlGRk4/eh79ILaJZ4i
         WxJA==
X-Gm-Message-State: APjAAAWp/aZQIzz4DQ4J0rSAFqyGqh8NNgNNo4Y5kwi3N3cqize7E8eK
        q0beogdiajcY0XaO1Ij9KotEmlBNH0524OAnMIE=
X-Google-Smtp-Source: APXvYqyrgNd4qZT6TsSdpmeGjjjWitdf3KMG36p59h2vdoJRYL5sNnT3qpPrZYxrXlwM2PzqX+hKaI1l0rRtkkloJlE=
X-Received: by 2002:a5e:8b43:: with SMTP id z3mr34367028iom.287.1563371117757;
 Wed, 17 Jul 2019 06:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAOp4FwSB_FRhpf1H0CdkvfgeYKc53E56yMkQViW4_w_9dY0CVg@mail.gmail.com>
 <CAOp4FwQszD4ocAx6hWud5uvzv5EtuTOpYqJ10XhR5gxkXSZvFQ@mail.gmail.com>
In-Reply-To: <CAOp4FwQszD4ocAx6hWud5uvzv5EtuTOpYqJ10XhR5gxkXSZvFQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 17 Jul 2019 06:45:05 -0700
Message-ID: <CAA93jw7raM7F6jmXGbPyekCtjdhFmobk5sKXnNqJMeE+w1Goyg@mail.gmail.com>
Subject: Re: Request for backport of 96125bf9985a75db00496dd2bc9249b777d2b19b
To:     Loganaden Velvindron <loganaden@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 11:01 AM Loganaden Velvindron
<loganaden@gmail.com> wrote:
>
> On Fri, Jul 5, 2019 at 6:15 PM Loganaden Velvindron <loganaden@gmail.com>=
 wrote:
> >
> > Hi folks,
> >
> > I read the guidelines for LTS/stable.
> > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> >
> >
> > Although this is not a bugfix, I am humbly submitting a request so
> > that commit id
> > -- 96125bf9985a75db00496dd2bc9249b777d2b19b Allow 0.0.0.0/8 as a valid
> > address range --  is backported to all LTS kernels.
> >
> > My motivation for such a request is that we need this patch to be as
> > widely deployed as possible and as early as possible for interop and
> > hopefully move into better utilization of ipv4 addresses space. Hence
> > my request for it be added to -stable.
> >
>
> Any feedback ?
>
> > Kind regards,
> > //Logan

I am perfectly willing to wait a year or so on the -stable front to
see what, if any, problems that ensue from mainlining this in 5.3.
It's straightforward for distros that wish to do this backport (like
openwrt) to do it now, and other OSes will take longer than this to
adopt, regardless.


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
