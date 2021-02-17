Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11F31D962
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhBQM25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhBQM2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:28:55 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C47C061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:28:14 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id a7so2341188iok.12
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JMUXaRzFwOWedol+EImFcDzDlTmBKdoTouYSnwNtF9M=;
        b=Yh4VSut3xSEyRBAlkx90bCy3lDrJG+2wCcFvSjXhemw1twLAeObsXj6KyMUdnPhPKS
         fC+UAnjLMxCxMBuyiJO0At9FRNCPgLTXYeFef61yX8YLotqv5eaSvgYrE8vzX+ToWfVg
         EiDdlRUKwqqVyhL7vsyAnFIJROxueg5SH1oIZ3Fhk3708mXFALog0Xv3RAnKr4WhUkoo
         kfK3xC5e0+3YfBhKAp41qOh3hcNsxKg0dRhfCZ+lF7FpFuSQ0RpGE0JVs9jOOrPDTg96
         xiXFGPlFGW2ktPLrWZmRqQmxgiSSsQOjaB359VilPQzzR3iNKfwgWiTJRirrPKzX7XpC
         v5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JMUXaRzFwOWedol+EImFcDzDlTmBKdoTouYSnwNtF9M=;
        b=qF2YGgTpq0MAdPiPYR24ywikbZL85XQdvNauhnQqqde3V1Fd0XhucsUDfS0ik3uwKd
         g/FAbLJMtx+LnkIZYh316S4bhex086MiMbhxztqdkGk73t647tmBngEuHwsbW0tTduW5
         787rZVeZaRxMeT+banqQeCsHEmMSm/e36YFze+84D7irnfH9xiHuovo3K1WxAYPqaPOi
         X74LbCJuSJhtCRI+v15XpMAFEvMxKb+nEMX1a3L2cnX69TWGe+d20M1tUb0U9oJfcqMM
         hfQKsGe4EKDvzt5X2/zgi7GG+Qt6IEnJ1z7c1Q/sFaE1FWdOd+swon8goIdG6cGs2sWB
         vWSw==
X-Gm-Message-State: AOAM532WqYnRlvqbre5IHC6PwoZB0TQf+r9rAAFBjsGzgOv0kzINS//A
        ZzsUtaxXYyxLFAnDqKrwIabKuyWcA1+vdIMzgBc=
X-Google-Smtp-Source: ABdhPJwK4KR57ZCe+b6QYoBp9wFY60nQgX/H8MALhqetnPhuA35EWpVTULQF+m25UsAGxb2KNjANGLUM/Nehtfwt4G0=
X-Received: by 2002:a05:6602:2bd6:: with SMTP id s22mr2210321iov.39.1613564894344;
 Wed, 17 Feb 2021 04:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-2-dqfext@gmail.com>
 <CACRpkdYq2pE-6QKFXG_tEQ-8_gsuzDkusPpB8N_NVqoSE5u5aA@mail.gmail.com>
In-Reply-To: <CACRpkdYq2pE-6QKFXG_tEQ-8_gsuzDkusPpB8N_NVqoSE5u5aA@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 17 Feb 2021 20:28:03 +0800
Message-ID: <CALW65jastCPRmJ3EixttJatL2nC-D3GmSdN3J8wbpgkeM7ELVw@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 6:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> I suppose this switch can just use the existing RTL4 A tag
> code after the recent patch so this one is not needed?

No. Different protocol (0x9 instead of 0xA) and different xmit tag
format (port bit mask instead of port number).
Please take a closer look.

>
> Yours,
> Linus Walleij
