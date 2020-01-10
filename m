Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07B7136DD9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgAJNWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:22:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbgAJNWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 08:22:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=scty6nlet1Qt587QiOyjcj8Is/eqei5BaRBqC5RZh2E=; b=bRqIQ9aYAMzhIJGn4XxGRzzK2n
        HWrfrJ5qWKVTsnZF/0T87BBzpB6c6lJL6CpyWUv1O1MzxCgRzZ01gEAk7CnQR62k9CT9sbLLf0FdJ
        PCb0hhO2RD8nluvGoLdR2ztL2r6eusQRgq40BKku6ldxS7mzXDHyJmi7FHKR+fKky37g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipuEo-0006fl-SG; Fri, 10 Jan 2020 14:22:06 +0100
Date:   Fri, 10 Jan 2020 14:22:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110132206.GB19739@lunn.ch>
References: <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <5c3aabb9-dae4-0ca2-72e9-50f8aa7b9ec4@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c3aabb9-dae4-0ca2-72e9-50f8aa7b9ec4@gmx.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 10:19:47AM +0000, ѽ҉ᶬḳ℠ wrote:
> I just came across this
> http://edgemax5.rssing.com/chan-66822975/all_p1715.html#item34298
> 
> and albeit for a SFP g.fast module it indicates/implies that Metanoia
> provides own Linux drivers (supposedly GPL licensed), plus some bits
> pertaining to the EBM (Ethernet Boot Management protocol).
> 
> Has Metanoia submitted any SFP drivers to upstream kernel development?

I have also not seen any. You could ask for the sources. It is
unlikely we would use them, but they could provide documentation about
the quirks needed to make this device work properly.

    Andrew

