Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3AD314EBA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 13:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhBIMLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 07:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhBIMJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 07:09:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDA9064E70;
        Tue,  9 Feb 2021 12:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612872547;
        bh=CHvlJV5Q0h5SY57YOjfJm1Xhm3tCvuSTYU+HcJ628rA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ST/Q742REels84VamIKp6Zm870qgtcIONn5+U7bUB9LTux7bgBGUkdIBzJennLijj
         X2e8Ak6JkjYRhIpjH6Jpn1cRMHk1tFz5DpuHpsI7p3Yy3OODT/IOGPq7JctaA8dEY1
         HX2HQPcE/xHYVq0W91576O55QlqHQ71avyVPNXcSzvpNXfUCdcYxcfGelpcC9FnW9a
         Yg0MKj3rQr17dMTl7mPfdmgD6H53GMT4I4MRIA4L9Fj3SPTqX6ktz2BthSf9s9LqAq
         DUSRj8n1QhCdSSfC04adZB5l4+gVFPUg6xLLrSzso8r6NNKJxng8Rq+Z39fvpaUgmw
         c9PyaEES99yNA==
Received: from johan by xi with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l9RpY-00024W-87; Tue, 09 Feb 2021 13:09:20 +0100
Date:   Tue, 9 Feb 2021 13:09:20 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: support ZTE P685M modem
Message-ID: <YCJ7cPzH2rM9+Xhu@hovoldconsulting.com>
References: <20210205173904.13916-1-lech.perczak@gmail.com>
 <20210205173904.13916-2-lech.perczak@gmail.com>
 <87r1lt1do6.fsf@miraculix.mork.no>
 <0264f3a2-d974-c405-fb08-18e5ca21bf76@gmail.com>
 <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YCEF3MY5Mau9TPvK@hovoldconsulting.com>
 <20210208095252.51c0a738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208095252.51c0a738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 09:52:52AM -0800, Jakub Kicinski wrote:
> On Mon, 8 Feb 2021 10:35:24 +0100 Johan Hovold wrote:
> > > Send patch 2, wait for it to hit net, send 1 seems like the safest
> > > option. If we're lucky Johan can still send patch 2 for 5.11, otherwise
> > > we'll wait until the merge window - we're at rc7 already, it won't take
> > > too long.  
> > 
> > I usually don't send on new device-ids this late in the release cycle,
> > so I'll queue the USB-serial one up for 5.12-rc1 and you can take this
> > one through net-next.
> 
> s/net-next/net/  Sound like a plan, thanks!

I did mean net-next so that both would end up in -rc1 and allowing you
to apply it straight away, but either works. :)

While there is a dependency of sort here, it's not the end of the world
if the networking one goes in before the USB-serial one; the serial
driver might just continue to claim those ports a while longer in some
setups (depending on probe order).

Johan
