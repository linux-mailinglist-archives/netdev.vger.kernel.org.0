Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0384550257
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiFRDNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiFRDNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:13:44 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BA6377E8
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:13:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso5644434pjh.4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+3R73p1YpkdsEB36pSkENvJfhlfKhHswWtFoaKSMUgs=;
        b=NqYqC6ba6WKWnMhN0urAyLRsDRqSBbxd13Y+mZ1awRVeD4zh5B3bE07GYyfjYpJ50Q
         vQFhcO6tqvRCe11ruA9707e12MVmgE2r9Ksu76k+faKAhugXMiswTMXuHvSAC90z2TLd
         qeFtWjfe95o+z9QOtbWXc9aYvYi0c4JdP3n4mkFFEXzfkKRkNGWmV38tk4Vre0MQdLGA
         KF6ivlbJKwoVBgIIbkaBarMXSt1IlNqj+j7FF12go3oGt0HBrterZ2+dIb6yCcnHx8yo
         yzggg7siZA8WLmOBzVePzzsw3qGZpQgHrLoYyp/1pPsh/SWhPwanqNHpfwq6NTD9Xqmk
         5O1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+3R73p1YpkdsEB36pSkENvJfhlfKhHswWtFoaKSMUgs=;
        b=EIfjKQy1t/zOrOEREHrX7jpsIjUss4UaP2EAXQ0YsWLhMklCXGQ3+ye8Hogbct5KFl
         8dxFTA4JyLdHJl6Ru12ICT0sOHkSufmlaezWY8WgL3yX9tYXsLhIXLz0g65aehRLVL4/
         FN8BQErkSRPkTm4s5TYpWJpyhDiH7cG3rOGc2Z9UN00f6sEXnUwKObSOJ8tNd3XwQZWD
         bqe5o0UYfK9emTTtW62ht1pgGn1lFL5fVHsEWrGmatlKgrmfdwArSxCIM2XXK4rbCCY1
         /RiY9oxVG68TnQT8/67qrb0BvBokZ8dJxRXV+qXb/1Y5UILk6uq7JGMaC4EQlv10lduX
         5vcg==
X-Gm-Message-State: AJIora/ZiQVsBY1JVabe4Q7fK1ImHIohekWoISz23LjaYdYVs2/8MPUZ
        iyqXEYAtBSwZuATjT2EBeGKw/I+BpugY1UhneE2V8Q==
X-Google-Smtp-Source: AGRyM1t108ZOi5Xi+QXcifMISL8dRfrkw1rVm2ZTOLE1HZ3Hdu/iFGon427/iHbxvljHmitGqTmLzk/02YjGiwKGEj0=
X-Received: by 2002:a17:902:e48c:b0:16a:9fc:9a7e with SMTP id
 i12-20020a170902e48c00b0016a09fc9a7emr4627977ple.51.1655522022845; Fri, 17
 Jun 2022 20:13:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com> <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com>
In-Reply-To: <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sat, 18 Jun 2022 05:13:06 +0200
Message-ID: <CAMZdPi9wu6KkF0qWEps8iiCwpYKkDHqjXE1vTKhmGhFNmgdP2g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
To:     "moises.veleta" <moises.veleta@linux.intel.com>
Cc:     Madhusmita Sahu <madhusmita.sahu@intel.com>,
        andriy.shevchenko@linux.intel.com,
        chandrashekar.devegowda@intel.com,
        chiranjeevi.rapolu@linux.intel.com, davem@davemloft.net,
        dinesh.sharma@intel.com, haijun.liu@mediatek.com,
        ilpo.jarvinen@linux.intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linuxwwan@intel.com, m.chetan.kumar@intel.com,
        moises.veleta@intel.com, netdev@vger.kernel.org,
        ricardo.martinez@linux.intel.com, ryazanov.s.a@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le ven. 17 juin 2022 =C3=A0 10:32, moises.veleta
<moises.veleta@linux.intel.com> a =C3=A9crit :
>
>
> On 6/16/22 10:29, Loic Poulain wrote:
> > Hi Moises,
> >
> > On Tue, 14 Jun 2022 at 22:58, Moises Veleta
> > <moises.veleta@linux.intel.com> wrote:
> >> From: Haijun Liu <haijun.liu@mediatek.com>
> >>
> >> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> >> communicate with AP and Modem processors respectively. So far only
> >> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
> >> port which requires such channel.
> >>
> >> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> >> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> >> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> >> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> >> ---
> > [...]
> >>   static const struct t7xx_port_conf t7xx_md_port_conf[] =3D {
> >>          {
> >> +               .tx_ch =3D PORT_CH_AP_GNSS_TX,
> >> +               .rx_ch =3D PORT_CH_AP_GNSS_RX,
> >> +               .txq_index =3D Q_IDX_CTRL,
> >> +               .rxq_index =3D Q_IDX_CTRL,
> >> +               .path_id =3D CLDMA_ID_AP,
> >> +               .ops =3D &wwan_sub_port_ops,
> >> +               .name =3D "t7xx_ap_gnss",
> >> +               .port_type =3D WWAN_PORT_AT,
> > Is it really AT protocol here? wouldn't it be possible to expose it
> > via the existing GNSS susbsystem?
> >
> > Regards,
> > Looic
>
> The protocol is AT.
> It is not possible to using the GNSS subsystem as it is meant for
> stand-alone GNSS receivers without a control path. In this case, GNSS
> can used for different use cases, such as Assisted GNSS, Cell ID
> positioning, Geofence, etc. Hence, this requires the use of the AT
> channel on the WWAN subsystem.

Ok, fair enough!


Loic
