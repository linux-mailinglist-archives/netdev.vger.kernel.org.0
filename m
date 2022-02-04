Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D134A9E7A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346905AbiBDR7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236969AbiBDR7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:59:50 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C81C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 09:59:50 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id z7so9592816ljj.4
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 09:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GaejKHT4xym9gOKFRFAUnv2RqMyrG37h3Q+pV1glDTs=;
        b=PvS/OVjuWGVJ6NE+6uTCCv0SYZa4ERDiZ8TuR/Y2AwuCLuyMdwdfaCsDDPuJ/QW8hO
         yBArBxMmf5FEYImOeqS6VoB8fbBbdNvv6qxpljOSF0cKnLb2KMCG2gVSpI6/rkdQFl6m
         J5LB3YXJ3D1vW74fu/bJ6FhEZhdhr8PnIa3yE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GaejKHT4xym9gOKFRFAUnv2RqMyrG37h3Q+pV1glDTs=;
        b=vzIxt2Wlzzc97n1sot++QklGx5jSKVAc8QbN+4ilMSd9WNdXV0QLjTF4qJAx8Gwf2a
         X5bvDayi47+QHIJVCzBnTVkL/0chbRtayvg5nXyfcZQxLvBwVhskBpAbBGFJl9gUBru0
         Pl32ZT/K3g+t0SWENpLBd7+3DbIgxDzMmR/axPWQYelwJbmpFBQaRu2IzcGLtLibL9DR
         RzyIATTEPeXxSdPObm56GPSySlhV4hd3dRQN47ZXCOBf4L5vzwo8RR8gDLk6CY33mHX/
         2VRAw/Qjv4gdtamRk/jmxjoooONqb8FJtPk4GCOLhxGkCHNJ7O+mwerVdw3sEBw8roGv
         CsNw==
X-Gm-Message-State: AOAM532uTHen6LGrO7FujBkuvLeMFYuZyPH3Pgj2rtwzAn6iCVN86Stq
        uzi2iv9GAyK1LniSyOfSEHXErxbq6/3pbq1LrU6mlw==
X-Google-Smtp-Source: ABdhPJzPDbEKiE4Cz2HcjtexN1iMrvwuGyk8YuEFpw4i3KG3If1ul2R0X7zXvNZrAIUbCpjYdAjtSbAKBLK4DgAQzpw=
X-Received: by 2002:a2e:a361:: with SMTP id i1mr24428ljn.146.1643997588615;
 Fri, 04 Feb 2022 09:59:48 -0800 (PST)
MIME-Version: 1.0
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
 <1643933373-6590-2-git-send-email-jdamato@fastly.com> <YfzY780CPu6z09Ki@hades>
In-Reply-To: <YfzY780CPu6z09Ki@hades>
From:   Joe Damato <jdamato@fastly.com>
Date:   Fri, 4 Feb 2022 09:59:37 -0800
Message-ID: <CALALjgwC-5oiAnYGgs_qbqCXtpNE5AkYMn0rVp1zayPCErrxRw@mail.gmail.com>
Subject: Re: [net-next v4 01/11] page_pool: kconfig: Add flag for page pool stats
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com,
        brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:42 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Thu, Feb 03, 2022 at 04:09:23PM -0800, Joe Damato wrote:
> > Control enabling / disabling page_pool_stats with a kernel config option.
> > Option is defaulted to N.
> >
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >  net/Kconfig | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/net/Kconfig b/net/Kconfig
> > index 8a1f9d0..604b3eb 100644
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -434,6 +434,18 @@ config NET_DEVLINK
> >  config PAGE_POOL
> >       bool
> >
> > +config PAGE_POOL_STATS
> > +     default n
> > +     bool "Page pool stats"
> > +     depends on PAGE_POOL
> > +     help
> > +       Enable page pool statistics to track allocations. Stats are exported
> > +       to the file /proc/net/page_pool_stat. Users can examine these
>
> There's no proc anymore

Ah, yes. Thanks :) I've fixed this in my v5 branch.
