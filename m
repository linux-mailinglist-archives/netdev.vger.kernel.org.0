Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A2D565A97
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 18:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbiGDQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 12:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiGDQE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 12:04:26 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9B9E099
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:04:26 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-10c0d96953fso169974fac.0
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 09:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3/PwP8vp4X/RXwbbNePH5z20rctoJvcaQ3Bp7ubnJmw=;
        b=w+Ypr5OOP/7ISgJjB2QjQZnpFsHHsPBH55tkZkEBSQFyQB2u2UjwIxw5D6UZuJ2ccC
         iBnarPfejvyDSYciQrfUbTtL9o6mCTJROaUDW9N3X0D8M1I4xDytIqH0xRuk0lQyVpeN
         9sBWlcBrme+X6SI7LE8V2yv/NvhjbrZvAGIlnJv7U/qHBrQ66NnhztBBXKMldNaB9KBR
         ly3Lh9h/QEAWEuvPCRws3lS7yoUFlCyYGVJebqma2mv1sfyScXOcLj6NHVoSkMTsg6OL
         JNZJQYENHYBEL6+qBbIhCOEpnqQqquct7hP/4AGE91K/Ir/OOFT5yWz0aO1f7KPiI9Kt
         SHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3/PwP8vp4X/RXwbbNePH5z20rctoJvcaQ3Bp7ubnJmw=;
        b=rQIRgTNn3amHiLQoMie1uzJakmWACQUzKh2w/71p7lLeJW3VH980radY2y1qkxh17A
         7EiqWztGLD97D+K27AWBMBiXobi741Mf2k+x4QIuiBe6LfO2/sabH0FduinlAPtGwLvA
         Uu2rkgOO3KKFOwbKNb5cDDOAnkD5rlPBfZaSyHfXziiW8VzSdLgRi74I0WfSEzxsli5k
         rMbvWDhiY48bkDYwY7av8iKPKsVp0A8c6ApiFCWcnuYa2FZAK3cM/pWksXZb6Yc12zx5
         i9WescbXlapSPAqJ7mnvkpsriuezKWuFHcFldET221kCq1CJdGy3U9x4DicHzO4VhbFs
         mu3w==
X-Gm-Message-State: AJIora+aWfF9np2vA+mq/cTWhjI4F+lbBa5/BILJhCXT34e9WcfZTjrF
        bL0mgi1qkGoyQ844dfKgOrr2ygXZcIthOkOG71j/vTXyBq5ZRQ==
X-Google-Smtp-Source: AGRyM1sNcv9pB/hCz0MB/ODDULs9OiUBU5H7jpPNRSgTIbpSLOnwoBkiFke1nnQQCaZBvBnD9EiCg/HMsjDoN4pjj2I=
X-Received: by 2002:a05:6870:a191:b0:10b:f366:8d1b with SMTP id
 a17-20020a056870a19100b0010bf3668d1bmr4577998oaf.2.1656950665581; Mon, 04 Jul
 2022 09:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
In-Reply-To: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 4 Jul 2022 12:04:14 -0400
Message-ID: <CAM0EoMnNAFXSAVe0yodvrBcn6bEfV0=fKknOcHDgL7mOZ1BE0w@mail.gmail.com>
Subject: Re: Report: iproute2 build broken?
To:     Petr Machata <petrm@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should have said this is a really old system, but shouldnt really matter, y=
es?

$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description: Ubuntu 16.04.7 LTS
Release: 16.04
Codename: xenial
hadi@vindaloo:~/sample-iproute2-p4tc$ uname -a
Linux vindaloo 4.4.0-210-generic #242-Ubuntu SMP Fri Apr 16 09:57:56
UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

cheers,
jamal

On Mon, Jul 4, 2022 at 11:51 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> I have to admit i am being lazy here digging into the
> root cause but normally iproute2 should just build
> standalone regardless especially when it is a stable
> version:
>
> $ cat include/version.h
> static const char version[] =3D "5.18.0";
>
> $make
> ..
> ....
> .....
>   CC       iplink_bond.o
> iplink_bond.c:935:10: error: initializer element is not constant
>   .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
>           ^
> iplink_bond.c:935:10: note: (near initialization for
> =E2=80=98ipstats_stat_desc_xstats_bond_lacp.desc=E2=80=99)
> iplink_bond.c:957:10: error: initializer element is not constant
>   .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
>           ^
> iplink_bond.c:957:10: note: (near initialization for
> =E2=80=98ipstats_stat_desc_xstats_slave_bond_lacp.desc=E2=80=99)
> ../config.mk:40: recipe for target 'iplink_bond.o' failed
> make[1]: *** [iplink_bond.o] Error 1
> Makefile:77: recipe for target 'all' failed
> make: *** [all] Error 2
>
> There's more if you fix that one given a whole lot
> of dependencies
>
> cheers,
> jamal
