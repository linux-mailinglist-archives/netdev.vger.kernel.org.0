Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EFF1A840C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391226AbgDNQAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:00:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:43542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387552AbgDNQAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 12:00:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 90120ABCE;
        Tue, 14 Apr 2020 16:00:42 +0000 (UTC)
Date:   Tue, 14 Apr 2020 18:00:41 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Pensando Drivers <drivers@pensando.io>,
        Sebastian Reichel <sre@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next 1/4] drivers: Remove inclusion of vermagic header
Message-ID: <20200414160041.GG31763@zn.tnic>
References: <20200414155732.1236944-1-leon@kernel.org>
 <20200414155732.1236944-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200414155732.1236944-2-leon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 06:57:29PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Get rid of linux/vermagic.h includes, so that MODULE_ARCH_VERMAGIC from
> the arch header arch/x86/include/asm/module.h won't be redefined.
> 
>   In file included from ./include/linux/module.h:30,
>                    from drivers/net/ethernet/3com/3c515.c:56:
>   ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC"
> redefined
>      73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
>         |
>   In file included from drivers/net/ethernet/3com/3c515.c:25:
>   ./include/linux/vermagic.h:28: note: this is the location of the
> previous definition
>      28 | #define MODULE_ARCH_VERMAGIC ""
>         |
> 
> Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
> Signed-off-by: Borislav Petkov <bp@suse.de>

Just my SOB like that doesn't mean anything. You should add

Co-developed-by: me
Signed-off-by: me

if you want to state that we both worked on this fix.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
