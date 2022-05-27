Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D86C53570E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 02:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiE0A2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 20:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiE0A2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 20:28:33 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 113736A044;
        Thu, 26 May 2022 17:28:32 -0700 (PDT)
Received: from ip6-localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 24R0GV21032451;
        Thu, 26 May 2022 19:16:32 -0500
Message-ID: <6c5d22c3f3743cf5dfe5eac1d52211942dc2fff8.camel@kernel.crashing.org>
Subject: Re: [PATCH net-next] eth: de4x5: remove support for Generic DECchip
 & DIGITAL EtherWORKS PCI/EISA
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, tsbogend@alpha.franken.de, mpe@ellerman.id.au,
        paulus@samba.org, sburla@marvell.com, vburru@marvell.com,
        aayarekar@marvell.com, arnd@arndb.de, zhangyue1@kylinos.cn,
        linux-doc@vger.kernel.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org
Date:   Fri, 27 May 2022 10:16:30 +1000
In-Reply-To: <alpine.DEB.2.22.394.2205260933520.394690@ramsan.of.borg>
References: <20220519031345.2134401-1-kuba@kernel.org>
         <f84c4cb17eebe385fe22c3fc4563645742269d46.camel@kernel.crashing.org>
         <alpine.DEB.2.22.394.2205260933520.394690@ramsan.of.borg>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-05-26 at 09:43 +0200, Geert Uytterhoeven wrote:
>  	Hi Ben,
> 
> On Sat, 21 May 2022, Benjamin Herrenschmidt wrote:
> > On Wed, 2022-05-18 at 20:13 -0700, Jakub Kicinski wrote:
> > > Looks like almost all changes to this driver had been tree-wide
> > > refactoring since git era begun. There is one commit from Al
> > > 15 years ago which could potentially be fixing a real bug.
> > > 
> > > The driver is using virt_to_bus() and is a real magnet for pointless
> > > cleanups. It seems unlikely to have real users. Let's try to shed
> > > this maintenance burden.
> > > 
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > 
> > Removing this driver will kill support for some rather old PowerMac
> > models (some PowerBooks I think, paulus would know). No objection on my
> > part, though. I doubt people still use these things with new kernels
> > but ... who knows ? :-)
> 
> Aren't these PCI, and thus working fine with the PCI-only DE2104X
> (dc2104x) or TULIP (dc2114x) drivers?
> 
> IIRC, I've initially used the de4x5 driver on Alpha (UDB/Multia) or PPC
> (CHRP), but switched to the TULIP driver later (that was before the
> dc2104x/dc2114x driver split, hence a loooong time ago).

I'm pretty sure there were some old Macs who worked with de4x5 and not
tulip but I wouldn't rememeber the details and I'm not sure any of this
hardware still exist in the field nor matters.

Cheers,
Ben.

