Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1887714FEDC
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 20:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgBBTWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 14:22:14 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:56892 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgBBTWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 14:22:14 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2020 14:22:13 EST
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23990824AbgBBTMNY3IIg (ORCPT
        <rfc822;kernel-janitors@vger.kernel.org> + 1 other);
        Sun, 2 Feb 2020 20:12:13 +0100
Date:   Sun, 2 Feb 2020 19:12:13 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
cc:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] defxx: Fix a sentinel at the end of a 'eisa_device_id'
 structure
In-Reply-To: <20200202142341.22124-1-christophe.jaillet@wanadoo.fr>
Message-ID: <alpine.LFD.2.21.2002021858330.683661@eddie.linux-mips.org>
References: <20200202142341.22124-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020, Christophe JAILLET wrote:

> 'struct eisa_device_id' must be ended by an empty string, not a NULL
> pointer. Otherwise, a NULL pointer dereference may occur in
> 'eisa_bus_match()'.

 Umm, that's weird code there in `eisa_bus_match' (I do hope at least GCC 
optimises the `strlen' away nowadays and checks for the character pointed 
being null instead), but as usually with old stuff let's keep changes to 
the minimum.  So:

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Thanks for the fix!

  Maciej
