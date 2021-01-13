Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94FB2F4E80
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbhAMP0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbhAMP0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:26:35 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD60C061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:25:54 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id n142so2045557qkn.2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5REFkvBkLZTDCas7Aq9b467GWGymcyGVkMq2x6jrBOs=;
        b=M6BNRkbgPh8e8SVN3WLGxZ75r5M4C2mgdl5sxSpc0f6S2ZT8f4QmWbZ9oJVTGiG3le
         YzFpKJO/qPOj+36oDVAjHkO53LDLUJ4Dc4yGEILlLAtILc+Pumr+Og5p77Amuwn8OEur
         i/jdcT68Qt2RFaRjdmOdw/qxmv8Pn70zTW5D/jgku+qAtRlQV+/vt/rozL4FKdE8mlH+
         19UNd/qBaG17oYCuvj5zXR3viRGH3M72VZcjvXNciKZ+W/WJ+7fta7Pqvhl37tg/hg9L
         3GkYobft/XkHtkM/7yco9Jz0mPmw5hUy5f8lizZK0ZYdu8xzJoyjTwygnOLY2NliEDk/
         Iywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5REFkvBkLZTDCas7Aq9b467GWGymcyGVkMq2x6jrBOs=;
        b=IP4Y8YhG8psgiK3IdGl30JhGz8WIGmW0uIKeWdfrzuxqXhRduF05Phwqhq7UvNY2Lm
         NgeZdKLHElpACFf9btmfHGn9p/guQFVT/bgEuTD6Uhe9wQdhrL3k5YmNkQthBAiasftS
         qyBLiCsKEYFBl4kUWDw94SgFaZdMGtwyLyaJrUjrQbazwHyn8xSNvRj3GzSYp9fLKds3
         ZSCR+O6GvNjJ2S48Yx7HXSTcY3G47CYkkiGh9TxhosczeXX+J8CiplAqxj4p7/9LVF6t
         4IZXfnObTDfVkwbcaI4bX8AyaJ7FFWRaz+rNQ19BM+D1RcsmITq9bl902ETmpSaTwY1Y
         nuJg==
X-Gm-Message-State: AOAM530EJnP2LhgJ6V3zsxOTUXCMvAXmyPlgcr9lEUAi1e/9C411T7kG
        mmiGKFb8f6od5WEW5jID3Pexk6MxbEV6AO7c+jI=
X-Google-Smtp-Source: ABdhPJzKp4XjmkLWzW8oDktCJUnVSWhT5LDySZTE+NzCsl9bZi3IyQKBhPVA0cGOYaEEPA8WswdwgH6VUOo8QxsBlPk=
X-Received: by 2002:a37:a4d3:: with SMTP id n202mr2544956qke.78.1610551554192;
 Wed, 13 Jan 2021 07:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20210110070021.26822-1-pbshelar@fb.com>
In-Reply-To: <20210110070021.26822-1-pbshelar@fb.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 13 Jan 2021 07:25:43 -0800
Message-ID: <CAOrHB_Bc_WTY3AA-o7sUQ-ycVg6sUvHDjukRufyXkT43e3nn-A@mail.gmail.com>
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
To:     Pravin B Shelar <pbshelar@fb.com>,
        Harald Welte <laforge@gnumonks.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jonas Bonn <jonas@norrbonn.se>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

On Sat, Jan 9, 2021 at 11:02 PM Pravin B Shelar <pbshelar@fb.com> wrote:
>
> Following patch add support for flow based tunneling API
> to send and recv GTP tunnel packet over tunnel metadata API.
> This would allow this device integration with OVS or eBPF using
> flow based tunneling APIs.
>
> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> ---
> v4-v5:
> - coding style changes
> v3-v4:
> - add check for non-zero dst port
> v2-v3:
> -  Fixed coding style
> -  changed IFLA_GTP_FD1 to optional param for LWT dev.
> v1-v2:
> -  Fixed according to comments from Jonas Bonn
>
This is the latest revision.

I have started with OVS integration, there are unit tests that
validate the GTP support. This is datapath related test, that has the
setup commands:
https://github.com/pshelar/ovs/blob/6ec6a2a86adc56c7c9dcab7b3a7b70bb6dad35c9/tests/system-layer3-tunnels.at#L158

Once OVS patches are upstream I can post patches for ip-route command.

Patch for iproute to add support for LWT GTP devices.
https://github.com/pshelar/iproute2/commit/d6e99f8342672e6e9ce0b71e153296f8e2b41cfc
