Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7CB479844
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhLRC5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhLRC5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:57:47 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5367DC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:57:47 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id 7so6387751oip.12
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LPgAeF2XPufwew9hqyVx4BsEFDuGKIQokJtAGf28FvA=;
        b=Y7XSURZh5zVrcPQbmRGqSEnUBJ9/4eQWLFaXX22kdLjA9bJg8QpLzvEVm8KE3NGqvV
         2Guf4QHIhinycKSNEkLl9bDvLRY7Tcx7gZeWzv18zRRR3NselL/ghsGrSxN+AqTJtYIY
         Ji1w3TbAX4RaA0oilS6Txq0s5vBWbkO7E+M4ZvvsxurTYUS0FMvF+iQr4Bs1DpKFUev0
         Nucb07rZ+Qw1wb0GPnvu2bjHwWqd69u2pQQrtR8Qu/UgbBjfYikK0Em/DoemAFTZ4Hfn
         94/hR7VCyKtIikWNu2hGycJeyIPXpx9mX7qAzW217/RmFQeYAYkS/DdwiHzFBsgrym2V
         0N5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LPgAeF2XPufwew9hqyVx4BsEFDuGKIQokJtAGf28FvA=;
        b=VNSoD1hFA7fIVg+7MxA48cpiiw5KUDvItHXTVxQhbR1ODEYQFr3i0DYqrpvolaC/Hi
         funOJtJY7p6Xgz4LWTB8xNotcPeKGGMWLauzDCKm4SbG6hVUHDDXaqicl42ZpMPj/i0U
         gfXTQRWChInsM4xB3mdmu7Qqbib8SKyQmvPTipMPoMjnHJ6Tnolf2P10LWSfj3LXPnvF
         +B8wIfuogVI19/dP5i+0lEL00PYlPgwLe7b9QedUXG+jd46DHGSSNeZNqeASdIkvzGjX
         PLwp8omzicM+3Fg33yEHORRfXpKaomZrMLFreMeXeg2kWmgO94OOVl4wquWxhoEnK9hB
         b+bA==
X-Gm-Message-State: AOAM532W8Qtu7m9NYTP2yzfpJ2ShCt0qwFbqeDAgkZ5iV2IFdC8IxILf
        aDwzZuf2m4eiPxnJvTNJE7Tas8Wb7V/jdtTMh3z8TQ==
X-Google-Smtp-Source: ABdhPJyiIS4tiF9L4Mval2xTyqeGicZXxTPKYEz6kr/ft7sTkF3wYNO6rsJTBmhNCMsVTteQ9IqqBHLWHQ9CvSDv88g=
X-Received: by 2002:a05:6808:60e:: with SMTP id y14mr4255048oih.162.1639796266755;
 Fri, 17 Dec 2021 18:57:46 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-10-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-10-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 18 Dec 2021 03:57:35 +0100
Message-ID: <CACRpkdZP3jj45Q9Kaky63WfbDWyT1sT6PNSdrVEQ+PYhGmfP6w@mail.gmail.com>
Subject: Re: [PATCH net-next 09/13] dt-bindings: net: dsa: realtek-mdio:
 document new interface
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:

> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> realtek-mdio is a new mdio driver for realtek switches that use
> mdio (instead of SMI) interface.
>
> Reviewed-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Binding patches need to be CC to devicetree@vger.kernel.org
(also goes for patch 1 BTW).

> +++ b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt

I think YAML schema is becoming mandatory for bindings, sorry.
Are you experienced with this?

Check the other .yaml bindings in DSA for examples.

Yours,
Linus Walleij
