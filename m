Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A294D267F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiCICae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 21:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiCICae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 21:30:34 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB9A1034
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 18:29:36 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id e3so914036pjm.5
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 18:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cyMEk1xlYKBwRiF0eoqGJmnU430Bfi7eg0Hbg05Jt28=;
        b=XksGuPqHOCAMA11dO1DP2BowoUZEcRNdCGBeT91AQ4rjvXxiIV7LXB8u7sNEG/DQDi
         kms+qbBJjrggpSWv55HTLiIYmd/VO4NRms4QUdmJPqtvv4G/+QLGUtVTGMFV3F8UegnB
         EGVJyodkH6oEdI5IFr39WuxAzsYpbRLsthbZhyGcOkrXW4HOMeqgwrmVpZlXeuRavcdc
         koNxtxSATi51fJrCElnUUcnU+VWwZ4X5CdnTH3VuCTtunlS5eIixyt58a+5y3XcuN1jA
         KDFbFe+IEZ2wF5MwyzVhJVmunjkfSw2zdOLWrJjbxJgmSZ97gn260K7g6tE8kn/1dP9X
         r0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cyMEk1xlYKBwRiF0eoqGJmnU430Bfi7eg0Hbg05Jt28=;
        b=iHess6o9nvzO29xsS4YMDInb+vA9V8Hu8XSrtdeKFbt4DY33c/VhTjiITdtmE6oMa7
         iA5+5H04kTORXC7jQ6V3Cn8OzBtAqVvttCDT4lote5xCVYen5dBqK3V6LO/hHZJj7QrB
         KbyN9Yl1pm/lJxTOu9KvrPhKvoo+pfthk3/nm4Uund8WZ7/fIIMWTb6+Egj3saoQwpeN
         spZzQV/+ZLaHhjx/s8qsH03jE7aXSGQrXPMVQH7tFpVlDlL0AdJfzipFt5B1PUlCqa+Z
         XSEnhFMgS3cl2szGf0PcBj9mpywu5BMuJFtDXMHY+aLZB6/0uS3gXjba8kFUeHWDK8f3
         6rKA==
X-Gm-Message-State: AOAM532QXaTvqITbvTWKmVMcfatIhPax9NZOpheBew5Np4YM5WW9rvGo
        B3VZFwxjnGUipx6FA310uyqUx0qK4UQcJs9P40E=
X-Google-Smtp-Source: ABdhPJwrNBVodx8Yk0Bm6/wuqJ5/hT8aTeSA9Kd/IEH4bh7vCmaD/AuQNLu3NbW4akHwvIwJzQxZND7MHWl62Rzi+hI=
X-Received: by 2002:a17:90b:3b42:b0:1bf:b72:30e9 with SMTP id
 ot2-20020a17090b3b4200b001bf0b7230e9mr7946008pjb.135.1646792976256; Tue, 08
 Mar 2022 18:29:36 -0800 (PST)
MIME-Version: 1.0
References: <20220307170927.25572-1-luizluca@gmail.com> <07287e42-bd51-a868-bfaa-6fd0213cc818@arinc9.com>
In-Reply-To: <07287e42-bd51-a868-bfaa-6fd0213cc818@arinc9.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 8 Mar 2022 23:29:25 -0300
Message-ID: <CAJq09z7R0N0nZLdvZR5nJBjzYajjhdm=c1KewdwCj-gCh6MOAg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: tag_rtl8_4: typo in modalias name
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Might as well add Fixes: tag since this fixes cd87fecdedd7 ("net: dsa:
> tag_rtl8_4: add rtl8_4t trailing variant") and "fix typo in modalias
> name" on the subject to clearly state the change.

Thanks, Ar=C4=B1n=C3=A7. I've just sent v2 with these fixes.

Regards,

Luiz
