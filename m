Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A06E3B092C
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhFVPfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbhFVPfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:35:17 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0291C06175F
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:33:00 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w1so10973090oie.13
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8E5zUKIlDT49ILhfjr1wPmot/fERd7XyTMDXB/zGLdU=;
        b=udgoghlLfQYQyrSR2Z9GBWidHQlJiDbm0EYt6Ey8F3Dlxh6AzQAiFAmxXVdS/50+lI
         S3TAeh3aEn/AxZCXXVuKzj9N78U3XV7PNrLiXwBIHiShPBUiRYTrW1ZEzZ5AlGQ1F8tZ
         3QC5sYddVMff+pXaQmrMsYFHsjljeFlRzh2kwSK7Dql5tkTcNyB8pdx+kDGVLKq+jxNV
         oi77O4o43BvLy2U8vLVHa9GMrIqkXG4vAIVC94qh5EYLO8dGTWCXoGlfI3w+Ma1/mc9J
         oP4RtBjyL+UDvxTHtY6iaqzgTMsrUrW1fqLX4XAgLcApMr+8IniN6WC+qAGDZbT5DOEC
         hXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8E5zUKIlDT49ILhfjr1wPmot/fERd7XyTMDXB/zGLdU=;
        b=Ons+tu2wZnHnp9k/DpSgAijncuVHk/OqtTHmlZw/7aezn50iY5vFOav9bmBOw8xWd3
         3fwYEZgB4UUbwyv0JMErbFhWBkn0h1d6LuFzj/cDF7LabXnCV81VN8l0c1Muf7Mgtgbc
         TVrZ8rv95VCtgapEY/cXbS3zOyL87VTze4Q6dR+UzhIhN+75UVaKvohVkwPsddbSIStF
         bdk07Drhtjb7oJu/y1jXs7765alcN2JugZ+ExfP7O61Xxr8jgd0Zjotb6qDxQ1C536zK
         jaN1eLt4RoVxpNwqkaRTGoQmxmBWd+8Ibj2khbNMoOwOdwSyqluhyVDkXN56NHn5M1Pj
         CzPA==
X-Gm-Message-State: AOAM5318I37LmtOlYSmp1NNsCKOdNq6pvNwf9XXITVbVKLJni4qgqDFU
        wuUBnfQMZdhtzB9Vjl06mSweOD0HLmWzxUmi3dE=
X-Google-Smtp-Source: ABdhPJz3J1gJnh7krN6z+iF8HxHDFoSmk5o/P/kl9qKc1VgiVhyVpGh50jnNZ3rERmSr2E9IkFuaRRyNoDrFcDmnS68=
X-Received: by 2002:a05:6808:1388:: with SMTP id c8mr3422219oiw.17.1624375979211;
 Tue, 22 Jun 2021 08:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <1624371700-13571-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1624371700-13571-1-git-send-email-loic.poulain@linaro.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 22 Jun 2021 18:32:48 +0300
Message-ID: <CAHNKnsTpbtFWu3rsnUjaKwQxS0QYAshkO3HQNRWgEJ_Vp0vr8w@mail.gmail.com>
Subject: Re: [PATCH net-next] MAINTAINERS: network: add entry for WWAN
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 5:12 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> This patch adds maintainer info for drivers/net/wwan subdir, including
> WWAN core and drivers. Adding Sergey and myself as maintainers and
> Johannes as reviewer.
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 395b052..cc375fd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19803,6 +19803,16 @@ F:     Documentation/core-api/workqueue.rst
>  F:     include/linux/workqueue.h
>  F:     kernel/workqueue.c
>
> +WWAN DRIVERS
> +M:     Loic Poulain <loic.poulain@linaro.org>
> +M:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
> +R:     Johannes Berg <johannes@sipsolutions.net>
> +L:     netdev@vger.kernel.org
> +S:     Maintained
> +F:     drivers/net/wwan/
> +F:     include/linux/wwan.h
> +F:     include/uapi/linux/wwan.h
> +
>  X-POWERS AXP288 PMIC DRIVERS
>  M:     Hans de Goede <hdegoede@redhat.com>
>  S:     Maintained

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
