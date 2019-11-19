Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548231024F0
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfKSM4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:56:06 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51292 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKSM4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 07:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5f3hO40o8E0ou44KZtutiWU9jMQ3vbidV5Vq7PRDxcc=; b=KtzWLwv0GlYVgZMSVI3jv79i7
        9Uk62coq/HtS86NFKihmrPLH/q4wjxKWRY+638D81wAFh5g/Ym/Z0oiP34ppLi2w7k4536ynSDsQI
        vBgbD6UYevDBqtnfPivEu+PkGrUkJR/i/wTbpUD6E/3ChpLJCMpvXr8JU4nuGnwgATRuUKzc4XRQf
        +37FYM11D10lHs5Kvlvf6YQzgOf2aHtkXplDKJS/9IlggFltWM38zoyhzsmIKuQWTq+tWBVC+ghID
        m7yIx8rL4P6/dKwclF4Q+FCL4w14yHhHcRpf1fnCac3wNK4z9hauTkDDkgX1j1b15olpngTBb34c2
        YpLw+Hfzw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58300)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iX331-0001PS-OW; Tue, 19 Nov 2019 12:55:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iX32z-0000jx-5f; Tue, 19 Nov 2019 12:55:57 +0000
Date:   Tue, 19 Nov 2019 12:55:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     John Crispin <john@phrozen.org>, nbd@nbd.name
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Subject: Re: Felix Fietkau email address become stale?
Message-ID: <20191119125556.GD25745@shell.armlinux.org.uk>
References: <20191119124506.GC25745@shell.armlinux.org.uk>
 <cad7ea93-8aad-6bfa-c1c3-9932c5a87699@phrozen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cad7ea93-8aad-6bfa-c1c3-9932c5a87699@phrozen.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 01:46:58PM +0100, John Crispin wrote:
> On 19/11/2019 13:45, Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> >    nbd@openwrt.org
> >      host util-01.infra.openwrt.org [2a03:b0c0:3:d0::175a:2001]
> >      SMTP error from remote mail server after RCPT TO:<nbd@openwrt.org>:
> >      550 Unrouteable address
> > 
> > which was triggered due to MAINTAINERS saying:
> > 
> > MEDIATEK ETHERNET DRIVER
> > M:      Felix Fietkau <nbd@openwrt.org>
> > M:      John Crispin <john@phrozen.org>
> > M:      Sean Wang <sean.wang@mediatek.com>
> > M:      Mark Lee <Mark-MC.Lee@mediatek.com>
> > 
> > Does Felix's address need updating or removing?
> > 
> 
> all @openwrt.org emails became stale during the owrt/lede remerge. please
> use nbd@nbd.name

Thanks, but please consider my message a merely curtesy pointing out
the problem.  I've already sent out the patch and re-sending it to
all the recipients just because one person's email address is stale
is not reasonable.

MAINTAINERS and .mailcap need to be updated if Felix still wishes to
receive patches, and from what you're saying, the same goes for the
other openwrt.org email addresses therein.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
