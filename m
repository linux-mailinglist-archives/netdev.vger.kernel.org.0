Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680D234BFFD
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 01:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhC1X4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 19:56:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53332 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231600AbhC1X4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 19:56:34 -0400
X-Greylist: delayed 135489 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Mar 2021 19:56:34 EDT
Date:   Mon, 29 Mar 2021 00:56:25 +0100
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] ia64: tools: add generic errno.h definition
Message-ID: <20210329005625.416d2903@sf>
In-Reply-To: <YF8GapSa+3zU3fqM@sf>
References: <20210312075136.2037915-1-slyfox@gentoo.org>
        <YF8GapSa+3zU3fqM@sf>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Mar 2021 10:18:18 +0000
Sergei Trofimovich <slyfox@gentoo.org> wrote:

> On Fri, Mar 12, 2021 at 07:51:35AM +0000, Sergei Trofimovich wrote:
> > Noticed missing header when build bpfilter helper:
> > 
> >     CC [U]  net/bpfilter/main.o
> >   In file included from /usr/include/linux/errno.h:1,
> >                    from /usr/include/bits/errno.h:26,
> >                    from /usr/include/errno.h:28,
> >                    from net/bpfilter/main.c:4:
> >   tools/include/uapi/asm/errno.h:13:10: fatal error:
> >     ../../../arch/ia64/include/uapi/asm/errno.h: No such file or directory
> >      13 | #include "../../../arch/ia64/include/uapi/asm/errno.h"
> >         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > CC: linux-kernel@vger.kernel.org
> > CC: netdev@vger.kernel.org
> > CC: bpf@vger.kernel.org
> > Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>  
> 
> Any chance to pick it up?

Alternative (and nicer) patch is queued in -mm as:
    https://www.ozlabs.org/~akpm/mmotm/broken-out/ia64-tools-remove-inclusion-of-ia64-specific-version-of-errnoh-header.patch

-- 

  Sergei
