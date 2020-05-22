Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959E51DF034
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbgEVTvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgEVTvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:51:45 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55FAC061A0E;
        Fri, 22 May 2020 12:51:43 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id d26so9121128otc.7;
        Fri, 22 May 2020 12:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b8FZX+nftbc+SKdkbfZ0jaN3DqHCHRISicTeM0AJ9qw=;
        b=puTxNQT9WgfAtBnS3NBwfDy5jAahNiPMwQocJgD00v48PCl0zrrn5I60y4koiZVPH7
         sqp1rqt9Ledw32vAGSFWXIy+V0sxlWKtRHG4MH44a29z68QgOvbxxJBJcHl78RdLgVuj
         2Mzg7UxAZ8E4ReELYJeJI/xBKAmcejkNo66c6PmqdYxpjck/8m1cZEmpvbfADgUrHsZN
         CA+h0JIa2Akgiq+m9mATTEDNsxYlqeutkSi5eFUEnn9bkorY77H7F4OjClJLoLEHd1iE
         GfSg+YHNdUkjRqSX6TDznrhRTsxHm6OIZRRCyG9S2gfXbqetngFKoV4rvIeXvcQHvKnr
         m5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b8FZX+nftbc+SKdkbfZ0jaN3DqHCHRISicTeM0AJ9qw=;
        b=ZY9+IccQyFEVYBP9ZLNkEmgiJK0FmnQKeIbk6sD1ST0Q6H06Q3mB4NAoaXyXYKYShG
         Fc+/RowWXauKNqdB17P0cKtByIXTRCVBnA8U2pfNbvr2zvPtsU24zqMwe6TPJt3Pw6L2
         CMzlVZ/mO22tjBvQnPYnKzjLNuLQZmhIonX/CHTVSZYXqWwZt3l6tQhshbiBTwZMvz5C
         Eh+ueBBsLO3GAhfGcfDwJ0ef38dV/2rAFLHKWI9nFVxeeLAGjGAez7NEMJJkmMp8RElO
         oMcB3i9Hw6YgZEL2gRb+NyVE6Udmu34i0M/7JhPgBEUnQNEIjygzhezvW7yqicUQXC0c
         PRJg==
X-Gm-Message-State: AOAM532ADNETkA3UB6YZD6e/buM0aXycZk75t0nt05/xazhWqnxngge9
        zW5XsFRg/sFdEPUbwBqcJ5rysw2gGf3vTbLllNI=
X-Google-Smtp-Source: ABdhPJw5UA72kl7SeHTeZeK+symvY2nsNbsfG4ILMGP8gAmiWbkx/KmHYd1hkMFKlOKn8SWPc8P+kMbtFUVYXK++Bg4=
X-Received: by 2002:a05:6830:18c7:: with SMTP id v7mr13135390ote.48.1590177103122;
 Fri, 22 May 2020 12:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <3c51bea5-b7f5-f64d-eaf2-b4dcba82ce16@infradead.org>
 <CAM_iQpV62Vt2yXS9oYrkP-_e1wViYRQ05ASEu4hnB0BsLxEp4w@mail.gmail.com> <6c1c6fec-a3fa-f368-ae40-189a8f062068@infradead.org>
In-Reply-To: <6c1c6fec-a3fa-f368-ae40-189a8f062068@infradead.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 22 May 2020 12:51:31 -0700
Message-ID: <CAM_iQpUkAPF6Ks0SZuDofrcckavaLXGGvtiZJjLp51o6_Je4tw@mail.gmail.com>
Subject: Re: [PATCH -net-next] net: psample: depends on INET
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Yotam Gigi <yotam.gi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 12:48 PM Randy Dunlap <rdunlap@infradead.org> wrote=
:
>
> On 5/22/20 12:17 PM, Cong Wang wrote:
> > On Fri, May 22, 2020 at 12:03 PM Randy Dunlap <rdunlap@infradead.org> w=
rote:
> >>
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >>
> >> Fix psample build error when CONFIG_INET is not set/enabled.
> >> PSAMPLE should depend on INET instead of NET since
> >> ip_tunnel_info_opts() is only present for CONFIG_INET.
> >>
> >> ../net/psample/psample.c: In function =E2=80=98__psample_ip_tun_to_nla=
ttr=E2=80=99:
> >> ../net/psample/psample.c:216:25: error: implicit declaration of functi=
on =E2=80=98ip_tunnel_info_opts=E2=80=99; did you mean =E2=80=98ip_tunnel_i=
nfo_opts_set=E2=80=99? [-Werror=3Dimplicit-function-declaration]
> >
> > Or just make this tunnel support optional. psample does not
> > require it to function correctly.
>
> Sure, I thought of that, but it's not clear to me which bits of it
> to make optional, so I'll leave it for its maintainer to handle.

The code commit d8bed686ab96169ac80b497d1cbed89300d97f83
adds is optional, so it can be just put into #ifdef's.

Thanks.
