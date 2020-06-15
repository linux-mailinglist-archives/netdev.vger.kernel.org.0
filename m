Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A001E1F9953
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgFONvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbgFONv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 09:51:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CDED2074D;
        Mon, 15 Jun 2020 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592229084;
        bh=dm+rJYETE2p+THng6PDAKnvf2qsLyxCqzLjQQJTi9Ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1nAFk1xg26wYsmRTfJ25DBRSGt/wsjfv9byn2ovJ4uMr7svCupdswYVGJGL52sShk
         4hzSvz+pRvBrkJP01SaES5UWdT0fysKb2lG6Xbk9fc/cLXpyPWz/yJOuYSiRM83iXU
         hmyxVJTv9Sv8b4gKQrZuotl9qH/k4BT6cme6c/80=
Date:   Mon, 15 Jun 2020 15:51:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yehezkel Bernat <yehezkelshb@gmail.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
Message-ID: <20200615135112.GA1402792@kroah.com>
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
 <20200615130139.83854-5-mika.westerberg@linux.intel.com>
 <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 04:45:22PM +0300, Yehezkel Bernat wrote:
> On Mon, Jun 15, 2020 at 4:02 PM Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> >
> > diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
> > index ff397c0d5c07..5db2b11ab085 100644
> > --- a/include/linux/thunderbolt.h
> > +++ b/include/linux/thunderbolt.h
> > @@ -504,8 +504,6 @@ struct tb_ring {
> >  #define RING_FLAG_NO_SUSPEND   BIT(0)
> >  /* Configure the ring to be in frame mode */
> >  #define RING_FLAG_FRAME                BIT(1)
> > -/* Enable end-to-end flow control */
> > -#define RING_FLAG_E2E          BIT(2)
> >
> 
> Isn't it better to keep it (or mark it as reserved) so it'll not cause
> compatibility issues with older versions of the driver or with Windows?


How can you have "older versions of the driver"?  All drivers are in the
kernel tree at the same time, you can't ever mix-and-match drivers and
kernels.

And how does Windows come into play here?

thanks,

greg k-h
