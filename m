Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4EC27764C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgIXQLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbgIXQLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 12:11:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC76C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 09:11:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x123so2180539pfc.7
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 09:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/uvFbmfxmGf/2F1bY+AH/gMASikL2rskakm/u8yYK0=;
        b=JJhXwnOkHIOqSmzPIv+YY13LZO1OaxlKgMqrhQ5FYLBbpdK9LFJnlcQ/sHEcZQOthe
         dcaX9Hsmg5Nf9ruc2SstAF2IYtoswanlwiPfiDZ8IMARAUrzRVuBEw9NaEcUjX4LmSkc
         1UlfD2j0oMKTanYP/DEHzK9RHeMKt8RDkc9IaemX1fG/CbLkX4pN09v+qHXCQ8Qz3mI8
         P+g8OATHKCoJvej5yx6EzBWdgb4N9KPnuzBBbJELWPZIqTcC2hBxR3BXP5QXnRrdJg5t
         DWjM34+EwNaf61C1TFbiKx0PSuMa/9oafPXuRPgFTQMIwFPS8lneCPrlnXt114lb32gT
         sjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/uvFbmfxmGf/2F1bY+AH/gMASikL2rskakm/u8yYK0=;
        b=LEhjx2zfxL0k8zBw+3UXcrEVuMc6F2lb8rS/9/Td+NpDFeF+ZPDjUmHvnYaaeJaztR
         l+/UbzKDGm1U+E7eMIGRPqzvH0dTNRWC5imQeFl0AQCo30VLYb8GOTfN4ZZquyeG7xe4
         2VxrwESMaCFT6eeEAIWkDWYv4cqhjPilPM52ZwbCAQnSuwlAUjjuZsyAH25hyV+PRMNf
         olocJ2l5YNT8tOvPLRnkdjX3nxCO0qHFHPFmFTUG3+63N1uWIYMUOVmLwUdNMPgFJYJt
         gIo9p9ch+zUQsDV2GA/y3SR2UUFq5VDI9I8h5uXLAgI2gqksmaJqcxNoM1/+xxgpBbUP
         3Qcg==
X-Gm-Message-State: AOAM533VXu8zb2RwZqylHwWDqQTYZK289b3IMQovqNTrjFrGbMLZBtXJ
        eojJNRXCmlNCZAmkz4tSigKzTIAhXR6vQw==
X-Google-Smtp-Source: ABdhPJwB9B1wpr5Vu+ODhAqdinxSD6a6tXeA6htybauN2hOOUNnZBJdmpvm7uBXL92X96zd51xy7mA==
X-Received: by 2002:aa7:8ad5:0:b029:142:2501:34df with SMTP id b21-20020aa78ad50000b0290142250134dfmr5254795pfd.56.1600963875841;
        Thu, 24 Sep 2020 09:11:15 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g9sm3462491pgm.79.2020.09.24.09.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 09:11:15 -0700 (PDT)
Date:   Thu, 24 Sep 2020 09:11:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] build: avoid make jobserver warnings
Message-ID: <20200924091107.1f11508c@hermes.lan>
In-Reply-To: <nycvar.YFH.7.78.908.2009220812330.10964@n3.vanv.qr>
References: <20200921232231.11543-1-jengelh@inai.de>
        <20200921171907.23d18b15@hermes.lan>
        <nycvar.YFH.7.78.908.2009220812330.10964@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 08:15:59 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> On Tuesday 2020-09-22 02:19, Stephen Hemminger wrote:
> >> I observe:
> >>=20
> >> 	=C2=BB make -j8 CCOPTS=3D-ggdb3
> >> 	lib
> >> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
> >> 	make[1]: Nothing to be done for 'all'.
> >> 	ip
> >> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
> >> 	    CC       ipntable.o
> >>=20
> >> MFLAGS is a historic variable of some kind; removing it fixes the
> >> jobserver issue. =20
> >
> >MFLAGS is a way to pass flags from original make into the sub-make. =20
>=20
> MAKEFLAGS and MFLAGS are already exported by make (${MAKE} is magic
> methinks), so they need no explicit passing. You can check this by
> adding something like 'echo ${MAKEFLAGS}' to the lib/Makefile
> libnetlink.a target and then invoking e.g. `make -r` from the
> toplevel, and notice how -r shows up again in the submake.

For context:
https://www.gnu.org/software/make/manual/html_node/Options_002fRecursion.ht=
ml

With your change does the options through the same?
My concern is that this change might break how distros do their package bui=
lds,
and cross compilation.
