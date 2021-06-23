Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC23B1A44
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 14:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhFWMgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 08:36:16 -0400
Received: from mail-vk1-f178.google.com ([209.85.221.178]:34347 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhFWMgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 08:36:15 -0400
Received: by mail-vk1-f178.google.com with SMTP id n131so470092vke.1;
        Wed, 23 Jun 2021 05:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eq47jlD9rRIbwItnuL95r8TcXuN84bJ8pq53wED0AfU=;
        b=WGwk8XyX/IZn2dSQNywZIO+pFQAnFd0FaBZScmIJorOIOjAbv23IF40H1ftVC6eNyT
         FJvIS7LvrUut9BvEbft+P9AZIvVg7GmEH0kneHH4NmTf+CAKD/M+4ey+VoTBYhbDdPBO
         liYZCfeFlxfPC8GSBXIsC6sWlRuRuZY7fx3e07QXzrSNuZjKhddYV0ZnNBVD5dJUMO2s
         Vz8w91dHamt1tXuuwqXIIROIDeMkRKYQcBS803rP5XTPC4pxFQb/1YzwdPmnhOuovbCk
         FkZzH8tbH1qJ+eBvxB6EOk2epL7jwOIw46DDUCzEHMmZPCrf1y12mFmmcjVmsXvqNzmJ
         hSzw==
X-Gm-Message-State: AOAM530qLViXX+7rsyKuWJ59yOQAWoSd6JoCEwPevz5Ug842DmBlz0mF
        0lcA0xFx/pi7fQiVm2ayWfX2YE9KG6/R+aKSQHU=
X-Google-Smtp-Source: ABdhPJxvXljxigYacKxNnp3SS1FkLz+k2UbsFYKnphOTMaXHVQzsMoDW3NJsylx8tUEcC/4Fhh6dV6SoTDxS91zvoho=
X-Received: by 2002:a1f:9505:: with SMTP id x5mr23451872vkd.6.1624451637217;
 Wed, 23 Jun 2021 05:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210622113327.3613595-1-thierry.reding@gmail.com>
In-Reply-To: <20210622113327.3613595-1-thierry.reding@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 23 Jun 2021 14:33:46 +0200
Message-ID: <CAMuHMdW=VYvApsxAk22Nszbp+veu+4ZeN077tU5-GU4ijONF6A@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: sja1105: Fix indentation warnings
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 1:31 PM Thierry Reding <thierry.reding@gmail.com> wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> Some of the lines aren't properly indented, causing yamllint to warn
> about them:
>
>     .../nxp,sja1105.yaml:70:17: [warning] wrong indentation: expected 18 but found 16 (indentation)
>
> Use the proper indentation to fix those warnings.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Fixes: 070f5b701d559ae1 ("dt-bindings: net: dsa: sja1105: add SJA1110 bindings")
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
