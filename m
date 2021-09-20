Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F337411ADA
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245257AbhITQwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:52:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240476AbhITQuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PdjbhjDKUH4VNwSZHwS+PmBefZ+LAhElGG9ogBWEbR8=; b=4YYUBo3LWOkun1WSOq+O7nvmwk
        2xEPNxsfzRcoMXscHpRtTV7sLQRvzMq6P4No3bUtCQqO+qc4YYBcTMcGOWuVEfXDBAdb6vOOlvi7M
        BlgMG+VonLvGr+bx9L0M9NJ8zroiBb+oPurmvlMj3/ix99ajjzZCyWBSv3ZQm+ro7qXs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSMTo-007WD4-4F; Mon, 20 Sep 2021 18:49:20 +0200
Date:   Mon, 20 Sep 2021 18:49:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Min Li <min.li.xe@renesas.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <YUi7kMkUI/69wHD/@lunn.ch>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
 <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
 <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <OS3PR01MB65936ADCEF63D966B44C5FEFBADD9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20210917140631.696aadc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <OS3PR01MB65936F7C178EC44467285F2BBAA09@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3PR01MB65936F7C178EC44467285F2BBAA09@OS3PR01MB6593.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 03:13:14PM +0000, Min Li wrote:
> > 
> >   > On Fri, Jun 25, 2021 at 02:24:24PM +0000, Min Li wrote:
> >   > > How would you suggest to implement the change that make the new
> > driver behavior optional?
> >   > I would say, module parameter or debugfs knob.
> > 
> > Aright, in which case devlink or debugfs, please.
> > 
> Hi Jakub
> 
> The target platform BSP is little old and doesn't support devlink_params_register yet.
> 
> And our design doesn't allow debugfs to be used in released software.

That does not matter. You are not submitting code to your BSP, you are
submitting to mainline. Please use the features mainline provides.

	   Andrew
