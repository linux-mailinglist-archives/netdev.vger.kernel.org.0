Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708CD3DDC42
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhHBPWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234603AbhHBPWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3410F6113C;
        Mon,  2 Aug 2021 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627917729;
        bh=Si+hNK3DPr4uxf50uAtqbl4TH36wPrm2fxzPPe4dfhs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eNUmLo6PsdKJ5G1xJKUYiOV2A1gLj2NKX9BQA95QquPsSfLWb+d9sUD8ETLB6HaZ5
         UZZLXApvJYba7yDgda2DgUksM5j/KsPY5YU0LhKF1xN+b+8087BEmIMPdv32ngmsFG
         +LQjLqX3jX9UxpmdTHfNoPHPyJtBtuVPkk9fcyv/3uAvpf4NVHlpSpRA4Sv4NsZLEJ
         Vqqa+ncgQNdF3x8KWxXnZo90PeqdE5U54M/kWjRcE4QgofHe5pcdb5ulBRzjQguJDG
         qlwZi7328/8S0GfZM/9ZKsloe65RcYA2Q0xHZzcO6SFEJqY8gzOl80qPQfPkEr5vnh
         2H1se8x88eRZw==
Received: by mail-wr1-f47.google.com with SMTP id z4so21946496wrv.11;
        Mon, 02 Aug 2021 08:22:09 -0700 (PDT)
X-Gm-Message-State: AOAM533BQ23+BeWLbHwS0EK04Uf/cZENSEEdnOj1UXgKabk9Zih5FzHx
        fBXW6PkgNfYhSoLjPjmhjeDSbK2iwY5z01ECBZI=
X-Google-Smtp-Source: ABdhPJwo4NvX+dVJZBjSmdvIvz0RTbMiP/jqK0tWRgClan8YxDoQgFzXHr9ZWQZo4WaHXaYWjvrz7hImrkZvk68+afs=
X-Received: by 2002:adf:fd90:: with SMTP id d16mr19227020wrr.105.1627917727845;
 Mon, 02 Aug 2021 08:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145449.1154565-1-arnd@kernel.org> <20210802080205.6a9f9bb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802080205.6a9f9bb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 17:21:52 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0-z+_bsVVjy5h+f=O27BfUjBOFJ1-18aQOmUwf4rZTKg@mail.gmail.com>
Message-ID: <CAK8P3a0-z+_bsVVjy5h+f=O27BfUjBOFJ1-18aQOmUwf4rZTKg@mail.gmail.com>
Subject: Re: [PATCH] net: sparx5: fix bitmask check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 5:02 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> I fixed this by moving the check out to a macro wrapper in net:
> 6387f65e2acb ("net: sparx5: fix compiletime_assert for GCC 4.9")

Ok, got it.

> > To make this also work on 32-bit architectures, change
> > the GENMASK() to GENMASK_ULL().
>
> Would you mind resending just that part against net/master?

Done.

        Arnd
