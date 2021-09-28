Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE741A95E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhI1HKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239068AbhI1HKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 03:10:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D26DF6127C;
        Tue, 28 Sep 2021 07:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632812941;
        bh=UL3HabPZo5poDvomfSgnMsUOXswOov4XaFV+Mhe/hPM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=peKRlRdshfCDM0WKkr1XAFZ5JA0DCpMVcB0qXm9NxkojuV08GN8y4VUWHQuL7c9ZY
         6sWn8yb6HkL33eo7lHoIpmV+16YmcV5URUsbb5ROqMLP/B2oYGO9uzYlQKzwmYIte9
         JjCrZb+8LY02VUAqdkytXO6BXCrNT6hTbVe6tjxqsCJOIcI5lKKEAFEQw+MtMj1kd9
         7TD06BzKQnK5KlREkvXV6RcZ4dYFoBhJ+Sg8NqJMxbI95VJng6XTqHy4AQImO9S4Kf
         gEL4X76N6d2P14bUwruG/Y5pIfa3QIReUn3JXZEw80+7KD8/DNNMDPScLhF7pMaSHH
         +Epm+raz+IWiQ==
Received: by mail-wm1-f52.google.com with SMTP id 136-20020a1c048e000000b0030d05169e9bso1249623wme.4;
        Tue, 28 Sep 2021 00:09:01 -0700 (PDT)
X-Gm-Message-State: AOAM532eFBrVLN0yyjVeef3QUJ7y/HUlJr6qjLOy5iZfdwwYYBbQwv6z
        kmM47WsEAOJ+SNiheGd/9UfQm5XreTmeoj6zLKY=
X-Google-Smtp-Source: ABdhPJy7UdwG5CMt3vBprQtkQXDtnziSdWAdhBrxF2DYHzwuiJfWIuOu4DEBfNVS3j3HCobxe7h4te4Xc8Y+nnvjU1E=
X-Received: by 2002:a1c:7413:: with SMTP id p19mr3161995wmc.98.1632812940328;
 Tue, 28 Sep 2021 00:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210927152412.2900928-1-arnd@kernel.org> <87k0j1qj0i.fsf@codeaurora.org>
In-Reply-To: <87k0j1qj0i.fsf@codeaurora.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 28 Sep 2021 09:08:44 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2FiMLZK7W9L9XD5h=3yS8QJ6iMr0pXHtCNrpctZG4FhQ@mail.gmail.com>
Message-ID: <CAK8P3a2FiMLZK7W9L9XD5h=3yS8QJ6iMr0pXHtCNrpctZG4FhQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] qcom_scm: hide Kconfig symbol
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 9:05 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> Arnd Bergmann <arnd@kernel.org> writes:
> > From: Arnd Bergmann <arnd@arndb.de>
> I assume I can continue to build test ATH10K_SNOC with x86 as before?
> That's important for me. If yes, then:
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Yes, the difference is that this will then also build the qcom_scm module, but
that should not cause any problems after the other changes in this patch.

      Arnd
