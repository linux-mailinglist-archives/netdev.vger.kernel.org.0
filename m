Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A821564A58
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 18:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfGJQBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 12:01:34 -0400
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:56551 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726333AbfGJQBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 12:01:33 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id A05E28368EF4;
        Wed, 10 Jul 2019 16:01:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: balls52_46dfd74d6cd5c
X-Filterd-Recvd-Size: 2713
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jul 2019 16:01:26 +0000 (UTC)
Message-ID: <c94a0a50c41c7530354b4a662ee945212424c8c7.camel@perches.com>
Subject: Re: [PATCH 00/12] treewide: Fix GENMASK misuses
From:   Joe Perches <joe@perches.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date:   Wed, 10 Jul 2019 09:01:25 -0700
In-Reply-To: <b9c3b83c9be50286062ae8cefd5d38e2baa0fb22.camel@perches.com>
References: <cover.1562734889.git.joe@perches.com>
         <5fa1fa6998332642c49e2d5209193ffe2713f333.camel@sipsolutions.net>
         <20190710094337.wf2lftxzfjq2etro@shell.armlinux.org.uk>
         <b9c3b83c9be50286062ae8cefd5d38e2baa0fb22.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-10 at 08:45 -0700, Joe Perches wrote:
> On Wed, 2019-07-10 at 10:43 +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Jul 10, 2019 at 11:17:31AM +0200, Johannes Berg wrote:
> > > On Tue, 2019-07-09 at 22:04 -0700, Joe Perches wrote:
> > > > These GENMASK uses are inverted argument order and the
> > > > actual masks produced are incorrect.  Fix them.
> > > > 
> > > > Add checkpatch tests to help avoid more misuses too.
> > > > 
> > > > Joe Perches (12):
> > > >   checkpatch: Add GENMASK tests
> > > 
> > > IMHO this doesn't make a lot of sense as a checkpatch test - just throw
> > > in a BUILD_BUG_ON()?
> 
> I tried that.
> 
> It'd can't be done as it's used in declarations
> and included in asm files and it uses the UL()
> macro.
> 
> I also tried just making it do the right thing
> whatever the argument order.

I forgot.

I also made all those arguments when it was
introduced in 2013.

https://lore.kernel.org/patchwork/patch/414248/

> Oh well.

yeah.


