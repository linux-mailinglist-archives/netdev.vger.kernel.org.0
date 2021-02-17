Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FE031D520
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 06:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhBQFlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 00:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQFk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 00:40:59 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1323C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 21:40:18 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id n14so12670296iog.3
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 21:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1hz/sIXhPkIaQhHtZ3K3rXNYQ85bBkMQLZadAR/3uHU=;
        b=rOYjbLDHTwMZlUCLWhZfhViLx1xgLRGyGN3sNd6J4qIkDNPeoSrQN/YvUzpLRtmhnz
         EigbvDveyDpQ5V+p7Zz2leg858xVcJWjo0hoUSCydfrvjir8iRSdGRlUGQhr8soWeJfs
         MC4/oCeYO6RSowur3YeCsCdPHW/QcLeVGUrgDo8QqztmI7M31v/7Tvfni1XSvpOjRYDA
         oCwciJTrZTsldrS+TCuk8Rt/MBMsWzIirIUCklyAmm79qBKDVIJTMJf5VxMalyEA8w5N
         86StA2c1baNO1xFJWD9jqJuUQzgpeCuFRnDQ5J5HzyCrlYGtQGGeso0ZTn9grI9hiZB5
         lrcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1hz/sIXhPkIaQhHtZ3K3rXNYQ85bBkMQLZadAR/3uHU=;
        b=Q+o3QjgJD/M+qNGaqLtZRpEdL265ka3qAhUNmZWQ9Nmzb7aSPJ7+1OqZy4LEbrLCHn
         q2oEG2qhdzzun0+Cn3ZVpAiYZsSPVGCDt+hGp2QPQ6PE50B0DKhgvthk4ma22QPLlnPa
         zbuYxwWo4vmxOy3Yf74FS5EW59ZwzYLZEXUo0HvoiUwl+5Q9di626acxNW6FKlYQh79l
         5jW+4SGw7haZg9HjIn9qW5hHnNQ+23LoQD0y+GbctMXNtclaX5mRjQ2VA/Ok8/3Br5RA
         7++3vrNkwuhvNiRQ5ICqGmOPXm7KqODPwyqRiPRi+cu4JVKntAjW6KzcRaWdNWxNlJb2
         VUVA==
X-Gm-Message-State: AOAM532r7T3Dh70fPFp7P/p+Tx57jO3OivS/ybudGVdD6rq2Q6tVFmUJ
        05KSES9SO5Q7y070X/FMWGLAlheh4qtc2UFK10Q=
X-Google-Smtp-Source: ABdhPJxoIKeNsSrKhYkpOSwE9hYG7cwUfZ4+exKu9kcD6b7qbqVrUyY+x/JxBD0lXuEFkv+PLGFuG6uPudQLL/zcPS8=
X-Received: by 2002:a6b:be86:: with SMTP id o128mr18812268iof.111.1613540418429;
 Tue, 16 Feb 2021 21:40:18 -0800 (PST)
MIME-Version: 1.0
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
In-Reply-To: <20210216235542.2718128-1-linus.walleij@linaro.org>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 17 Feb 2021 13:40:07 +0800
Message-ID: <CALW65jZr9QPg3uyATSRg-u_xyy1xFO=VFUWqX4pD=upBatAZCQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 7:55 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> +       if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
> +               return NULL;

skb_cow_head is unnecessary here. DSA core will do it for you.

> +
> +       out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
> +       /* The lower bits is the port numer */

Typo?

> +       out |= (u8)dp->index;
> +       p = (u16 *)(tag + 2);
> +       *p = htons(out);
> +
>         return skb;
>  }
>
> --
> 2.29.2
>
