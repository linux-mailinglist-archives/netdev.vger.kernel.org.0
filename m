Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63174312D68
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhBHJhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:37:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhBHJfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 04:35:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B20B64E66;
        Mon,  8 Feb 2021 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612776909;
        bh=8B+pPzUyC0j31/K6l7qwKVtJSVDw1LRM22RGqVGBjZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pg11XyEbPjP6BlcLDwkX63F8VG+uGf9mpqjMsfufzyUfHKrFfETh/whfstLtTI71n
         pksNqySfj4N9CRyNHfKT0GHS2wMVYX0DXlt0eBeFzpRfu9z4D3JX1iqrMpRLHElu+6
         ZyX11U91EvcGG+IuRCM9Z2sJx2y7SDJFoJ94eo0MwWciwyGali3maa7pRwnYJ+dWe3
         PnKzU1wb5WHXLvLGueKxRG2V5xtMua3dEqFvMgk8eaXDoT7F8dGGlA+J+z6ZonXVtz
         uemONB3z6xiBP7JDPUIOFHQ9o+55t82V2S2Lnc51BH3qy1BfpWsbCCRLIKOrwrzK/R
         40r4u1PURk01Q==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l92x2-00050L-EI; Mon, 08 Feb 2021 10:35:24 +0100
Date:   Mon, 8 Feb 2021 10:35:24 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: support ZTE P685M modem
Message-ID: <YCEF3MY5Mau9TPvK@hovoldconsulting.com>
References: <20210205173904.13916-1-lech.perczak@gmail.com>
 <20210205173904.13916-2-lech.perczak@gmail.com>
 <87r1lt1do6.fsf@miraculix.mork.no>
 <0264f3a2-d974-c405-fb08-18e5ca21bf76@gmail.com>
 <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 06, 2021 at 12:13:22PM -0800, Jakub Kicinski wrote:
> On Sat, 6 Feb 2021 15:50:41 +0100 Lech Perczak wrote:
> > >> Cc: Bjørn Mork<bjorn@mork.no>
> > >> Signed-off-by: Lech Perczak<lech.perczak@gmail.com>  
> > > Patch looks fine to me.  But I don't think you can submit a net and usb
> > > serial patch in a series. These are two different subsystems.
> > >
> > > There's no dependency between the patches so you can just submit
> > > them as standalone patches.  I.e. no series.  
> > Actually, there is, and I just noticed, that patches are in wrong order.
> > Without patch 2/2 for 'option' driver, there is possibility for that 
> > driver to steal
> > interface 3 from qmi_wwan, as currently it will match interface 3 as 
> > ff/ff/ff.
> > 
> > With that in mind I'm not really sure how to proceed.
> > 
> > What comes to my mind, is either submit this as series again, with 
> > ordering swapped,
> > or submit 2/2 first, wait for it to become merged, and then submit 1/2.
> 
> Send patch 2, wait for it to hit net, send 1 seems like the safest
> option. If we're lucky Johan can still send patch 2 for 5.11, otherwise
> we'll wait until the merge window - we're at rc7 already, it won't take
> too long.

I usually don't send on new device-ids this late in the release cycle,
so I'll queue the USB-serial one up for 5.12-rc1 and you can take this
one through net-next.

Johan
