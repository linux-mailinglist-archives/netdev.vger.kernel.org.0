Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F1D249F04
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgHSNFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgHSNEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 09:04:43 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658A7C061383;
        Wed, 19 Aug 2020 06:04:42 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 140so12011976lfi.5;
        Wed, 19 Aug 2020 06:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDGVB4uc/9L8D6EYysA1otupkiXzJkfvAe8wQHNLxGA=;
        b=Ard4s932bJYSYryZTKI5z99QM0+nDxvZnETpFePakQOdmcZu0nh6+SK4cSRXAWUpvy
         DT5JwCtY1KAS+tkXlG6XVjhS2mg/4nCr2Qjud2UWkaVscXSfSV/6edu5jbYGw0CTNiZu
         YU9/NpNTp42WF76ysCVoai4EnTX8RzIds09S22UUybPEbST6AChWpEjqb6t5yeWy3bIa
         Kq5W7/lRoV2XtnFAWx+owWqLiAS/CuuXcwUSTcCPgIxwvKJ9GjeJ0Sg6UZr4Qe5aBK2x
         4RTA0BTT1VTjDZqE2jtc5XJiaGqmzrTTLP7IbVPBneVpm8rHzRpvEe1y/RHD96dZlWqh
         n4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDGVB4uc/9L8D6EYysA1otupkiXzJkfvAe8wQHNLxGA=;
        b=pf41kKNNxH+3hDoKWNpnsQZaurQAPwUqzsj0cU/UDfeWUvLfIanRW5qG0UqriSl+dG
         PNxNBAfzEE7t3pP6OaJ118hD7x4y/2yWlY0gWd5j7cs/Qz7krUNy+k+Omkixh2jizk21
         bHt8BAShZZmVWp9pGlqSs2KhEokEf1rhG5ZWVlHwZoTu/Ly4BH1QGW2jjCc3TLSL4yGf
         +QAj0CevjZl3RYP2nFTcLjchdf/rT5ROnpHJc5532Elj0Ct328A2pzlhVpiSk6hPboZW
         rfm+W+rZT+cfWWBCn6CCeY+/tMI2sm83ptDwgp0xqz2UIytzHRhAbdLCDSbcvcrTiRHA
         8pKg==
X-Gm-Message-State: AOAM530IfzIU0Srkx4o0fCyE+Y+3mlmcnESoyY6gV+nVkCfoT1ttWAjS
        LnvxoR/DWZBFAKgZGLyCHtmUQ/fE24Q3xY6WdgM=
X-Google-Smtp-Source: ABdhPJyvznro++qCXyBYE7EoK74ppQEV9P6teSEM88ogypMzGoowstNWZ9Z5nzJX9vWeeM1LsWOd0NxqUwA+aqMfUjQ=
X-Received: by 2002:a05:6512:3253:: with SMTP id c19mr11944089lfr.139.1597842280844;
 Wed, 19 Aug 2020 06:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200615154114.13184-1-mayflowerera@gmail.com>
 <20200615.182343.221546986577273426.davem@davemloft.net> <CAMdQvKvJ7MXihELmPW2LC3PAgXMK2OG6bJjPNJkCgE6eZftDVw@mail.gmail.com>
 <CAMdQvKtrzFtg9PwZhyMQ96S48ZLG5gAu3gk8m=k+tFVMHeshXQ@mail.gmail.com> <CAMdQvKubUYCMRt0V+koj8nKAq+nZNABJZMAXX7jB-_fRiPeJog@mail.gmail.com>
In-Reply-To: <CAMdQvKubUYCMRt0V+koj8nKAq+nZNABJZMAXX7jB-_fRiPeJog@mail.gmail.com>
From:   Era Mayflower <mayflowerera@gmail.com>
Date:   Wed, 19 Aug 2020 13:03:37 +0000
Message-ID: <CAMdQvKuDzSXpMRr9N4_jXJO4R5dp9UZ-+WByZW+KRBmCLubN_w@mail.gmail.com>
Subject: Re: [PATCH] macsec: Support 32bit PN netlink attribute for XPN links
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 10:23 AM Era Mayflower <mayflowerera@gmail.com> wrote:
>
> On Wed, Jun 17, 2020 at 1:32 AM Era Mayflower <mayflowerera@gmail.com> wrote:
> >
> > On Wed, Jun 17, 2020 at 10:02 AM Era Mayflower <mayflowerera@gmail.com> wrote:
> > >
> > > On Tue, Jun 16, 2020 at 1:23 AM David Miller <davem@davemloft.net> wrote:
> > > >
> > > > From: Era Mayflower <mayflowerera@gmail.com>
> > > > Date: Tue, 16 Jun 2020 00:41:14 +0900
> > > >
> > > > > +     if (tb_sa[MACSEC_SA_ATTR_PN]) {
> > > >
> > > > validate_add_rxsa() requires that MACSET_SA_ATTR_PN be non-NULL, so
> > > > you don't need to add this check here.
> > > >
> > >
> > > validate_add_rxsa() did not originally contain that requirement.
> > > It does exist in validate_add_txsa(), which means that providing a PN
> > > is necessary only when creating TXSA.
> > > When creating an RXSA without providing a PN it will be set to 1
> > > (init_rx_sa+15).
> > > This is the original behavior which of course can be changed.
> > >
> > > - Era.
> >
> > Sorry for the time issues, just noticed I sent the previous mail with
> > future time.
> > Fixed it permanently on my computer.
>
> Hello, is there any news?
>
> - Era.

This patch is important to help projects like iproute2 use XPN macsec links.
Please let me know if there is anything I need to fix.

- Era.
