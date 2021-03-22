Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E881A34443F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhCVM7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhCVM4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 08:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 674DA619C7;
        Mon, 22 Mar 2021 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616417308;
        bh=2S7shTrdXgAbAswiX69iHuCLt/JFVX0aj60dw13NdAg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HayD+gxFKZXUWksWiDQDhuKrEHRI5ZfW/Mn/Wy6C2OfXWPIgDpWnUxoIyzKk7P6s8
         QCKDM+FkURih5IlMZyVb5iICfMcQe+DkwttnjEORzw0rULehwGwA6G1jQ6pFCuisaE
         q4Kl8P0a7trhVnAYPuejGd14Apnx4zbetzvdwXDG3+1RCyp8MX8+lw+OIgxewY3aeW
         oI0O7v2RhKnI6XP/07nPyffQr41snW6M4fWJ9NX2cjZuWsqWwOUqt3lPuoy0xvSXJF
         QaMQcJhY7FJ3q5wDc/QaY22dtHvhmJxzNZkT1elmXNAYNC9gxPMkRZc4WDHZQSyNP5
         icsHC69pg9Fbg==
Received: by mail-oi1-f170.google.com with SMTP id d12so12888206oiw.12;
        Mon, 22 Mar 2021 05:48:28 -0700 (PDT)
X-Gm-Message-State: AOAM530y3KTvq4sZ0k/eYjBWoraWVF1Q+G0sZnvuhsI3dJoZEEjRx1YK
        JjOHtvDyV7qN7/nKgNdXgfD8S/IbzBvfA5N0bZw=
X-Google-Smtp-Source: ABdhPJz5F00MzQ96za0jlpggff3LSaSqghu8emR3xJCIyvxBoUnXB4xSRkrNzzB5NqfX6oPjswV6je1t5Yb5Ca8u2Ok=
X-Received: by 2002:a05:6808:313:: with SMTP id i19mr9401804oie.67.1616417307794;
 Mon, 22 Mar 2021 05:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210322104343.948660-1-arnd@kernel.org> <YFh3heNXq6mqYqzI@unreal>
 <CAK8P3a3WZmBB=bxNc=taaDwBksLOPVPzhXPAFJ3QCG+eA+Xxww@mail.gmail.com> <YFiIN50pcTnO4X3M@unreal>
In-Reply-To: <YFiIN50pcTnO4X3M@unreal>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 22 Mar 2021 13:48:11 +0100
X-Gmail-Original-Message-ID: <CAK8P3a138jV=5ihmdb5XC+eFzt4Lsz+u3hYWJuKAKSXNHexfOA@mail.gmail.com>
Message-ID: <CAK8P3a138jV=5ihmdb5XC+eFzt4Lsz+u3hYWJuKAKSXNHexfOA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] misdn: avoid -Wempty-body warning
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 1:08 PM Leon Romanovsky <leon@kernel.org> wrote:
> On Mon, Mar 22, 2021 at 12:24:20PM +0100, Arnd Bergmann wrote:
> > On Mon, Mar 22, 2021 at 11:55 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > I don't care either way, I only kept it because it was apparently left there
> > on purpose by the original author, as seen by the comment.
>
> I personally would delete it.

Ok, I sent a second version now, I hope one of them can get applied.

        Arnd
