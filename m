Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471A51DC3ED
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgEUAhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgEUAhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:02 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BCFC061A0E;
        Wed, 20 May 2020 17:37:02 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZCj-00CgbV-JM; Thu, 21 May 2020 00:36:57 +0000
Date:   Thu, 21 May 2020 01:36:57 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHES] uaccess-related stuff in net/*
Message-ID: <20200521003657.GE23230@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
 <20200511.170251.223893682017560321.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511.170251.223893682017560321.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:02:51PM -0700, David Miller wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Mon, 11 May 2020 05:43:28 +0100
> 
> > 	Assorted uaccess-related work in net/*.  First, there's
> > getting rid of compat_alloc_user_space() mess in MCAST_...
> > [gs]etsockopt() - no need to play with copying to/from temporary
> > object on userland stack, etc., when ->compat_[sg]etsockopt()
> > instances in question can easly do everything without that.
> > That's the first 13 patches.  Then there's a trivial bit in
> > net/batman-adv (completely unrelated to everything else) and
> > finally getting the atm compat ioctls into simpler shape.
> > 
> > 	Please, review and comment.  Individual patches in followups,
> > the entire branch (on top of current net/master) is in
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #uaccess.net
> 
> I have no problems with this series:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

OK, rebased on top of current net/master (no conflicts) and pushed out
to the same branch.  Patches (for net-next) in followups
