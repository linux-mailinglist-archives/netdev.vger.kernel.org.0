Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E0A5E5F5
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfGCOCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:02:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42275 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCOCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:02:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id z25so2192975edq.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aeStSFOkTsadATmiRlRxF0BaV7V2c9DiehvDdkg1e8s=;
        b=t9TY8J1vMoDEXrYxDBls2w5eeTkkpap78bxf1FIaKgXPrjOcnxOEBUwfWBdrnipJsk
         PBIfxy3kNvGzOTnpco2snzQ+EIh5M+0cUyjQphK8m+UTEFIGBG7v42IbQN08izN+4E5g
         q2m6dzocmimWdCM/9uJn/4MQJf+7nHJUa8K4sMghsm7IE9vNyWtgoFQCUet+3yK+XHOP
         Alx9n2dbUDkuvquflgSIGtCa2ujWS0Q/DmIGSjr4LeIzv8jebXpqVTT3F3evxzHLQRoh
         0nOdCkWaj0sJroPXHsYx4ciJ0ZglX/XhzpSyTxUG62PNw09F0gnTU7aT6m5UCA5JTZzv
         smkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aeStSFOkTsadATmiRlRxF0BaV7V2c9DiehvDdkg1e8s=;
        b=Tpd6wy7hEw2KZ2O1k1WAs4BhluTWiwOTARnUj/Y3TAH2BTqQ+drd9HYl4ATVhWmfxi
         8zPwlwboy+rHE9p7Sm9XNOe5giRFycnLDlWURr05iesNy4YqN1gdoMuf9FGzD3IZ6tBA
         LgRX2GW6jVBS5B2Y8am56AW8zxZVNpSUqBVmg1WC0x4E6R4WtZignZ5wlGGHjYPuRBYQ
         edHjWMxYKPzfxNR3cOGunCmu5mZFm659KNNwhFfXj5zCY2j+RHBULuhv6m78h3ncdGH6
         4QXUO/OiGFroSAxWYOLBk+gM/Q86nsppMDzkL43CV2/FdQ8LKXoOqJtRT9/e2QAwdvYD
         0AsQ==
X-Gm-Message-State: APjAAAUygIrOr0ooeJ2qnoiOPYe++KD9e+rAVAFw2eoy35wzhllV+lGF
        UjX7+J1snj06xL92JoMrNYlghja1g5Tk63KuX3Y=
X-Google-Smtp-Source: APXvYqyZzLRmuVl3iTUdl6SoZZTxXQcV3TfTBx3d2+Kbimz+Cvmndwt1tErw63WUiomFqKZVqV4mQGxEh9Nxk/WcJcQ=
X-Received: by 2002:a50:a3ec:: with SMTP id t41mr42769567edb.43.1562162570373;
 Wed, 03 Jul 2019 07:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
 <CA+FuTSd3DaYsY1o_GFp-X=uRkfb6i0PUPbUsUagERmAZS+Hd7Q@mail.gmail.com> <CAK+XE==_AahZczgb4hU9auoj8=Kcx66JEdK3ZQ3TYpQuxdT05A@mail.gmail.com>
In-Reply-To: <CAK+XE==_AahZczgb4hU9auoj8=Kcx66JEdK3ZQ3TYpQuxdT05A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Jul 2019 10:02:14 -0400
Message-ID: <CAF=yD-LsMtAVLU_dnQFPUVeTNZT6saO-ZNeptVsoY_NkQFbbBQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/5] Add MPLS actions to TC
To:     John Hurley <john.hurley@netronome.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 4:33 AM John Hurley <john.hurley@netronome.com> wrote:
>
> On Wed, Jul 3, 2019 at 3:19 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Jul 2, 2019 at 8:32 PM John Hurley <john.hurley@netronome.com> wrote:
> > >
> > > This patchset introduces a new TC action module that allows the
> > > manipulation of the MPLS headers of packets. The code impliments
> > > functionality including push, pop, and modify.
> > >
> > > Also included are tests for the new funtionality. Note that these will
> > > require iproute2 changes to be submitted soon.
> > >
> > > NOTE: these patches are applied to net-next along with the patch:
> > > [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
> > > This patch has been accepted into net but, at time of posting, is not yet
> > > in net-next.
> > >
> > > v4-v5:
> > > - move mpls_hdr() call to after skb_ensure_writable - patch 3
> > >   (Willem de Bruijn)
> > > - move mpls_dec_ttl to helper - patch 4 (Willem de Bruijn)
> > > - add iproute2 usage example to commit msg - patch 4 (David Ahern)
> > > - align label validation with mpls core code - patch 4 (David Ahern)
> > > - improve extack message for no proto in mpls pop - patch 4 (David Ahern)
> > > v3-v4:
> > > - refactor and reuse OvS code (Cong Wang)
> > > - use csum API rather than skb_post*rscum to update skb->csum (Cong Wang)
> > > - remove unnecessary warning (Cong Wang)
> > > - add comments to uapi attributes (David Ahern)
> > > - set strict type policy check for TCA_MPLS_UNSPEC (David Ahern)
> > > - expand/improve extack messages (David Ahern)
> > > - add option to manually set BOS
> > > v2-v3:
> > > - remove a few unnecessary line breaks (Jiri Pirko)
> > > - retract hw offload patch from set (resubmit with driver changes) (Jiri)
> > > v1->v2:
> > > - ensure TCA_ID_MPLS does not conflict with TCA_ID_CTINFO (Davide Caratti)
> > >
> > > John Hurley (5):
> > >   net: core: move push MPLS functionality from OvS to core helper
> > >   net: core: move pop MPLS functionality from OvS to core helper
> > >   net: core: add MPLS update core helper and use in OvS
> > >   net: sched: add mpls manipulation actions to TC
> > >   selftests: tc-tests: actions: add MPLS tests
> >
> > Reviewed-by: Willem de Bruijn <willemb@google.com>
> >
> > I did have some conflicts applying the patches from patchwork (to diff
> > v4 vs v5). Might be my process. This is clean against net-next, right?
>
> Hi Willem, thanks for review.
> See the note in the cover letter....
> We had a patch accepted into net earlier in the week, these patches
> are applied to net-next + that patch.
> Unfortunately when we applied the patches direct to net-next and tried
> to merge in net then we got merge conflicts that needed manually
> fixed.
> Basically, the above patches should apply cleanly to net-next once net
> has been merged in.

Ah, that explains. Excellent, thanks for the follow-up. I had missed
that point in the cover letter (clearly).
