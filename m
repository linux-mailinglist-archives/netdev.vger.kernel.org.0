Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD9338765D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 12:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348438AbhERKYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 06:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348446AbhERKYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 06:24:34 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2247C061573
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 03:23:16 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 27so5385921pgy.3
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 03:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6p7LeLgCmM3H0LKEADIRbNRK8fn5lBAMJhcyEhzLGUo=;
        b=Pi+2UI5o9nP3o9ejolz5XeKMat99Gsn8ph3YaKuCX3HWZ9sZliHzcIPiZpuHwtw4cn
         d623TCcIa0RL1Dz6EsqOqq5Me7AZ7PzK7XFd3HseSDJCsVFu5T39EzSr//yfPXZ+JT70
         6Eb/2JRA/Ff3WUEaaU0wBdQn6UjeXxU9Iy06KoKlAbTOVTXbik4GAzC2TkN44qXTsrNq
         1dj7ka/+Pjd3anUsF16LekiHwzSniOcN97NjFw4o8Wp9rDVwX1hcbYUfS8y+1EMlc+qX
         5m+NYDaFuOFbO2qs+kXjeEcEsICj0Buz57KuouFOwTRX4CVHhb+5tfILYFkC+HoTFa3b
         GDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6p7LeLgCmM3H0LKEADIRbNRK8fn5lBAMJhcyEhzLGUo=;
        b=TBbpSkDws8nY+RsFm/jKPPH8lay/0XxZE1CaMjoYR/7zS8y7OvjIPuD5n+4DVL3zIK
         q/1t1fVveEP86zSNfY5sqMgHdM9BswlQPJQp51KgWxSmG+u3BzQBBvqlp2behw932jXe
         1vw+NEm6wM+a2fuXvtq4K+/Ugr0j1y3r4zRQCYtjdhDVPTc5NVhUm2vn7OR1BscMHlzA
         dQFvkMZjoASHzjLVoMSAfT29JeoQ7i9imXhUuwy6sNamT2m3o7/Ac8yD2uRVX6biHRYS
         mRAZ/cxcV7BfJUwMwZunSAklFfvMIJ365IxbxniAm62y2KIXB7R9AOicH3p0lFCRFVfF
         PbyQ==
X-Gm-Message-State: AOAM530HatHuzEeFwS1qWOzLZ1S14NbWl9MEWNo2IXixJLPKRlqFNhkq
        db4EM9GlkTzROw3uK+m738fEUw87HitwlkWcIxOB+g==
X-Google-Smtp-Source: ABdhPJwHBnotQFI2rf6/9YhaCcIrUCdsCoMNeOhjKmK5fDlGf957NnQ6roDWqGzVJSPRfCpfQWUQLagNId4pNcTkL4k=
X-Received: by 2002:a62:d447:0:b029:291:19f7:ddcd with SMTP id
 u7-20020a62d4470000b029029119f7ddcdmr4488045pfl.54.1621333396188; Tue, 18 May
 2021 03:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <1621245214-19343-1-git-send-email-loic.poulain@linaro.org> <CAHNKnsTnbLKXQF2CHEKA-BN9PBAhuY5GYVaTNK5ztjBV4q2zKg@mail.gmail.com>
In-Reply-To: <CAHNKnsTnbLKXQF2CHEKA-BN9PBAhuY5GYVaTNK5ztjBV4q2zKg@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 18 May 2021 12:31:39 +0200
Message-ID: <CAMZdPi9MdiYQFk7AYM1X97rouW_1j+TsK-dekiqgVe4-XwON8w@mail.gmail.com>
Subject: Re: [PATCH net] net: wwan: Add WWAN port type attribute
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        dcbw@gapps.redhat.com,
        Aleksander Morgado <aleksander@aleksander.es>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Tue, 18 May 2021 at 01:44, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Hello Loic,
>
> On Mon, May 17, 2021 at 12:48 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> > The port type is by default part of the WWAN port device name.
> > However device name can not be considered as a 'stable' API and
> > may be subject to change in the future. This change adds a proper
> > device attribute that can be used to determine the WWAN protocol/
> > type.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  drivers/net/wwan/wwan_core.c | 34 +++++++++++++++++++++++++---------
> >  1 file changed, 25 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > index cff04e5..92a8a6f 100644
> > --- a/drivers/net/wwan/wwan_core.c
> > +++ b/drivers/net/wwan/wwan_core.c
> > @@ -169,6 +169,30 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
> >
> >  /* ------- WWAN port management ------- */
> >
> > +/* Keep aligned with wwan_port_type enum */
> > +static const char * const wwan_port_type_str[] = {
> > +       "AT",
> > +       "MBIM",
> > +       "QMI",
> > +       "QCDM",
> > +       "FIREHOSE"
> > +};
>
> A small nitpick, maybe this array should be defined in a such way:
>
> static const char * const wwan_port_type_str[WWAN_PORT_MAX] = {
>     [WWAN_PORT_AT] = "AT",
>     [WWAN_PORT_MBIM] = "MBIM",
>     [WWAN_PORT_QMI] = "QMI",
>     [WWAN_PORT_QCDM] = "QCDM",
>     [WWAN_PORT_FIREHOSE] = "FIREHOSE",
> };
>
> So the array index will be clear without additional notes.

You're right, it would indeed be more robust.
I'll submit that change in a subsequent patch.

Thanks,
Loic

>
> --
> Sergey
