Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3BB63B5B0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiK1XOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiK1XOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:14:22 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3FB2F022;
        Mon, 28 Nov 2022 15:14:18 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id f9so11331179pgf.7;
        Mon, 28 Nov 2022 15:14:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mE5GAuUuxuRXdMYEVXzjTlSiVxqi5TsFYOMmV1DHmFE=;
        b=5eLmpn7OoYk1/xGh+0zuap3QlYkaiSUsRHoErdngbcbHYsbEwY82IkmGCEtDDnzkJd
         jzSf8CCJRZdIYotMLzKcvkBCobTnu52chpi0o9OGgr4eOL6Vn8HrCHzAdbZp9Jqq7/GI
         rETdw4GlMaFYtes2oTszaurpdSGobVjC+YaFJmczAFcEcd9LskEeMPI4AFzHpdrak7Bv
         m81xsHZw3Irqhk9rI937C/Be8Bt/lhcukcz21ru/sTU6uJzxzsue34sHPNUnm4ghv2IV
         clcGlf8/tK/Gyg9o7pE1yHcPBbCVAX771yLla1/+tccnJf28YO2QwXBB0oEzAazPJ6mB
         n5XA==
X-Gm-Message-State: ANoB5pnyD1FWtNfibB0h//BW+j3efu9D4ZcX/Nk2x+Tca6k6GecuIr4Y
        u2e7PaFdlOlL7SySAsIrhHuUWVhahHnDETEGy6M=
X-Google-Smtp-Source: AA0mqf5vMQ6ANEqt8D2j6Xr3+UYSTEDgoU4bfhqv5tZ/vT99TsufZt8ZxFpPdvZIqRUs4kt5wdPv6NM02oRztAx2an0=
X-Received: by 2002:a62:6d02:0:b0:562:3411:cb3a with SMTP id
 i2-20020a626d02000000b005623411cb3amr34705095pfc.60.1669677257386; Mon, 28
 Nov 2022 15:14:17 -0800 (PST)
MIME-Version: 1.0
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221122201246.0276680f@kernel.org> <CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com>
 <20221123190649.6c35b93d@kernel.org> <CAMZ6RqJ_rjbbwAfKzA3g2547D5vMke2KBnWCgBVmQqLcev1keg@mail.gmail.com>
 <20221128104311.0de1c3c5@kernel.org>
In-Reply-To: <20221128104311.0de1c3c5@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 29 Nov 2022 08:14:06 +0900
Message-ID: <CAMZ6RqK7wP12+EC_i4FwcEZpaGfFhoP43YGuOdmRcpNWKf52aQ@mail.gmail.com>
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default information
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 29 Nov. 2022 at 03:43, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 24 Nov 2022 14:33:58 +0900 Vincent MAILHOL wrote:
> > > I think 2/ is best because it will generalize to serial numbers while
> > > 1/ will likely not. 3/ is a smaller gain.
> > >
> > > Jiri already plumbed thru the struct devlink_info_req which is on the
> > > stack of the caller, per request, so we can add the bool / bitmap for
> > > already reported items there quite easily.
> >
> > Sorry, let me clarify the next actions. Are you meaning that Jiri is
> > already working on the bitmap implementation and should I wait for his
> > patches first? Or do you expect me to do it?
>
> Dunno if the question still stands but we already have
> struct devlink_info_req and can put the bitmap in it.
> All drivers use devlink helpers to add attributes.

Roger that. I already wrote the code, I just need to do a bit of
ironing and extra testing. I will send it after the "net: devlink:
devlink_nl_info_fill: populate default information" series gets
merged.
