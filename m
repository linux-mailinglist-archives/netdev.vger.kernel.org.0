Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCED2EC20F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbhAFRYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:24:55 -0500
Received: from mrdf004.ocn.ad.jp ([125.206.160.152]:38233 "EHLO
        mrdf004.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFRYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:24:54 -0500
X-Greylist: delayed 4742 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 12:24:52 EST
Received: from mogw6101.ocn.ad.jp (mogw6101.ocn.ad.jp [210.163.236.2])
        by mrdf004.ocn.ad.jp (Postfix) with ESMTP id 639463801B0;
        Thu,  7 Jan 2021 01:04:34 +0900 (JST)
Received: from mf-smf-unw009c1.ocn.ad.jp (mf-smf-unw009c1.ocn.ad.jp [153.138.219.105])
        by mogw6101.ocn.ad.jp (Postfix) with ESMTP id 8CCA81E002A;
        Thu,  7 Jan 2021 01:03:15 +0900 (JST)
Received: from ocn-vc-mts-202c1.ocn.ad.jp ([153.138.219.215])
        by mf-smf-unw009c1.ocn.ad.jp with ESMTP
        id xBBQkW5DGUrLKxBHHke1vh; Thu, 07 Jan 2021 01:03:15 +0900
Received: from smtp.ocn.ne.jp ([153.149.227.167])
        by ocn-vc-mts-202c1.ocn.ad.jp with ESMTP
        id xBHGk2ikJIfvlxBHGkV6m2; Thu, 07 Jan 2021 01:03:15 +0900
Received: from localhost (p1601136-ipoe.ipoe.ocn.ne.jp [114.172.254.135])
        by smtp.ocn.ne.jp (Postfix) with ESMTPA;
        Thu,  7 Jan 2021 01:03:14 +0900 (JST)
Date:   Thu, 07 Jan 2021 01:03:14 +0900 (JST)
Message-Id: <20210107.010314.1817045693815939591.anemo@mba.ocn.ne.jp>
To:     geert@linux-m68k.org
Cc:     tsbogend@alpha.franken.de, mpm@selenic.com,
        herbert@gondor.apana.org.au, dan.j.williams@intel.com,
        vkoul@kernel.org, davem@davemloft.net, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, kuba@kernel.org,
        a.zummo@towertech.it, alexandre.belloni@bootlin.com,
        broonie@kernel.org, wim@linux-watchdog.org, linux@roeck-us.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-watchdog@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/10] Remove support for TX49xx
From:   Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
        <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com>
X-Mailer: Mew version 6.7 on Emacs 24.5 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert!

On Wed, 6 Jan 2021 09:37:11 +0100, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Thomas,
> 
> CC Nemoto-san (de-facto TX49XX maintainer)
> 
> On Tue, Jan 5, 2021 at 3:03 PM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
>> I couldn't find any buyable product other than reference boards using
>> TX49xx CPUs. And since nobody showed interest in keeping support for
>> it, it's time to remove it.
> 
> I have an RBTX4927 development board in my board farm, boot-test every
> bi-weekly renesas-drivers release on it, and fix kernel issues when they
> appear.
> 
> Is that sufficient to keep it?

It have been about 10 years since last time I see any TX49 board :-)

AFAIK Geert is the last user of TX49 SoC.
I'm OK with whole TX49xx (and TX39xx) removal if Geert (or any other
users) agreed.

---
Atsushi Nemoto
