Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13E1F6FB4
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgFKWFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgFKWFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:05:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D235C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 15:05:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so3288482pfe.4
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 15:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scktllXtQnr8Jqt5S4XRxCU867nSsRAy4AdCEzw+2yc=;
        b=KjiBp57EIEOnmHrJDVHEvy0/u1h6lUE34Otc+BYfggD8NqFGqrec9FHEbQhhMuRGxA
         Tu/XD1Huq4f3zXmCq+nJUV0TXMSUZA7UU5fNo+qQMMBFyE5YQ14ArrRH04jdZhJdJ5Ab
         DNteya6FEI9DyKtLx+jSEjsNU0vTQbrM5Rw/GOyAyn92WSiHUF5gTHFsMFzDiGsbal3c
         XE49grM/fpGwGFgFvBmGavH0EGpZ4E/vPuKUp1GvraQZ9jDrojN7SZ8kmqN2SDy7YpHH
         91VikXfh9zpbtTe/MaiyeXdmOOgX6HYnRxwOU+px9/+RoA9XjeIX5McV8DvdLQxY3ayc
         7FKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scktllXtQnr8Jqt5S4XRxCU867nSsRAy4AdCEzw+2yc=;
        b=rjslQsA7FV7QmtriboPKLdxxRXSL2yawTx/xgTSzEv+QegZYt0gpwPmhMvZ/nWtnii
         rBZQaopoVEMHVwjIHGdP8YnibYEYDNVVBPEKX3sKFhK4kaJsnL8EgoW1jPa9toR3+gfD
         +G2ot61oR8oENlq2KfKon0hpGNzvuw60pt4BPa40o+LbWt6ySxbotPQcFYvp/Mj0IW3T
         waSKhh1aC4QW5lHxhur9j5Gy6DnOOHRGSwYx5lci2Mpj1ppZ5Ak8qNNbBynrEsLcHiCn
         dtm840QXT2089xmu048ebaIpeykpsDvlqdMq5/D06Ir8+qnxumtWJhqNg8qTn5oSMuQm
         /K0Q==
X-Gm-Message-State: AOAM531SvkIYwfDf1oSPZyanAg7R2dA2/anVlC7ZEoui1LWnHl232Dn1
        FlClirkgwdzl1sbDNhas55Fesw==
X-Google-Smtp-Source: ABdhPJx6/WPpiRD7Ajp2biyNfOA48hUOHNfJSesq8vBkutM6Q3NV8WmVewqyd7+yeFvfRfXdsKZZBg==
X-Received: by 2002:a65:6459:: with SMTP id s25mr8317932pgv.329.1591913137485;
        Thu, 11 Jun 2020 15:05:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m9sm2628015pgq.61.2020.06.11.15.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 15:05:37 -0700 (PDT)
Date:   Thu, 11 Jun 2020 15:05:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] ip address: Fix loop initial declarations are
 only allowed in C99
Message-ID: <20200611150528.53a6f14c@hermes.lan>
In-Reply-To: <20200611173543.42371-1-roid@mellanox.com>
References: <20200611173543.42371-1-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 20:35:43 +0300
Roi Dayan <roid@mellanox.com> wrote:

> On some distros, i.e. rhel 7.6, compilation fails with the following:
>=20
> ipaddress.c: In function =E2=80=98lookup_flag_data_by_name=E2=80=99:
> ipaddress.c:1260:2: error: =E2=80=98for=E2=80=99 loop initial declaration=
s are only allowed in C99 mode
>   for (int i =3D 0; i < ARRAY_SIZE(ifa_flag_data); ++i) {
>   ^
> ipaddress.c:1260:2: note: use option -std=3Dc99 or -std=3Dgnu99 to compil=
e your code
>=20
> This commit fixes the single place needed for compilation to pass.
>=20
> Fixes: 9d59c86e575b ("iproute2: ip addr: Organize flag properties structu=
rally")
> Signed-off-by: Roi Dayan <roid@mellanox.com>

Agree.
Applied
