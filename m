Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20181E34BE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgE0Baz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgE0Baz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 21:30:55 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA1EC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 18:30:52 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id x29so4759047qtv.4
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 18:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pumpkinnet-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T399jxmluAL6GYrVs/c9Tg7xwcBs0iovgEru9FwLBU0=;
        b=JCX6QQUlnGi7m79AsZ2+GiW1ugmYSDmml1HCRvW2kfQ38gBFhWLQFggjq/IELQ29CQ
         NWUZsYXcJuHj9iprGfZnTrkcQTYgir5pc+PfNjiFoYWiBt7kACFZ49M0sNF/qKAxx2pN
         nIC2wBB6DBTaOrQEbYIG3tySrjKxH1eLe1iItPn21A40hnfGkH88sfFlsNNZwvj0Vu9b
         0ENQ5bRcL5OyfhS+MYuOXbUvMWDG6AQ2SMDf9xclwtrbIb+WrjkNPn9p3NecNkm6mbB7
         SLKTdZi3D6xjrHDE4O6eEjOVonJLq46H7AoQ0MTqBbZAFHtCVHnUk60M4lMZT/JfySv1
         9p0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T399jxmluAL6GYrVs/c9Tg7xwcBs0iovgEru9FwLBU0=;
        b=jVbk8KgmsyTUCBBZcvVEOibD5Z2RilsSpW/PkJFVYC7yGE2eLwCbA7DJCB47AtGK/R
         37MIpu5BE6Ij9VezhoE5UnDIDMqcl02uPGiPldJrbxGuWy5YOLUF+A8IjCuM6ZsG6RRu
         RI8Mu1oYy8CTaUL+0SKQG6xo6wK5tvScF4TvRiFeoPOmxoBZb/ftgdSb7JbYrmTHFOBh
         mwkxzmi40VZ81iGinVEw5hdlXo3nlmT5yxecu+4E0c7GYzdnsdXQ+u+EYlal2Hbd50nj
         Mph8Ba09iaMltkBZGtRmOSdBJC0tW+std7qaC6ZGey8k+wBif+ViYLS0tZBrQHwUlMa8
         EeTg==
X-Gm-Message-State: AOAM532W2YfFE4Xdp8cepFlkWz01oqaN1iMGETLPv6G7eTS0binZEOcr
        3eQuTcKn8t+3BUMM+f4XeZhP2WlWM6DK1RxDNWluGqogI/E=
X-Google-Smtp-Source: ABdhPJwrzCL3KoqUgVTI2InQ9XCdMbyFbX8skWLsP8pmJDBSlYKi15MAilhhWT++D4utpizXwsu2azkAs14sreGwnqk=
X-Received: by 2002:ac8:ec7:: with SMTP id w7mr1784299qti.197.1590543052059;
 Tue, 26 May 2020 18:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <CALMTMJJG7-VmS7pa2bgH=YsmgUJzi=YSnO8OtKpW=VyjyXWTkQ@mail.gmail.com>
 <20200526075417.n2xdtzpwnpu3vzxx@lion.mk-sys.cz>
In-Reply-To: <20200526075417.n2xdtzpwnpu3vzxx@lion.mk-sys.cz>
From:   =?UTF-8?B?6rCV7Jyg6rG0?= <yugun819@pumpkinnet.com>
Date:   Wed, 27 May 2020 10:30:42 +0900
Message-ID: <CALMTMJLJYP=FSVFhwLqBLuKC6jNk-Bas1jjkJM+OvuNkt5jETQ@mail.gmail.com>
Subject: Re: With regard to processing overlapping fragment packet
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for explaining in detail and letting me know the website.

thanks to you, I learned a little about how to RFC works.


2020=EB=85=84 5=EC=9B=94 26=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 4:54, M=
ichal Kubecek <mkubecek@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Tue, May 26, 2020 at 02:47:25PM +0900, =EA=B0=95=EC=9C=A0=EA=B1=B4 wro=
te:
> > Hello
> >
> > Actually, I'm not sure if it's right to send mail here.
> >
> > I'm testing ipv6ready Self Test 5.0.4 using linux-4.19.118 kernel.
> > ( https://www.ipv6ready.org.cn/home/views/default/resource/logo/phase2-=
core/index.htm
> > )
> >
> > Test failed in 82. Part B: Reverse Order Fragments ( Link-Local ) in
> > Section 1. spec
> >
> > In test 82, source transmits 3 fragment packets in reverse order that
> > are originally a icmpv6 packet.
> > There is an overlapping interval between the 2nd and 3rd packet.
> >
> > The test requires the destination MUST drop all packets and respond not=
hing,
> > but the dest replies Time Exceeded / Reassembly Timeout.
> >
> > I've read some /net/ipv6 codes and think when the kernel receives the
> > 2nd packet ( overlapping occurs ), it drops 3rd and 2nd packets and
> > recognizes the 1st packet as a new fragment packet.
> > ( Is it right ? )
> >
> > In RFC5722, when a node receives the overlapping fragment, it MUST
> > discard those not yet received. (  In this case, I think it applies to
> > 1st packet )
> >
> > Please let me know if I misunderstood RFC or if it wasn't implemented
> > in the kernel.
>
> You understood the requirement of the RFC correctly but the problem is
> that implementing it would be too complicated, would make the
> implementation susceptible to DoS attacks and could even result in
> dropping legitimate (new) fragments. Therefore an erratum to RFC 5722
> was accepted which drops the requirement to also drop fragments not
> received yet:
>
>   https://www.rfc-editor.org/errata/eid3089
>
> Michal



--=20


=EA=B0=95 =EC=9C=A0 =EA=B1=B4 =EC=82=AC=EC=9B=90

=ED=8E=8C=ED=82=A8=EB=84=A4=ED=8A=B8=EC=9B=8D=EC=8A=A4=E3=88=9C =EA=B0=9C=
=EB=B0=9C1=ED=8C=80

08380 =EC=84=9C=EC=9A=B8=EC=8B=9C =EA=B5=AC=EB=A1=9C=EA=B5=AC =EB=94=94=EC=
=A7=80=ED=84=B8=EB=A1=9C31=EA=B8=B8 20 =EC=97=90=EC=9D=B4=EC=8A=A4=ED=85=8C=
=ED=81=AC=EB=85=B8=ED=83=80=EC=9B=8C 5=EC=B0=A8 405=ED=98=B8

Direct: 070-4263-9937

Mobile: 010-9887-3517

E-mail: yugun819@pumpkinnet.com

Tel: 02-863-9380, Fax: 02-2109-6675

www.pumpkinnet.co.kr
