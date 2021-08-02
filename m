Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0995C3DE0E7
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhHBUod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhHBUoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5555E610FB;
        Mon,  2 Aug 2021 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627937062;
        bh=Cgk3kYA9A8Fe0MkJ3IArEFUyV3QWUPaplz9QppWpzYc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PoGIkpksbdNTqmas5Ju8aLUJUHE2VXnHVa8u0mLqoN2DJk32IUxefe6dYWeC/czzZ
         kds8iS3SIy0lik0i1pUxupuF7uje/QNepPI9/UFJAJjchXS1Hg423x+rwi3487vWSw
         BJTT4dGKGpW9AlIortl1ak1nLqlUcQbTWufkoQit7/u5ZnKjdNubBDwlMncwaj+HRX
         FrWYWp9QTyBy5pRggPCjnBX/h9tFlSrIYYxgZ61cna6Xrxvg/vHo75Q/dwQYwDHpdw
         f2wVjfy09ZhICzUtLky+KzPMfwXxeUf6tgYycrXcTXcGVlPDIYyCrvOhkoS7kzoPjr
         vBvFbf14YhhAw==
Received: by mail-wm1-f49.google.com with SMTP id e25-20020a05600c4b99b0290253418ba0fbso759861wmp.1;
        Mon, 02 Aug 2021 13:44:22 -0700 (PDT)
X-Gm-Message-State: AOAM532QX1RqqZRHbS9PBi70boEuo8EoLD/dOOjqJpiBCRfN1/rSF8F0
        Prhwp3vzuDy/EOBq5ECFI8w1F4UOvYXqPeqjJ9s=
X-Google-Smtp-Source: ABdhPJzZliXA2hOgIqx700o9V8Zjjcs/EHxx3DVnpQyQ9Oc9/nINX0q75mxOl4QwBPmPGWMbtCwoCU+xWqGb4ZMl1gQ=
X-Received: by 2002:a05:600c:3b08:: with SMTP id m8mr712652wms.84.1627937061005;
 Mon, 02 Aug 2021 13:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210802144813.1152762-1-arnd@kernel.org> <20210802162250.GA12345@corigine.com>
 <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
 <20210802190459.ruhfa23xcoqg2vj6@skbuf> <CAK8P3a1sT+bJitQH6B5=+bnKzn-LMJX1LnQtGTBptuDG-co94g@mail.gmail.com>
 <20210802202047.sqc6yef75dcoowuc@skbuf>
In-Reply-To: <20210802202047.sqc6yef75dcoowuc@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 22:44:04 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0hLcNvR0Td1fpu6N0r1Hb7uSq0HPKkF30uCANuDg-SrQ@mail.gmail.com>
Message-ID: <CAK8P3a0hLcNvR0Td1fpu6N0r1Hb7uSq0HPKkF30uCANuDg-SrQ@mail.gmail.com>
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 10:21 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Mon, Aug 02, 2021 at 09:55:20PM +0200, Arnd Bergmann wrote:
> > On Mon, Aug 2, 2021 at 9:05 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > >
> > > On Mon, Aug 02, 2021 at 08:29:25PM +0200, Arnd Bergmann wrote:
> > > > If this looks correct to you, I can submit it as a standalone patch.
> > >
> > > I think it's easiest I just ask you to provide a .config that triggers
> > > actual build failures and we can go from there.
> >
> > This one is with an arm64 allmodconfig, plus
> >
> > CONFIG_PTP_1588_CLOCK=y
> > CONFIG_TI_K3_AM65_CPTS=y
> > CONFIG_TI_K3_AM65_CPSW_NUSS=y
>
> Yeah, ok, I remember now, I saw that TI_CPSW_SWITCHDEV is tristate, and
> incorrectly thought that TI_K3_AM65_CPSW_SWITCHDEV (which is mostly a
> copy-paste job of the main cpsw anyway, makes you cringe that they wrote
> a separate driver for it) is tristate too.

Right.

> The options are either to make TI_K3_AM65_CPSW_SWITCHDEV tristate like
> TI_CPSW_SWITCHDEV is, and to edit the Makefile accordingly to make
> am65-cpsw-switchdev.o part of obj-$(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV),

This probably won't work as this is currently part of the ti-am65-cpsw-nuss.ko
module, so I would assume that it's not easy to separate from the main module.

> or to extend the BRIDGE || BRIDGE=n dependency to TI_K3_AM65_CPSW_NUSS
> which is the direct tristate dependency of CONFIG_TI_K3_AM65_CPSW_SWITCHDEV,

That would work, but it's slightly more heavy-handed than my proposal, as this
prevents TI_K3_AM65_CPSW_NUSS from being built-in when BRIDGE is a module,
even when switchdev support is completely disabled.

> and to make CONFIG_TI_K3_AM65_CPSW_SWITCHDEV simply depend on BRIDGE.

This would not be needed then I think.

       Arnd
