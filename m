Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6883F980D
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 12:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244959AbhH0KUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 06:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244708AbhH0KUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 06:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2510060F4F;
        Fri, 27 Aug 2021 10:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630059567;
        bh=EOO6pKRRm3/g0M0RTzHPyA5sIKLS/eIq5VJThmOrCEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tSWxtIl/NPkTQ+WN8KhkK2/CGY68e9SPzcz96GYq8DQDLZj+lR6JyJOm5lERl4GRf
         jAfeQbjuo/OQ/PZWP8pPTuxkcUqcArquIRHzcRRhB95mtj9pphex7YpebmAVaIvN4Z
         NQVgSZvHUzrTPuPHX/PExgvqfsFYW+73WX1C4eSE=
Date:   Fri, 27 Aug 2021 12:19:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 4.19.y] net: dsa: mt7530: disable learning on standalone
 ports
Message-ID: <YSi8Ky3GqBjnxbhC@kroah.com>
References: <20210824055509.1316124-1-dqfext@gmail.com>
 <YSUQV3jhfbhbf5Ct@sashalap>
 <CALW65ja3hYGmEqcWZzifP2-0WsJOnxcUXsey2ZH5vDbD0-nDeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65ja3hYGmEqcWZzifP2-0WsJOnxcUXsey2ZH5vDbD0-nDeQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 11:57:53PM +0800, DENG Qingfang wrote:
> Hi Sasha,
> 
> On Tue, Aug 24, 2021 at 11:29 PM Sasha Levin <sashal@kernel.org> wrote:
> > What's the reasoning behind:
> >
> > 1. Backporting this patch?
> 
> Standalone ports should have address learning disabled, according to
> the documentation:
> https://www.kernel.org/doc/html/v5.14-rc7/networking/dsa/dsa.html#bridge-layer
> dsa_switch_ops on 5.10 or earlier does not have .port_bridge_flags
> function so it has to be done differently.
> 
> I've identified an issue related to this.

What issue is that?  Where was it reported?

> > 2. A partial backport of this patch?
> 
> The other part does not actually fix anything.

Then why is it not ok to just take the whole thing?

When backporting not-identical-patches, something almost always goes
wrong, so we prefer to take the original commit when ever possible.

thanks,

greg k-h
