Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB482C6988
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbgK0Qj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgK0Qj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 11:39:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5667D22240;
        Fri, 27 Nov 2020 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606495166;
        bh=60oXbVnYLY+j6+od6XnIH02TukdtacKyiyMmPUwuKkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wuVdjYb2Rwh04jFAj8WEwvSe2ePkoNQsZMVWHmW4JzrfBIpHVEENclEX+/qfPWvD2
         ldkuQVKEw/k3oXCWW+fkHvSpuSoweY1en9D94hk2zJ5zMYP/VZcNTVd1uJYIAXEo+F
         HE/zPo5RHIC7KrIPWrKoMO5573+CNenS7xEgCszU=
Date:   Fri, 27 Nov 2020 08:39:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Markus.Elfring@web.de,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] lan743x: fix for potential NULL pointer dereference
 with bare card
Message-ID: <20201127083925.4813c57a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <29226509.5m4h6Y2tBG@metabook>
References: <220201101203820.GD1109407@lunn.ch>
        <20201103173815.506db576@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAGngYiXFJTQN3+-HC7L0F5cVfXBpPLS3O4gbaSdMmNurzgnwGw@mail.gmail.com>
        <29226509.5m4h6Y2tBG@metabook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 11:39:41 +0300 Sergej Bauer wrote:
> > On Tue, Nov 3, 2020 at 8:41 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > On Mon,  2 Nov 2020 01:35:55 +0300 Sergej Bauer wrote:  
> > > > This is the 3rd revision of the patch fix for potential null pointer
> > > > dereference with lan743x card.  
> > > 
> > > Applied, thanks!  
> > 
> > I noticed that this went into net-next. Is there a chance that it could also
> > be added to net? It's a real issue on 5.9, and the patch applies cleanly
> > there.  
> 
> It's my mistake - I missed pointing of stable branch.


> Should I resend the patch (with tag Cc:stable@vger.kernel.org)?

 Fixes tag would have been best. But it's too late
now, let's wait for the merge window and then we can back port it. 
