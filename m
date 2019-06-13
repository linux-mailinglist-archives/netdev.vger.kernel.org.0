Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E63438F6
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbfFMPKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:10:23 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33570 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732317AbfFMNxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 09:53:50 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so17053351iop.0
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iy4kcV8V3bugp9lty2e2nSoevV5qZqBm81DcW1Ay6zU=;
        b=uTUhls9hZ+sh3/vt2tX8/fOHKnEcq8eddgIJntGFgJfY6M/+vw/3b8BU9UynFWjOz4
         MlsuGWklHwDpbt012HGD2uR/IV04sZoYMyEzRK6nXvpCXcUsR0xW0YK8128OS8N3s/zw
         AHHFoPJbX4q4D5NWdlc1HKQKeO2xeh4FLSCXrv6hZqNt3pyDt4WNND7EX2spN8aGKX7y
         xSgy3kOm+/ivYYXtkCPlm1U8ujOjsmJDrnXaNj+Dpve2j1OWDXtaFg+MDt7x4SlDa48S
         KWl/jm2z7UXgFZlP6ek4DFpNVfAcmN73kDnCcOFroEKkmfx2md3hezzvgMiHhXbQ0WZg
         1yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iy4kcV8V3bugp9lty2e2nSoevV5qZqBm81DcW1Ay6zU=;
        b=pTm1kbzvM5KXsSMoQjJutCN2ONh/MrvaUztrYEZz9fIjVoW0Co6DbGg4X4oTd1oAAb
         l5Mo2O/RIW1XBdUBFwDAoEtVR5ImOj8gTSdAneQ2DZ4KC3SWmLp3UDnuKCZtpt/OKU/h
         9PlkHlXYN8rmnuwIdOzkmdqtcDZ/NRFh6VYaxJmzqinh24gYKW7JS/opkPSNHhnpd55g
         94ZV8wdEMISLUvFqFGzjyGs6wgU/esPFEv+aSiNvjNX1dikaVlXCgMiqr78n6dlbrndX
         gNx56IuQ8dy2SD1/2q/8bJl1xA/tQiXIMhfyBLWdVy7D/QQIhEabNRXWjGgqWOR9FeT3
         cg/A==
X-Gm-Message-State: APjAAAXc7pzua8/a8I9/duoSuo3Aj1FOd8UH1CtHvI5lL+Y90p7W0Irn
        /Z0hr4zwk6vRMU1Od4J5cquMu4VXvxfMYmdKMjhxcg==
X-Google-Smtp-Source: APXvYqz2As5FCEjQnMKV69TJxJEoi9nRFBCyqGMsT3xTLpETriamdwHl1/b04/jnJji+vuVKJrD10JuLa0Yd9F58F/M=
X-Received: by 2002:a5e:c30f:: with SMTP id a15mr6692679iok.246.1560434028998;
 Thu, 13 Jun 2019 06:53:48 -0700 (PDT)
MIME-Version: 1.0
References: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
 <1560343906-19426-2-git-send-email-john.hurley@netronome.com> <b0c97579d77ef09f73ee940e27fae2a595402888.camel@redhat.com>
In-Reply-To: <b0c97579d77ef09f73ee940e27fae2a595402888.camel@redhat.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Thu, 13 Jun 2019 14:53:38 +0100
Message-ID: <CAK+XE=k0NV02T=xijf19t_aX5znc1m_5ExQj4CF3eQ3f0oOo2A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: sched: add mpls manipulation actions to TC
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 2:20 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello John!
>
> On Wed, 2019-06-12 at 13:51 +0100, John Hurley wrote:
> > Currently, TC offers the ability to match on the MPLS fields of a packet
> > through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> > actions do not allow the modification or manipulation of such fields.
> >
> > Add a new module that registers TC action ops to allow manipulation of
> > MPLS. This includes the ability to push and pop headers as well as modify
> > the contents of new or existing headers. A further action to decrement the
> > TTL field of an MPLS header is also provided.
> >
> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> > Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
> [...]
>
> > index a93680f..197621a 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -83,6 +83,7 @@ enum {
> >  #define TCA_ACT_SIMP 22
> >  #define TCA_ACT_IFE 25
> >  #define TCA_ACT_SAMPLE 26
> > +#define TCA_ACT_MPLS 27
>
> like I mentioned in my reply to "[PATCH net-next 1/3] net/sched: Introduce
> action ct", I think that 27 is forbidden on net-next: this number is
> already used in the uAPI for TCA_ID_CTINFO (see below). Like suggested in
> the comment above the definition of TCA_ACT_GACT, it's sufficient to add
> TCA_ID_MPLS in the enum below.
>
> >  /* Action type identifiers*/
> >  enum tca_id {
> > @@ -104,6 +105,7 @@ enum tca_id {
> >       TCA_ID_SIMP = TCA_ACT_SIMP,
> >       TCA_ID_IFE = TCA_ACT_IFE,
> >       TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
> > +     TCA_ID_MPLS = TCA_ACT_MPLS,
> >       /* other actions go here */
> >       TCA_ID_CTINFO,
> >       __TCA_ID_MAX = 255
>
> and the line that adds TCA_ID_MPLS to enum tca_id should be placed right
> before __TCA_ID_MAX, so that the uAPI is preserved (i.e. the value of
> TCA_ID_CTINFO does not change).
>
> thanks!
> --
> davide
>

Hi Davide,
Thanks for pointing that out.
Let me fix

>
