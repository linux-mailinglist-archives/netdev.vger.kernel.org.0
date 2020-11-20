Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D61E2BB23D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgKTSOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgKTSOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:14:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7E32242B;
        Fri, 20 Nov 2020 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896075;
        bh=21rM71HDeEaKk2NCHy6OetPpdA9Z8GOwAR3baMEK46k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QHAz2na35HD5MBECYFccv0stGqqzPv7Jy/MoDyQHlZYTZoBBg+rfTOsRbECXcdpQx
         f+sPLG2qxvNvNn53OiGB/0UtUFPSceFeBeILkmgIvrOauewLz1P3GoW3khS84aqGoo
         24CrfKlde0mJclH7S0sekKK+bYmeVY4ma11mSEi0=
Date:   Fri, 20 Nov 2020 10:14:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, brouer@redhat.com
Subject: Re: [PATCH net-next] net: netsec: add xdp tx return bulking support
Message-ID: <20201120101434.3f91005a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120180713.GA801643@apalos.home>
References: <01487b8f5167d62649339469cdd0c6d8df885902.1605605531.git.lorenzo@kernel.org>
        <20201120100007.5b138d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201120180713.GA801643@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 20:07:13 +0200 Ilias Apalodimas wrote:
> On Fri, Nov 20, 2020 at 10:00:07AM -0800, Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 10:35:28 +0100 Lorenzo Bianconi wrote:  
> > > Convert netsec driver to xdp_return_frame_bulk APIs.
> > > Rely on xdp_return_frame_rx_napi for XDP_TX in order to try to recycle
> > > the page in the "in-irq" page_pool cache.
> > > 
> > > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > > This patch is just compile tested, I have not carried out any run test  
> > 
> > Doesn't look like anyone will test this so applied, thanks!  
> 
> I had everything applied trying to test, but there was an issue with the PHY the
> socionext board uses [1].

FWIW feel free to send a note saying you need more time.

> In any case the patch looks correct, so you can keep it and I'll report any 
> problems once I short the box out.

Cool, fingers crossed :)
