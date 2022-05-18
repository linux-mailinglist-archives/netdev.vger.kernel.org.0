Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CFC52BFB0
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239959AbiERQNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbiERQNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:13:43 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C2C1E013C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:13:42 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id q10so3211738oia.9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1oBiXeYhvHk15Tp3iWUs6S3FDjLRebIX6PYnXdogWP8=;
        b=KN6FMcP/hv9FKDQFut+wqOdnR47VBRHdoIq45sYJRcS9MMYoyxIbEafKlrlVdMXCgt
         RFtmJnkQdFyPsPF9UDz1EA0Ka9+8HZbTa5vaTdo8FOFc85CBalCFWilxyrWGU4FjnNSr
         NxMF6BnjgY8yQ1m57q2k54OlYr9wTU0iBa4ZGCk0ZZKXwzyNdEQPzyKaUbDirvTJkooY
         gIQ3mFtiPS6QiZWP8mKfYKwljNpjxIBf0K0gFokDFSO2H0V7vvsTw0dJ3b804qde8T5Q
         rr7PKegWiDeiptS9wr9NvMm9iu7gaU/AkQfDvFy17ybTPjQUSth/tdVDgXJ/ylv9mN67
         S4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1oBiXeYhvHk15Tp3iWUs6S3FDjLRebIX6PYnXdogWP8=;
        b=elg1d/CuU5SLMUtA8Ywxg38wK7n9C+XLqEfHWINq1QpgDySPH6Crd84EVqYgzsXzFr
         vX2JEW4wTS35M2+/0MzJHFpOCKqEc30RiaE+QepBMzvbpCD5C4d28xZRZ6jt/WAWkJ8p
         p2wR23pdmYf624qw5TX3lEE+oXQxzrQcVFZEsu0X66efSv5owq1mdR1Dccrbo6O8RP1+
         IpuOIkgBu/NdFFN/eMOGz5F+KiUBrC7yRH26x2WDQZnfMZ3JaZ7glylWDNf9w4I0O9i7
         DMLzBOyaFznltGDjZHdTtZu9iaixlJRgWvCR8gLaBpFEKc7dDHrxCeqc1aPlQUKUii0E
         uAaA==
X-Gm-Message-State: AOAM530nYVdvM+nlopsAerL6Venm/kw0cRcE75qC7fWs6dnwF5TgQBr7
        NuxhaE2qeh3d99bKg1XTb+0iEU6YZxZL2MpA1+EJgsa5uSw=
X-Google-Smtp-Source: ABdhPJyOf6Ge2pkYa/Q+I8MVAeJGnP4LaUiDM78N/xc3csVML4tIgy3mQxMmdEndQ6nCL0i6binf9wFHSGFvnBceWus=
X-Received: by 2002:a05:6808:e8f:b0:2f7:6c1a:c1a with SMTP id
 k15-20020a0568080e8f00b002f76c1a0c1amr378167oil.129.1652890421475; Wed, 18
 May 2022 09:13:41 -0700 (PDT)
MIME-Version: 1.0
References: <21572bb1e0cc55596965148b8fdf31120606480f.1652454155.git.lucien.xin@gmail.com>
 <20220517172141.0eb57b8a@kernel.org>
In-Reply-To: <20220517172141.0eb57b8a@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 18 May 2022 12:12:56 -0400
Message-ID: <CADvbK_fRBO4WH1Qq2v1iPWZJ1CnoxB-Xpms3RLP=HzOgxowWpw@mail.gmail.com>
Subject: Re: [PATCHv2 net] Documentation: add description for net.core.gro_normal_batch
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 8:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 13 May 2022 11:02:35 -0400 Xin Long wrote:
> > Describe it in admin-guide/sysctl/net.rst like other Network core options.
> > Users need to know gro_normal_batch for performance tuning.
> >
> > v1->v2:
> >   - Improved the description according to the suggestion from Edward and
> >     Jakub.
> >
> > Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> > Reported-by: Prijesh Patel <prpatel@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  Documentation/admin-guide/sysctl/net.rst | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> > index f86b5e1623c6..5cb99403bf03 100644
> > --- a/Documentation/admin-guide/sysctl/net.rst
> > +++ b/Documentation/admin-guide/sysctl/net.rst
> > @@ -374,6 +374,17 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
> >  If set to 1 (default), hash rethink is performed on listening socket.
> >  If set to 0, hash rethink is not performed.
> >
> > +gro_normal_batch
> > +----------------
> > +
> > +Maximum number of the segments to batch up for GRO list-RX.
>
> How about s/for GRO list-RX/on output of GRO/ ?
>
> > When a packet exits
> > +GRO, either as a coalesced superframe or as an original packet which GRO has
> > +decided not to coalesce, it is placed on a per-NAPI list. This list is then
> > +passed to the stack when the segments in this list count towards the
> > +gro_normal_batch limit.
>
> ... when the number of segments reaches the gro_normal_batch limit.
>
> > +
> > +Default : 8
>
> Also, should we drop the default? It's easy to grep for, chances are if
> anyone updates the value they will forget to change the doc.
>
> Sorry for the late review, I wasn't expecting v3 will be needed.
No worries, v3 has been posted, please check.

Thanks.

>
> >  2. /proc/sys/net/unix - Parameters for Unix domain sockets
> >  ----------------------------------------------------------
> >
>
