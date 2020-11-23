Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AAD2C188D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgKWWhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:37:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732467AbgKWWhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:37:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A97D206B7;
        Mon, 23 Nov 2020 22:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606171034;
        bh=86BPqIW4lkLZT2JdpPJcJ3aSJ1HvFPGF6MnyB2Lg7K0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gM7WRWnEaJdl3djNzLnL1MeZOpra0LIPgUAUzRjb05mEFB9YZU9Ts1Eojtkek+1wO
         w0MlR0P68EosB19hHZ5A7/bRjM0m45rsrClGvgn7vLW9ZjhZLqvqrqNMkpWTVKzMCM
         BHMWmPe1lc2cZdU/qUPWkxp48/dh63RtihIki8Xc=
Date:   Mon, 23 Nov 2020 14:37:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] net: phy: add support for shared
 interrupts (part 3)
Message-ID: <20201123143713.6429c056@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFBinCBhWKzQFwERW9cy7T4JdOdFwNOqn2qPqFpqdjbat=-DwA@mail.gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
        <CAFBinCBhWKzQFwERW9cy7T4JdOdFwNOqn2qPqFpqdjbat=-DwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 23:13:11 +0100 Martin Blumenstingl wrote:
> > Ioana Ciornei (15):
> >   net: phy: intel-xway: implement generic .handle_interrupt() callback
> >   net: phy: intel-xway: remove the use of .ack_interrupt()
> >   net: phy: icplus: implement generic .handle_interrupt() callback
> >   net: phy: icplus: remove the use .ack_interrupt()
> >   net: phy: meson-gxl: implement generic .handle_interrupt() callback
> >   net: phy: meson-gxl: remove the use of .ack_callback()  
> I will check the six patches above on Saturday (due to me being very
> busy with my daytime job)
> if that's too late for the netdev maintainers then I'm not worried
> about it. at first glance this looks fine to me. and we can always fix
> things afterwards (but still before -rc1).

That is a little long for patches to be hanging around. I was planning
to apply these on Wed. If either Ioana or you would prefer to get the
testing performed first, please split those patches out and repost once
they get validated.
