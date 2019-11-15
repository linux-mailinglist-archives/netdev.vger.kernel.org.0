Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B310FD9F1
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfKOJvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:51:38 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39837 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbfKOJu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 04:50:27 -0500
Received: by mail-lj1-f194.google.com with SMTP id p18so10020966ljc.6
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 01:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/UA8N9071Hs67JB/CtCLOKYsRujWaxB61T4BkLclrk=;
        b=Uj//MN/eYpagIL5SFVK5o9mqojQITuF2XVCgryREyFOYqXwn9xWNIEKr/hnSu/yd37
         OgcpwNqi83ryL9yGP1i3iNYM1NbRKkpytuLcvx7ux/H500d7XGmBTA1gGyjzvIoV1iEw
         ld7CduY+HoP5HPEWtCzcfMm9I2Dm+Qz4o73G7hmWuJKiE/659BHe9isr8jEu6zfrXY5w
         p6E8t5bh/a39/Z0Xs8X8yXae3wjaBpHdwtcjDJIrI75l11sES3dl5SnTE4LguB/l+0rp
         l/TlA8QLOU8hAcIlE+mlbdA00awq8mAiygKQOZVYY63BinchNpYcFAYnxZkBzVC+ig3U
         4gDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/UA8N9071Hs67JB/CtCLOKYsRujWaxB61T4BkLclrk=;
        b=nJGPlbGHs8mOrl1tk8WJvdwb53YrzxWTYbEIoYtKzPVZT4BJAj11vxzMKFJxZIo2oK
         g11KVUXIdRXDyEmmHT8F+R+U5mo0oMMduHdD1TNLcgE08b9JgskGFfh+mmREsiBPjf19
         xjXWHEuTxIdYL09IVgiHyPC/RkGxq155UwwwGsX07aKoWmlgG2iDTzuCZ/tLOEin5for
         DXCKta1T0pqOzUZj0rph8fyyCaMuh7+ykW1flcDPH5+4cNgTzj/EmeJ4PpVdBKBdHRHe
         TpTrOddnYoh6duZnnSjd064ze0LpZmJqnoD1IJ0T2bC+BTIDzN8wmAUkIpyUbts8mbSg
         94dw==
X-Gm-Message-State: APjAAAUm6Xg0iwKcEhFbdRa8xa+AjZ6ss3ZBbs9fSD4ziuL1Qv1bkD1k
        o79/CJvOKCj+ptvvAepoMi7XnjHKfadTmlcOGBMMGQ==
X-Google-Smtp-Source: APXvYqzoH0lE2meSnOsWYn4w2Vnm6zFN87zG7pAIdO4qZpC8+1a/pUkOgr9YtQTghftKTYLC9GIcmmSSdCngI9weV+A=
X-Received: by 2002:a2e:161b:: with SMTP id w27mr10500539ljd.183.1573811425820;
 Fri, 15 Nov 2019 01:50:25 -0800 (PST)
MIME-Version: 1.0
References: <20191115062454.7025-1-hslester96@gmail.com>
In-Reply-To: <20191115062454.7025-1-hslester96@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 15 Nov 2019 10:50:14 +0100
Message-ID: <CACRpkdaXcas08jy+oZOi4fKuXZYkbFAOipqf49smSdGd6TmFag@mail.gmail.com>
Subject: Re: [PATCH] net: gemini: add missed free_netdev
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 7:25 AM Chuhong Yuan <hslester96@gmail.com> wrote:

> This driver forgets to free allocated netdev in remove like
> what is done in probe failure.
> Add the free to fix it.
>
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Looks correct!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
