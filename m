Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752161376E0
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgAJTXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:23:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60514 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgAJTXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 14:23:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AaOWYWDQdbzSOvBU3U1oPjEcoWoLZrkOfW+sanpYw7E=; b=oAJsyBTqKjoR9zF16uydQygoEf
        qTvFiZ5NAnBJCe/UdIlmYDUyUHJZp/lrw1gxSOhJGOL4iEyqq4yPOO7eAfa/pDaGBVppJTSTu8dTH
        CqjZxxq1EFlfMkMWas2a9w48BvTC6EthbatVAXx/Lz/bibH7GilZtx45s1N3oAV2k4Wk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipzsM-0003hP-44; Fri, 10 Jan 2020 20:23:18 +0100
Date:   Fri, 10 Jan 2020 20:23:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110192318.GN19739@lunn.ch>
References: <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
 <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
 <20200110170836.GI25745@shell.armlinux.org.uk>
 <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
 <20200110173851.GJ25745@shell.armlinux.org.uk>
 <e18b0fb9-0c6d-ed5e-3a20-dc29e9cc048e@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e18b0fb9-0c6d-ed5e-3a20-dc29e9cc048e@gmx.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If really necessary I could ask the TOS developers to assist, not sure
> whether they would oblidge. Their Master branch build bot compiles twice a
> day.
> Would it just involve setting a kernel debug flag or something more
> elaborate?

You could ask them to build a kernel with dynamic debug enabled

https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.html

You can then turn on debugging in a flexible way. And it will be
useful for more than just you.

    Andrew
