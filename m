Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB0A57BC43
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbiGTREp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiGTREm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:04:42 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979B06BC3B;
        Wed, 20 Jul 2022 10:04:41 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-10d6e8990b9so8811062fac.7;
        Wed, 20 Jul 2022 10:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DRRDvUhGg+XRjKdigaR0X/x0hmvUMO6VH2v80OeYkr4=;
        b=Hzg47Ce57bKJQpKUXLmRt/A3U9MSi/nuq05G4YNOexuwXKt8HFg9czBNGI/lSjdpx5
         fJAV/OHnvaqMAlTbklbDDeeA1NIv0frKKvUSOdyAdy1RZlr+9NI7BxmPcJwV9SyreSYO
         45q03idsXJLwXDRRH4+lnDi9QQRpeu9+RR1pYm3lO5DcSkd1VevS50fsLrzfEGvC249l
         aeRCOr6adfaUvDldzA9R2KmBjW4Ww0VEhdrzfshTtTCuIFMOtWjcjVPXK8wKGtilPGTj
         PhIjoHcQfRcDJXXO7o00xLS9dVgpxW8+tiZ2Jg9CV2Pu/JqrrhcapKYLENvbfYJrDdql
         tvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRRDvUhGg+XRjKdigaR0X/x0hmvUMO6VH2v80OeYkr4=;
        b=QDFQTzPDmNKevJnsVSsTJxbsk43dvkq2Mz+GcH8wh45eea2GQZZ+cK21Zwg60V1Q88
         f2X30fLEfIAgHRj61xOIE5gEZh2tW1IPl7+gBAiQUpVPE9r0u2i3siStHykx/pxGhu70
         u7ieaT/a4tqiUnvK1LAsUH4o7pJtLmMYruj5hS2TfCcN4vkQaWZ3nHuC2+jsZ8rLSW+t
         HezLUueJHfrpGsFFfL/Xbkr70hfU3BHGGg3lDztSBP0jThtU+s3K7O5IUX+7eMXQb2Lr
         VT7Y/NyolV5p8h/4x3LXQXwjsSEjjeeuiOy83UEJRgC2L+CZMTnZvc0DJssX0j7tdqnu
         7Sog==
X-Gm-Message-State: AJIora9iJUFZWizY3NtX8GbLa2qIYI467jXlPbi6z/dg0um4Hc0nSoHc
        TBPZb+DvUFbdEGmpZQ29j7K9EgcHEYfGWHXEXYBI+QqTkOM=
X-Google-Smtp-Source: AGRyM1uPOe53CvlPmI83IFhM84ZZmMexJ5f5+r9sqKdJ0kODBAuE/sBz/QwuQ8qQRMkrao8I4Iwa0n8hoEZYVo+jpRw=
X-Received: by 2002:a05:6871:88e:b0:10b:f6bf:490 with SMTP id
 r14-20020a056871088e00b0010bf6bf0490mr3238585oaq.129.1658336680911; Wed, 20
 Jul 2022 10:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <0ad4093257791efe9651303b91ece0de244aafa4.1658166896.git.lucien.xin@gmail.com>
 <Ytb8ouxpPfV4MHru@t14s.localdomain>
In-Reply-To: <Ytb8ouxpPfV4MHru@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 20 Jul 2022 13:03:56 -0400
Message-ID: <CADvbK_dj83ajdamWDZpT1OUFBDJT-9udtKS97+W8Khw9XoVDrA@mail.gmail.com>
Subject: Re: [PATCH net] Documentation: fix sctp_wmem in ip-sysctl.rst
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 2:49 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Jul 18, 2022 at 01:54:56PM -0400, Xin Long wrote:
> > Since commit 1033990ac5b2 ("sctp: implement memory accounting on tx path"),
> > SCTP has supported memory accounting on tx path where 'sctp_wmem' is used
> > by sk_wmem_schedule(). So we should fix the description for this option in
> > ip-sysctl.rst accordingly.
> >
> > Fixes: 1033990ac5b2 ("sctp: implement memory accounting on tx path")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index 0e58001f8580..b7db2e5e5cc5 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -2870,7 +2870,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
> >       Default: 4K
> >
> >  sctp_wmem  - vector of 3 INTEGERs: min, default, max
> > -     Currently this tunable has no effect.
> > +     Only the first value ("min") is used, "default" and "max" are
> > +     ignored.
> > +
> > +     min: Minimal size of send buffer used by SCTP socket.
>
> I'm not a native English speaker, but this seems better:
> "Minimum size of send buffer that can be used by an SCTP socket."
This is from "sctp_rmem" part:

"min: Minimal size of receive buffer used by SCTP socket."

I think it was copied from "tcp_rmem", and yes it should be "SCTP sockets"
or "an SCTP socket.", and "Minimum size" seems more common.

will post v2. Thanks.

>
> > +     It is guaranteed to each SCTP socket (but not association) even
> > +     under moderate memory pressure.
> > +
> > +     Default: 4K
> >
> >  addr_scope_policy - INTEGER
> >       Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
> > --
> > 2.31.1
> >
