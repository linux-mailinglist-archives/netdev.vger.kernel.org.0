Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4DF4686EF
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385392AbhLDSTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhLDSTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 13:19:19 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DFDC061751;
        Sat,  4 Dec 2021 10:15:53 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id s1so4042767vks.9;
        Sat, 04 Dec 2021 10:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gcjWTdeYmEAK8BKH8y875YWyYwkSnAyDJ8wq6K2MIl0=;
        b=fy+bziigGKZo79clMPJJW9ewC+5PF7GFgYL42eBtnMu8IPIMGHg/kszp66yJn7VIn0
         cadLBAJzYuRFtgriamWa1CmvCIkEpa9O/uoPTrbnnrJqFGln4eEUyh2g6ogyA/+ttsqs
         vqKuq25/AgMYBVSbKu9pd3L8eDCooVfwuAyS6VHusVqAIfrDEYZ5ayJNJGKqni0i8oeq
         HoRI2g19tI9VLOb+FB7f2cfIk8uQjijoGMGefCk+yNXHsuzNodZbtvVlUh1RUvh4ZD2B
         ni4zvmSL6FylysNvOkb0j60/X87ouPb9IQu51kpzeDFXeaT2syBrUIQlEaKZ/1cap/5l
         s71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gcjWTdeYmEAK8BKH8y875YWyYwkSnAyDJ8wq6K2MIl0=;
        b=zgY4/f04qwm1VrEAs2C43ty4MeqUiWruuTprlfJq5sm8Af2245R60T0iLSH3HXY2P5
         ExuIRZ5D1DQd4EF9G4JSjIPTErokM8rrOifuRL2ozsAyrIYTkxzvatkoAmFOCCFDxT1I
         lS9gKT9TKrkjDjUW/VFbUPbcwast/IM82cMr8eYhRPJ5OpWDIKjsXF0p5iJEHs0rA8+R
         nIXBGaZCt3n8tu4yyWr5edbIok8suDBwfIICGp2xO0zlQEfQassooVbkEYmBbJxXiR7e
         LaM32jUy0NFYqxVi7Zds/QAMsmRYTinji1jjQusfEaohtlH7Lk50WiyFD/cXcKGX+VId
         Iwqg==
X-Gm-Message-State: AOAM533Q1F0fMUNyAHmq3NaO/CElDxTMvLiZpatLLNGKYoPFXkBqaqPg
        eLUcxaQTXwz7H6PxkbRpaUY4iMcuNj0tvTrxJGDXaEtS
X-Google-Smtp-Source: ABdhPJw+RlJFZbhYt2o+ukEYJ9A3977XBcuCrYGjVoU1TmXeEew4RWmjbhdotGu3CRd9kOLDj9UkTGCZN/NECHYT73o=
X-Received: by 2002:a1f:20c2:: with SMTP id g185mr30969133vkg.25.1638641752023;
 Sat, 04 Dec 2021 10:15:52 -0800 (PST)
MIME-Version: 1.0
References: <20211204174033.950528-1-arnd@kernel.org>
In-Reply-To: <20211204174033.950528-1-arnd@kernel.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 4 Dec 2021 21:15:41 +0300
Message-ID: <CAHNKnsScMsxMnk5XLM+yBWftAvfhjXb_qmLgwMbVqBVqO77gSQ@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: iosm: select CONFIG_RELAY
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stephan Gerhold <stephan@gerhold.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 8:40 PM Arnd Bergmann <arnd@kernel.org> wrote:
> The iosm driver started using relayfs, but is missing the Kconfig
> logic to ensure it's built into the kernel:
>
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_create_buf_file_handler':
> iosm_ipc_trace.c:(.text+0x16): undefined reference to `relay_file_operations'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_subbuf_start_handler':
> iosm_ipc_trace.c:(.text+0x31): undefined reference to `relay_buf_full'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_ctrl_file_write':
> iosm_ipc_trace.c:(.text+0xd5): undefined reference to `relay_flush'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_port_rx':
>
> Fixes: 00ef32565b9b ("net: wwan: iosm: device trace collection using relayfs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
