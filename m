Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E472B4100A1
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbhIQVPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:15:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhIQVPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 17:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5ADrnYkMNM/ForcJovxeHjoZRZJVp5ryV5r1akQtcfo=; b=pp126GDn33CLTEvYcV+VLywxk1
        QEuaXEotUQjGu2YqhXM+nBZ2qB2Ti/aIGz8YHs+Np1DTiupo4Lmo0QERTWPiUk96DA0rR67NNpZgS
        3B7jMA8abSNYeiNeRK2uEaZssQKllMwtbBJI78CsOBbDDgeZtbVMGs6noy8Git7osi18=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRLBe-0077lK-4S; Fri, 17 Sep 2021 23:14:22 +0200
Date:   Fri, 17 Sep 2021 23:14:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     min.li.xe@renesas.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <YUUFLshlVw+s2TDw@lunn.ch>
References: <1631911821-31142-1-git-send-email-min.li.xe@renesas.com>
 <1631911821-31142-2-git-send-email-min.li.xe@renesas.com>
 <20210917140856.01a00f2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917140856.01a00f2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 02:08:56PM -0700, Jakub Kicinski wrote:
> On Fri, 17 Sep 2021 16:50:21 -0400 min.li.xe@renesas.com wrote:
> > Current adjtime is not accurate when delta is smaller than 10000ns. So
> > for small time correction, we will switch to DCO mode to pull phase
> > more precisely in one second duration.
> 
> 1. *Never* repost the patches when there is an ongoing discussion.
> 
> 2. Always CC people who gave you feedback on the previous version.

And adding to this, please wait at least a day between reposts, to
give people times to actually review the code and make comments.

Thanks
	Andrew
