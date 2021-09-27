Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71CD419FFC
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbhI0URn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236763AbhI0URl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 16:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46BD5611C3;
        Mon, 27 Sep 2021 20:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632773763;
        bh=Lb3LIgfAEjVXdf1vE2V7OoMMbogeWMravjEabJ1Nxyg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aoqynUkGyB6ZPUI0PZbhRVWrRQEh4dUFl+HnGRbJEjz36swl07OI+waO5juXrxZEL
         jHlAKLJtp7vLEn53dGPq9ybdvqoV7skp3bnJ2v0dt7b3LCLaWszZoJwfgXGV5CewIZ
         EeT9Puax/p5vO3xFfjNQpP/s5z+vV6IucH/tDVc9OrhV9apJ4xfqmWfbZVQ6mT6zds
         T7V/1iyHvtmaHFbCozBGLs87R9buQKkqhGe1GFJbwuhVxRAw/14pw6aQABaZ9IXQ/3
         OdqLZFHV5ZJBQxWkAwNJ0thZGMxGk74lNv+sDueBnQKqvqp7vbKRWok7c77AtHcBAs
         PL2/kpsfVk1jA==
Received: by mail-wr1-f53.google.com with SMTP id g16so54027899wrb.3;
        Mon, 27 Sep 2021 13:16:03 -0700 (PDT)
X-Gm-Message-State: AOAM533A9Dlo5xlQ9wTe8lwQ5Rw/y18zWiNA8hEYg0fKcAx9F0YYwwjL
        WQIZl1vHv7uaSF3bXhgVCcdRMt2ZOCzYk9VWg9E=
X-Google-Smtp-Source: ABdhPJxhSUG+xfsMcnYBJG/aU9zQ/jW83Rbf6e2ezlqzSM1qdDuC1ur8sa8pPTTU3lbMghJJfkyUaLecI/p3sCcMSis=
X-Received: by 2002:a5d:6cb4:: with SMTP id a20mr1431020wra.428.1632773761805;
 Mon, 27 Sep 2021 13:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210927152412.2900928-1-arnd@kernel.org> <YVIg9CxJGaJr1vpp@ripper>
In-Reply-To: <YVIg9CxJGaJr1vpp@ripper>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 27 Sep 2021 22:15:45 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1fEuFsQVY9b1oGdTOHzr8pu9wvrSBCMn2iOvgWqtHNnA@mail.gmail.com>
Message-ID: <CAK8P3a1fEuFsQVY9b1oGdTOHzr8pu9wvrSBCMn2iOvgWqtHNnA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] qcom_scm: hide Kconfig symbol
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
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

On Mon, Sep 27, 2021 at 9:52 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
> On Mon 27 Sep 08:22 PDT 2021, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> >  - To avoid a circular dependency chain involving RESET_CONTROLLER
> >    and PINCTRL_SUNXI, change the 'depends on RESET_CONTROLLER' in
> >    the latter one to 'select'.
>
> Can you please help me understand why this is part of the same patch?

This can be done as a preparatory patch if we decide to do it this way,
for the review it seemed better to spell out that this is required.

I still hope that we can avoid adding another 'select RESET_CONTROLLER'
if someone can figure out what to do instead.

The problem here is that QCOM_SCM selects RESET_CONTROLLER,
and turning that into 'depends on' would in turn mean that any driver that
wants to select QCOM_SCM would have to have the same RESET_CONTROLLER
dependency.

An easier option might be to find a way to build QCOM_SCM without
RESET_CONTROLLER for compile testing purposes. I don't know
what would break from that.

     Arnd
