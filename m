Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791F34ADFE9
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352757AbiBHRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiBHRyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:54:46 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0DAC061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 09:54:45 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x3so18235pll.3
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 09:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zo9G5XI4KK2J0rUfA8geyvUCNYm6EZa+VqZ0aCvNzGo=;
        b=v/o2IhMTp4ca3YA5q1vN1rB5ZyiBwSIjSUs8dx/RMwJJ9UFw3ZyTe/eqVoMx019KQf
         G/SHK74w0PDOt1EdSdT2ngLGN4M/R4ttg5qFYqhXHl1+Qd254FeqQB3fqpMxGnO7RNJw
         xrIPtd0dXPpE7+pXMyQQdGIYawY6pXPrAPw6Vlx3tKhT6kUc0bP94Y/yRZ3Gt9YHDOtw
         yWANXxRM0q/uEv5XFIwW6uLXhKRbRSCHzmqTFV/mlZhrcnUvBFTOSq0fT6RHbvo4oz/v
         j87DuWfjhlMOS20gatIYn3Z7uEy5yR8ycNqYhMdKUyR1ZwOL2592y4jN2WCwnehHs2u7
         RXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zo9G5XI4KK2J0rUfA8geyvUCNYm6EZa+VqZ0aCvNzGo=;
        b=6UYJBmLsipxwp47JVcCER+h1TARdQRrr99IA/aUfKEcCbJKC63qA1j5fZPeH2Ipy7Z
         GeH8Tzsm6cF4hZ6lfhvrL+cN74RLz18Sp0zCVgaYXxPxgX4bm+/SnheoawKHzKq+Mitz
         xJb3SW90nti7aaQFd+mp//oDUimwKFxfpLhM540kUtrM+Cwm1tvfy/ANErQ2DkaXavLp
         yfWdvDcAx+l4+dx67luMN+qCSXUyPlFa0kDFSnhsxNYTNHWBKhIfUJD9aOrtd3McF+vQ
         ktPd1xclkjgeo0zKqoElYRzp89tSbkzOkTeIe9VLI5m6a58CvqLfg4bgwiJtLHNTZtiL
         yk1w==
X-Gm-Message-State: AOAM532WfdTCY+Lj0/BLwCov6E5jEiYXHv41CgmNHDcRuHkV9R1zzzPq
        8IChKlPKjohltcuIOe58vbBdEg==
X-Google-Smtp-Source: ABdhPJy9dARwskTkWWgaYqHF//pDqSBeHX7tE/ezX/V0NR4IFHkzGX+MUDzdiSZ+kU8o1tyddm9RTg==
X-Received: by 2002:a17:902:f685:: with SMTP id l5mr5537431plg.66.1644342884608;
        Tue, 08 Feb 2022 09:54:44 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id y20sm16548629pfi.78.2022.02.08.09.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:54:44 -0800 (PST)
Date:   Tue, 8 Feb 2022 09:54:41 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Marta Plantykow <marta.a.plantykow@intel.com>
Cc:     netdev@vger.kernel.org, people@netdevconf.info,
        milena.olech@intel.com, maciekm@nvidia.com
Subject: Re: PTP-optimization code upstreamed
Message-ID: <20220208095441.3316ec13@hermes.local>
In-Reply-To: <20220208132341.10743-1-marta.a.plantykow@intel.com>
References: <20220208132341.10743-1-marta.a.plantykow@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Feb 2022 14:23:41 +0100
Marta Plantykow <marta.a.plantykow@intel.com> wrote:

> Hi,
> Together with Maciej Machnikowski <maciej.machikowski@intel.com>
> <maciejm@nvidia.com> and Milena Olech <milena.olech@intel.com> we would
> like to inform you, that the source code of the script used to prepare the
> Netdev 0x15 presentation called =E2=80=9CPrecision Time Protocol optimiza=
tion
> using genetic algorithm=E2=80=9D [0] was recently open sourced. The devel=
oped
> framework provides an easy-to-use automated methodology of tuning the
> Proportional-Integral controller embedded in the linuxptp project. In our
> research we=E2=80=99ve reached up to 32% smaller mean squared error retur=
ned by
> phc2sys test (comparing to default PI controller settings).
>=20
> The code is available under this link [1] along with a short
> documentation. A NIC and a driver that supports 1588 is required to run
> this test efficiently. All contributions will be considered for acceptance
> through pull requests. Do not hesitate to contact us in case of any
> questions or concerns.
>=20
> Marta
>=20
> [0] https://netdevconf.info/0x15/session.html?Precision-Time-Protocol-opt=
imization-using-genetic-algorithm
> [1] https://github.com/intel/PTP-optimization

The process for contributing to upstream kernel is very well documented.
Links to github is useful, but does not start the upstream process.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#subm=
ittingpatches

When can we expect patch set to show up on this mailing list?
