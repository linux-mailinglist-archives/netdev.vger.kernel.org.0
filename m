Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5AC432D96
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 07:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhJSGB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhJSGB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 02:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A9FA6115B;
        Tue, 19 Oct 2021 05:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634623185;
        bh=FRG4beuFMc1+FdpIgLOkG3rFrbUvdGSYdFRG5EBVUp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t5cPxWcbk5thS6ojbahUasVg3cpLKhCx8hgqiHEHBcHCFhYZGDz3PzTkyV56PThx8
         C3gRfb/7GiSnBsCQ4+thbCL6jeTWi4Td8oTrT13oEoJE+gNhshpz5odbSJ+vtUo1zC
         8x+r/FO7nNsSeNyYjEDbeWzYrpmc2Jidcs+Yajmo=
Date:   Tue, 19 Oct 2021 07:59:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mt7530: correct ds->num_ports
Message-ID: <YW5ez/PySlH8WsGk@kroah.com>
References: <20211016062414.783863-1-dqfext@gmail.com>
 <cd6a03b9-af49-97b4-6869-d51b461bf50a@gmail.com>
 <20211018084230.6710-1-dqfext@gmail.com>
 <7b5e5fcf-8e7f-45ec-de3f-57b3da77b479@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b5e5fcf-8e7f-45ec-de3f-57b3da77b479@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 09:22:49AM -0700, Florian Fainelli wrote:
> On 10/18/21 1:42 AM, DENG Qingfang wrote:
> > On Sat, Oct 16, 2021 at 07:36:14PM -0700, Florian Fainelli wrote:
> >> On 10/15/2021 11:24 PM, DENG Qingfang wrote:
> >>> Setting ds->num_ports to DSA_MAX_PORTS made DSA core allocate unnecessary
> >>> dsa_port's and call mt7530_port_disable for non-existent ports.
> >>>
> >>> Set it to MT7530_NUM_PORTS to fix that, and dsa_is_user_port check in
> >>> port_enable/disable is no longer required.
> >>>
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> >>
> >> Do you really want to target the net tree for this change?
> > 
> > Yes because I consider this a bug fix.
> 
> 
> OK, why not provide a Fixes tag to help with targeting the back port
> then? This has been applied anyway, so hopefully the auto selection will
> do its job and tell you where it stops applying cleanly.

Without a "Fixes:" tag, I just backport things as far are they are easy
to go and then stop without an email saying anything fails on older
kernels.

thanks,

greg k-h
