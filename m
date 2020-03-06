Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3EA17ADBA
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgCER7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:59:34 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35086 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgCER7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 12:59:33 -0500
Received: by mail-qk1-f194.google.com with SMTP id 145so6191341qkl.2;
        Thu, 05 Mar 2020 09:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHsry5N2dnMyiEZPE+CiD2B+1Y5pPONnPCFPtUcNWlY=;
        b=Lew8K2KRbDphQ3wYDH9AW27FrjcSeB879CvkpxHXH3obFqaT6d6ss66x0vDHumQCj7
         4UxV+LDbbOj2Spnr+Dzf78z2qLTED9xbkYzv9weBiGIvytMBW5jEusf2/J33kYO1wka9
         003kfksLdZMhpS9sbzLbD15bCgwT6YQIuVuAosDM+ynj0Xyu7oBXm/h0j6fjDHGr0so3
         q68WT12p1rNiGY73W4Fcc2HxDu2vKgy7op8cMX8Yg4Dzh2Z8oZdLA+e7Nn+yAco9Ms8e
         8rtkbH0D2eP4tQtK+u6vfoDn2/ERuaOvro6YnlPG8NLZCVxUhEWKE+wdofoQNIfPEojU
         rvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHsry5N2dnMyiEZPE+CiD2B+1Y5pPONnPCFPtUcNWlY=;
        b=ctdVpxZfOzgL+pH4PLalZrVbM8lMwbHxhgbvo+e6Gxe9FP5Rg7zD6KqEjKhzc29kdq
         VAC94y58bN12mozIBIQ1tzESR/JUCBUZ2XdZwx5vC4PK/UcBHvtK5xXqFCflE5RsOCXs
         x/i5Vxbxviorwzk72A9M58HIKSGvCwnwfnqiiai+5XQvlQotkIuMCCh/Z/Pl0JxVMRuW
         VpyoPu30rnQYkyBfcsfS80W3/k7hGfadpiy0+phokn1lSzp6FYAHYeVd+6SmuIcXj9Eq
         FC0zwMz/Xr+ZjzZlmXMBIF59lZp8xemyeHkLtYnTCaziFI7dghlJOxxOsdgpFmgYxw0V
         AViQ==
X-Gm-Message-State: ANhLgQ1Dd4WID6Jn9waUth7Iw4RZ+PEc1XvDtrTAj3fOPediYWBJT03e
        SvGmTl8FScG9iD2vqeL/LG5//tFAXdxFZSE17go=
X-Google-Smtp-Source: ADFU+vv+eEySiamfk3LVjyZxj7hT+/d7ennxxwp+eIJTjnqDQa4vtNof2oxNClUi1Ax+lT6SrUmdaF+qZPsP1Ufa46M=
X-Received: by 2002:a05:620a:1345:: with SMTP id c5mr9166574qkl.182.1583431172026;
 Thu, 05 Mar 2020 09:59:32 -0800 (PST)
MIME-Version: 1.0
References: <20200305220108.18780-1-mayflowerera@gmail.com>
 <20200305220108.18780-2-mayflowerera@gmail.com> <20200305140241.GA28693@unicorn.suse.cz>
 <CAMdQvKv9tSoSBfyOyhtctQ9D7aU2WUmuMUsoLn_WZ8whD=3AzA@mail.gmail.com>
 <CAMdQvKuzaBuKGj1-HR6+r=FY4X9GhZPvEHwRt3BjErFiu1+bgw@mail.gmail.com> <20200305172453.GB28693@unicorn.suse.cz>
In-Reply-To: <20200305172453.GB28693@unicorn.suse.cz>
From:   Era Mayflower <mayflowerera@gmail.com>
Date:   Fri, 6 Mar 2020 02:59:14 +0000
Message-ID: <CAMdQvKsAdFW_u0LQ8q4zy4mz9a7x0FESAeyvKRQWbcA7jDdjtw@mail.gmail.com>
Subject: Re: [PATCH 2/2] macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 5, 2020 at 5:24 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> Yes, new attribute identifiers should always be added as last so that
> you don't change existing values.

Created a new patch: macsec: Backward compatibility bugfix of consts values

On Thu, Mar 5, 2020 at 5:24 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Thu, Mar 05, 2020 at 11:53:29PM +0000, Era Mayflower wrote:
> > Do you think that inserting those new enum values after *_PAD would be
> > a good solution?
>
> Yes, new attribute identifiers should always be added as last so that
> you don't change existing values.
>
> Michal
>
> > On Thu, Mar 5, 2020 at 11:51 PM Era Mayflower <mayflowerera@gmail.com> wrote:
> > >
> > > Do you think that inserting those new enum values after *_PAD would be a good solution?
> > >
> > > On Thu, Mar 5, 2020 at 2:02 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >>
> > >> On Thu, Mar 05, 2020 at 10:01:08PM +0000, Era Mayflower wrote:
> > >> > Netlink support of extended packet number cipher suites,
> > >> > allows adding and updating XPN macsec interfaces.
> > >> >
> > >> > Added support in:
> > >> >     * Creating interfaces with GCM-AES-XPN-128 and GCM-AES-XPN-256.
> > >> >     * Setting and getting packet numbers with 64bit of SAs.
> > >> >     * Settings and getting ssci of SCs.
> > >> >     * Settings and getting salt of SecYs.
> > >> >
> > >> > Depends on: macsec: Support XPN frame handling - IEEE 802.1AEbw.
> > >> >
> > >> > Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
> > >> > ---
> > >> [...]
> > >> > diff --git a/include/net/macsec.h b/include/net/macsec.h
> > >> > index a0b1d0b5c..3c7914ff1 100644
> > >> > --- a/include/net/macsec.h
> > >> > +++ b/include/net/macsec.h
> > >> > @@ -11,6 +11,9 @@
> > >> >  #include <uapi/linux/if_link.h>
> > >> >  #include <uapi/linux/if_macsec.h>
> > >> >
> > >> > +#define MACSEC_DEFAULT_PN_LEN 4
> > >> > +#define MACSEC_XPN_PN_LEN 8
> > >> > +
> > >> >  #define MACSEC_SALT_LEN 12
> > >> >
> > >> >  typedef u64 __bitwise sci_t;
> > >> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > >> > index 024af2d1d..ee424d915 100644
> > >> > --- a/include/uapi/linux/if_link.h
> > >> > +++ b/include/uapi/linux/if_link.h
> > >> > @@ -462,6 +462,8 @@ enum {
> > >> >       IFLA_MACSEC_SCB,
> > >> >       IFLA_MACSEC_REPLAY_PROTECT,
> > >> >       IFLA_MACSEC_VALIDATION,
> > >> > +     IFLA_MACSEC_SSCI,
> > >> > +     IFLA_MACSEC_SALT,
> > >> >       IFLA_MACSEC_PAD,
> > >> >       __IFLA_MACSEC_MAX,
> > >> >  };
> > >>
> > >> Doesn't this break backword compatibility? You change the value of
> > >> IFLA_MACSEC_PAD; even if it's only used as padding, if an old client
> > >> uses it, new kernel will interpret it as IFLA_MACSEC_SSCI (an the same
> > >> holds for new client with old kernel).
> > >>
> > >> > diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
> > >> > index 1d63c43c3..c8fab9673 100644
> > >> > --- a/include/uapi/linux/if_macsec.h
> > >> > +++ b/include/uapi/linux/if_macsec.h
> > >> > @@ -25,6 +25,8 @@
> > >> >  /* cipher IDs as per IEEE802.1AEbn-2011 */
> > >> >  #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
> > >> >  #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
> > >> > +#define MACSEC_CIPHER_ID_GCM_AES_XPN_128 0x0080C20001000003ULL
> > >> > +#define MACSEC_CIPHER_ID_GCM_AES_XPN_256 0x0080C20001000004ULL
> > >> >
> > >> >  /* deprecated cipher ID for GCM-AES-128 */
> > >> >  #define MACSEC_DEFAULT_CIPHER_ID     0x0080020001000001ULL
> > >> > @@ -66,6 +68,8 @@ enum macsec_secy_attrs {
> > >> >       MACSEC_SECY_ATTR_INC_SCI,
> > >> >       MACSEC_SECY_ATTR_ES,
> > >> >       MACSEC_SECY_ATTR_SCB,
> > >> > +     MACSEC_SECY_ATTR_SSCI,
> > >> > +     MACSEC_SECY_ATTR_SALT,
> > >> >       MACSEC_SECY_ATTR_PAD,
> > >> >       __MACSEC_SECY_ATTR_END,
> > >> >       NUM_MACSEC_SECY_ATTR = __MACSEC_SECY_ATTR_END,
> > >> > @@ -78,6 +82,7 @@ enum macsec_rxsc_attrs {
> > >> >       MACSEC_RXSC_ATTR_ACTIVE,  /* config/dump, u8 0..1 */
> > >> >       MACSEC_RXSC_ATTR_SA_LIST, /* dump, nested */
> > >> >       MACSEC_RXSC_ATTR_STATS,   /* dump, nested, macsec_rxsc_stats_attr */
> > >> > +     MACSEC_RXSC_ATTR_SSCI,    /* config/dump, u32 */
> > >> >       MACSEC_RXSC_ATTR_PAD,
> > >> >       __MACSEC_RXSC_ATTR_END,
> > >> >       NUM_MACSEC_RXSC_ATTR = __MACSEC_RXSC_ATTR_END,
> > >>
> > >> The same problem with these two.
> > >>
> > >> I'm also a bit unsure about the change of type and length of
> > >> MACSEC_SA_ATTR_PN but I would have to get more familiar with the code to
> > >> see if it is really a problem.
> > >>
> > >> Michal
