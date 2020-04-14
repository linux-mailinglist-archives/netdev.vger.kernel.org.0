Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E96B1A877A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407696AbgDNR0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407592AbgDNR0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 13:26:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F7CD20678;
        Tue, 14 Apr 2020 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586885168;
        bh=CKkX3MgesuAwohWkS7pjImbdHGheMoo/wULg1HdG650=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H83AFXS7TXgE23cvCAv0Xb81HXp31vYAtMjDgOVJjOxH/8EyyWZ4PLcmUFDYojigR
         x3DQTB2eV8wPyB50yUQr4IOMpChJr1PT/g1VxmpKUrrs8pL0ZigVeO6bDMEYv/PpiP
         2XG0KiLtc0w2WGWnJR1qZOwrFkQcrV5THe9VEdfo=
Date:   Tue, 14 Apr 2020 20:26:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Pensando Drivers <drivers@pensando.io>,
        Sebastian Reichel <sre@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next 1/4] drivers: Remove inclusion of vermagic header
Message-ID: <20200414172604.GD1011271@unreal>
References: <20200414155732.1236944-1-leon@kernel.org>
 <20200414155732.1236944-2-leon@kernel.org>
 <20200414160041.GG31763@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200414160041.GG31763@zn.tnic>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 06:00:41PM +0200, Borislav Petkov wrote:
> On Tue, Apr 14, 2020 at 06:57:29PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Get rid of linux/vermagic.h includes, so that MODULE_ARCH_VERMAGIC from
> > the arch header arch/x86/include/asm/module.h won't be redefined.
> >
> >   In file included from ./include/linux/module.h:30,
> >                    from drivers/net/ethernet/3com/3c515.c:56:
> >   ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC"
> > redefined
> >      73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
> >         |
> >   In file included from drivers/net/ethernet/3com/3c515.c:25:
> >   ./include/linux/vermagic.h:28: note: this is the location of the
> > previous definition
> >      28 | #define MODULE_ARCH_VERMAGIC ""
> >         |
> >
> > Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
> > Signed-off-by: Borislav Petkov <bp@suse.de>
>
> Just my SOB like that doesn't mean anything. You should add
>
> Co-developed-by: me
> Signed-off-by: me
>
> if you want to state that we both worked on this fix.

I personally don't use such notation and rely on the submission flow.

The patch has two authors both written in SOBs and it will be visible
in the git history that those SOBs are not maintainers additions.

Can you please reply to the original patch with extra tags you want,
so b4 and patchworks will pick them without me resending the patches?

Thanks

>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
