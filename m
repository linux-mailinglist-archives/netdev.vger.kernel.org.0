Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3E343A591
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhJYVOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:14:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231157AbhJYVOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 17:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4vGUmSFQEk2O8PyZ5YEVqZ66dNwwy9DLBwtq/rz46uo=; b=OXb2j+M59MD7E/Mye6pwoNJRHU
        oqesJdOudZjGQx/nzy8qGuVY8+wkTZSQTYh5Y5QLJsC+t9lLLkR86gg+xoDlbXJ/BlJH+FS86CmAp
        ICm7qC6MvP7T4kWKQ+UJ2u6A3bnD211tq1erNWTJuEVz68cLORQN0Gq1tOPl+DqdzOis=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mf7G7-00Bh8x-Vd; Mon, 25 Oct 2021 23:11:55 +0200
Date:   Mon, 25 Oct 2021 23:11:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Robert Schlabbach <Robert.Schlabbach@gmx.net>,
        netdev@vger.kernel.org
Subject: Re: ixgbe: How to do this without a module parameter?
Message-ID: <YXcdmyONutFH8E6l@lunn.ch>
References: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
 <87k0i0bz2a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0i0bz2a.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If it can be set with ethtool already, and the issue is mostly the
> user-friendliness of this interface, how about teaching ethtool a
> symbolic parameter to do this for you? E.g. something equivalent to:
> 
> 'ethtool --change eth0 advertise +nbase-t' ?
> 
> Personally I wouldn't mind having this (symbolic names) for all the
> supported advertised modes; I also think it's a pain to have to go
> lookup the bit values whenever I need to change this...

Something like this has been talked about before, but nobody ever
spent the time to do it. ethtool has all the needed strings, so it
should not be too hard to actually do for link modes.

nbase-t is a bit different since it is not an actual link mode, but a
combination of many link modes.

What is also useful is that you can put ethtool settings into
/etc/network/interfaces.

	Andrew
