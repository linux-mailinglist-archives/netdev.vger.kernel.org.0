Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043C31E8D2C
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 04:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgE3CUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 22:20:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgE3CUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 22:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X9bkI2ilvEQW0erLexn/O2fz3158c1t2uQMV+b5J/gA=; b=FnWPc7sDhhjEGbZYaNBWQ0dcf9
        /qowvyuJLOKGKdoyCmJ6HR8/tKxolRV/c9v4rrRMwD9Xi0LTcxq0qeHlxs/jKU0Xn0bHmfDxyG07H
        BY/SS8sflVtlPY4XFCM1FdaQ9WkCbcC06eJSddaVWg6eOt40E459Dx1XkinQ85KmUFBI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jer6k-003hnC-Ff; Sat, 30 May 2020 04:20:22 +0200
Date:   Sat, 30 May 2020 04:20:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        oleksandr.mazur@plvision.eu, serhiy.boiko@plvision.eu,
        serhiy.pshyk@plvision.eu, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, andrii.savka@plvision.eu,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mickeyr@marvell.com
Subject: Re: [net-next 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
Message-ID: <20200530022022.GI877847@lunn.ch>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
 <20200529.171839.213046818110655879.davem@davemloft.net>
 <20200530004622.GA19411@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530004622.GA19411@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 03:46:22AM +0300, Vadym Kochan wrote:
> Hi David,
> 
> On Fri, May 29, 2020 at 05:18:39PM -0700, David Miller wrote:
> > 
> > Please remove all of the __packed attributes.
> > 
> > I looked at your data structures and all of them use fixed sized types
> > and are multiples of 4 so the __packed attribute is completely
> > unnecessary.
> > 
> > The alignment attribute is also unnecessary so please remove that too.
> 
> Some of the fields are u8, so I assume there might be holes added by
> the compiler ? Also these attributes guarantee some ABI compatibility
> with FW side, I will try to remove them and check but it sounds for me a bit
> risky.

Hi Vadym

You might want to play with pahole(1).

    Andrew
