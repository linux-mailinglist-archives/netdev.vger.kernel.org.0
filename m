Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1389044476B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhKCRsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhKCRsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 13:48:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0434D60EE9;
        Wed,  3 Nov 2021 17:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635961530;
        bh=1sWetLtW1a2Twd/Mhuz7gMXOK2njXdYYXTmmpolvacs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=MWpqBJF3Z7c5SmrLF8COStKXzVFs63BhiX5Y9b0gW168vB0UhpnwVtJKxHEdWLdlY
         dek2NmCfSemHTXeWFbcM9gDwBAM+BsszEhuP3YUiCCWcts3lqv0VsuOr3K4qrFH4Gg
         /KcTgNYj7YvcLc5RcFd30LeXm3NzC2mY7ZUJgmPTdWPKrP4NG4/aS1crow0/ZBvMft
         Gz3tx0VjHyXl807Sj8IqMW/zL2IytC0ECz5cqahLLnDvA1GVYMBSeqlZ6tXp8YZwS3
         tWxp0TUDPw/lG2KwZyUDChRvRPKmv79byVDh4QczNbixuUdBBPwKbj4tXJ/n7IpWun
         n8kuT950sngJQ==
Date:   Wed, 3 Nov 2021 12:45:27 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v3 2/2] mwifiex: Add quirk to disable deep sleep with
 certain hardware revision
Message-ID: <20211103174527.GA701082@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYLJG1y8owwehew+@smile.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 07:38:35PM +0200, Andy Shevchenko wrote:
> On Wed, Nov 03, 2021 at 06:10:55PM +0100, Jonas Dreßler wrote:

> > +	if (mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
> > +			     HostCmd_ACT_GEN_GET, 0, &ver_ext, false)) {
> > +		mwifiex_dbg(priv->adapter, MSG,
> > +			    "Checking hardware revision failed.\n");
> > +	}
> 
> Checkpatch won't warn you if string literal even > 100. So move it to one line
> and drop curly braces. Ditto for the case(s) below.

I don't understand the advantage of making this one line.  I *do*
understand the advantage of joining a single string so grep can find
it more easily.  But that does make the code a little bit uglier, and
in a case like this, you don't get the benefit of better grepping, so
I don't see the point.
