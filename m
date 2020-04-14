Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36DD1A7A1F
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439653AbgDNLw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:52:57 -0400
Received: from elvis.franken.de ([193.175.24.41]:38462 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbgDNLwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 07:52:55 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jOK7V-0002BV-00; Tue, 14 Apr 2020 13:52:49 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 68F61C0108; Tue, 14 Apr 2020 13:52:35 +0200 (CEST)
Date:   Tue, 14 Apr 2020 13:52:35 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        geert@linux-m68k.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] vhost: do not enable VHOST_MENU by default
Message-ID: <20200414115235.GA13675@alpha.franken.de>
References: <20200414024438.19103-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414024438.19103-1-jasowang@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 10:44:38AM +0800, Jason Wang wrote:
> We try to keep the defconfig untouched after decoupling CONFIG_VHOST
> out of CONFIG_VIRTUALIZATION in commit 20c384f1ea1a
> ("vhost: refine vhost and vringh kconfig") by enabling VHOST_MENU by
> default. Then the defconfigs can keep enabling CONFIG_VHOST_NET
> without the caring of CONFIG_VHOST.
> 
> But this will leave a "CONFIG_VHOST_MENU=y" in all defconfigs and even
> for the ones that doesn't want vhost. So it actually shifts the
> burdens to the maintainers of all other to add "CONFIG_VHOST_MENU is
> not set". So this patch tries to enable CONFIG_VHOST explicitly in
> defconfigs that enables CONFIG_VHOST_NET and CONFIG_VHOST_VSOCK.
> 
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/mips/configs/malta_kvm_defconfig  |  1 +

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
