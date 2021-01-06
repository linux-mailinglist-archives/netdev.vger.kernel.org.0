Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5215E2EC0FC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbhAFQVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbhAFQVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:21:02 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA04AC06134C;
        Wed,  6 Jan 2021 08:20:21 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id q1so3717040ilt.6;
        Wed, 06 Jan 2021 08:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jJBD3FJbkEkR4QdjZP5FRnTN2DPK5bSKlA/DRlfyf2g=;
        b=Rlt8EZNLzunijB8zBy1VQJbjIYEFR2ujALY7W+nibhI1RHyzECKTfSXeJgsXJnbco5
         iwMpbuFRYpmqmQt91mRrrYHE4BoeiN6EMlY3MtrW9ZwUcJACGNNO3Co8X5PMdGLYiTqq
         xeYc3liikqo+CK3gBLU9SxOBT3G/PEAi+gjmLC+QuDbMY9SFtWcPWyike2JFB0K6Z7qy
         TXokOcF91OSl2Jk9Fj+tpn1KTa1sU3pvkCl3HXfb9Dh+Vv94YlFmfkaanYh2AoboSRp4
         WgvJveuCp9b76hkyqI2O5YI+gMqwtvmrZlPByEhyEe9Bn2HbWaMUsaAOJ/ZwRnnXaKYS
         nsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jJBD3FJbkEkR4QdjZP5FRnTN2DPK5bSKlA/DRlfyf2g=;
        b=Xk0ZE+cavYB3WxGDSjY0OWABZaY1nteawmCW+/KQ5ssX50/5amGiTzp67jHwy9HmF8
         t1DN2QCqbCDo9IBdAPrY2WVJUTmgMBjSw342vc8I/bEiTMpv4Ry6Q0oJDRSzxWTxxlRd
         nziygJpcrCc/iesE+Rp37vyRpwusQLSJnqJG4RwBcIIPPU7zxhq0bqKmcOQCGBCC+HCX
         PDr10A/mTslXl8SzYronaHFbPxhoZbsUh2SInYJRgXX3jUTzcXkXHVoLLLPzx6pvF5Gz
         SEToNGCE4nXqbVe8tgFbc2hOIBN5rbL753qBnBkgWhXAqtc7LsAAZC5b1znrbvHBvK6j
         mHEA==
X-Gm-Message-State: AOAM533G97cYmwmHrfkQ9U51GDaabCaubPoZPloTf4V6G6FZNKmdot42
        mG6rlgGBROOvgKtFRlW1w9WUZFENz2xbSM5brbwDtPqdHTJiFXFj
X-Google-Smtp-Source: ABdhPJxIXSKqcvu9y9jg7gFdsAVSoQDzOH9D9eNbMtiFOpxp/UKLTIDWjI7BFWkp3lJc2FosYv7K7q2G49Q/J97Aa1M=
X-Received: by 2002:a92:cd8c:: with SMTP id r12mr4835912ilb.221.1609950021082;
 Wed, 06 Jan 2021 08:20:21 -0800 (PST)
MIME-Version: 1.0
References: <20210105093553.31879-1-lukas.bulwahn@gmail.com> <0eb77133-947b-39c8-ee58-13b502c5ee71@infradead.org>
In-Reply-To: <0eb77133-947b-39c8-ee58-13b502c5ee71@infradead.org>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Wed, 6 Jan 2021 17:20:10 +0100
Message-ID: <CAKXUXMy25cPtBKtYFTAejfrorVzb=KFu-t=unJetM9oaTfYKvQ@mail.gmail.com>
Subject: Re: [PATCH] docs: octeontx2: tune rst markup
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     George Cherian <george.cherian@marvell.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 9:27 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi Lukas,
>
> On 1/5/21 1:35 AM, Lukas Bulwahn wrote:
> > Commit 80b9414832a1 ("docs: octeontx2: Add Documentation for NPA health
> > reporters") added new documentation with improper formatting for rst, and
> > caused a few new warnings for make htmldocs in octeontx2.rst:169--202.
> >
> > Tune markup and formatting for better presentation in the HTML view.
> >
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> > applies cleanly on current master (v5.11-rc2) and next-20201205
> >
> > George, please ack.
> > Jonathan, please pick this minor formatting clean-up patch.
> >
> >  .../ethernet/marvell/octeontx2.rst            | 59 +++++++++++--------
> >  1 file changed, 34 insertions(+), 25 deletions(-)
> >
> > diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> > index d3fcf536d14e..00bdc10fe2b8 100644
> > --- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> > +++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> > @@ -165,45 +165,54 @@ Devlink health reporters
> >  NPA Reporters
> >  -------------
> >  The NPA reporters are responsible for reporting and recovering the following group of errors
>
> Can we get a period or colon at the end of that line above, please.
>
> > +
> >  1. GENERAL events
> > +
> >     - Error due to operation of unmapped PF.
> >     - Error due to disabled alloc/free for other HW blocks (NIX, SSO, TIM, DPI and AURA).
> > +
> >  2. ERROR events
> > +
> >     - Fault due to NPA_AQ_INST_S read or NPA_AQ_RES_S write.
> >     - AQ Doorbell Error.
> > +
> >  3. RAS events
> > +
> >     - RAS Error Reporting for NPA_AQ_INST_S/NPA_AQ_RES_S.
> > +
> >  4. RVU events
> > +
> >     - Error due to unmapped slot.
> >
> > -Sample Output
> > --------------
> > -~# devlink health
> > -pci/0002:01:00.0:
> > -  reporter hw_npa_intr
> > -      state healthy error 2872 recover 2872 last_dump_date 2020-12-10 last_dump_time 09:39:09 grace_period 0 auto_recover true auto_dump true
> > -  reporter hw_npa_gen
> > -      state healthy error 2872 recover 2872 last_dump_date 2020-12-11 last_dump_time 04:43:04 grace_period 0 auto_recover true auto_dump true
> > -  reporter hw_npa_err
> > -      state healthy error 2871 recover 2871 last_dump_date 2020-12-10 last_dump_time 09:39:17 grace_period 0 auto_recover true auto_dump true
> > -   reporter hw_npa_ras
> > -      state healthy error 0 recover 0 last_dump_date 2020-12-10 last_dump_time 09:32:40 grace_period 0 auto_recover true auto_dump true
> > +Sample Output::
> > +
> > +     ~# devlink health
> > +     pci/0002:01:00.0:
> > +       reporter hw_npa_intr
> > +           state healthy error 2872 recover 2872 last_dump_date 2020-12-10 last_dump_time 09:39:09 grace_period 0 auto_recover true auto_dump true
> > +       reporter hw_npa_gen
> > +           state healthy error 2872 recover 2872 last_dump_date 2020-12-11 last_dump_time 04:43:04 grace_period 0 auto_recover true auto_dump true
> > +       reporter hw_npa_err
> > +           state healthy error 2871 recover 2871 last_dump_date 2020-12-10 last_dump_time 09:39:17 grace_period 0 auto_recover true auto_dump true
> > +        reporter hw_npa_ras
> > +           state healthy error 0 recover 0 last_dump_date 2020-12-10 last_dump_time 09:32:40 grace_period 0 auto_recover true auto_dump true
> >
> >  Each reporter dumps the
> >   - Error Type
> >   - Error Register value
> >   - Reason in words
> >
> > -For eg:
> > -~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_gen
> > - NPA_AF_GENERAL:
> > -         NPA General Interrupt Reg : 1
> > -         NIX0: free disabled RX
> > -~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_intr
> > - NPA_AF_RVU:
> > -         NPA RVU Interrupt Reg : 1
> > -         Unmap Slot Error
> > -~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
> > - NPA_AF_ERR:
> > -        NPA Error Interrupt Reg : 4096
> > -        AQ Doorbell Error
> > +For eg::
>
>    For example::
> or
>    E.g.::
>
> > +
> > +     ~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_gen
> > +      NPA_AF_GENERAL:
> > +              NPA General Interrupt Reg : 1
> > +              NIX0: free disabled RX
> > +     ~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_intr
> > +      NPA_AF_RVU:
> > +              NPA RVU Interrupt Reg : 1
> > +              Unmap Slot Error
> > +     ~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
> > +      NPA_AF_ERR:
> > +             NPA Error Interrupt Reg : 4096
> > +             AQ Doorbell Error
> >
>

thanks, Randy.

Agree and done. I just sent out a v2:

https://lore.kernel.org/linux-doc/20210106161735.21751-1-lukas.bulwahn@gmail.com/

Lukas
