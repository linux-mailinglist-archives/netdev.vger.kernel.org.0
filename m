Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F203D55CC
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhGZIBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 04:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhGZIBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 04:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF2960720;
        Mon, 26 Jul 2021 08:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627288891;
        bh=eIi3D0qYBSxKVqxpuYsQzma/OHI4Se5bOSS2/UNnPLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sr8FVQkZVsLsxsAtQWpiCBOSjP1fcDX2jF40pRiF3lDP6qMM35ZTOqyiLaAvV23qB
         g8kBBOecYaXA5xFOLesrj0oyUiUcKr42p/53RYbufbeN9vOtWryPmx/zxFgyYdjMXl
         DSOOtuZQoBXjgf/dRC2PmP5E9rlLjM+TKKfw4LBA=
Date:   Mon, 26 Jul 2021 10:37:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next RESEND 2/2] r8152: separate the r8152.c into
 r8152_main.c and r8152_fw.c
Message-ID: <YP50SIgqAEyKWSpA@kroah.com>
References: <1394712342-15778-368-Taiwan-albertk@realtek.com>
 <1394712342-15778-371-Taiwan-albertk@realtek.com>
 <1394712342-15778-373-Taiwan-albertk@realtek.com>
 <YP5mFKeJsGezjdve@kroah.com>
 <c6b44f93a5b14fbb98d4c6cb0ed2a77f@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6b44f93a5b14fbb98d4c6cb0ed2a77f@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 08:26:00AM +0000, Hayes Wang wrote:
> Greg KH <gregkh@linuxfoundation.org>
> > Sent: Monday, July 26, 2021 3:37 PM
> [...]
> > That is a lot of different things all happening in one commit, why?
> 
> I plan to separate the file into two files. And
> I find I need an additional header file for it, so
> The patch includes adding that header file.

You also do other things, like renaming defines, which is not just
moving code around, right?

> > Please break this up into "one patch per change" and submit it that way.
> > 
> > But the real question is why break this file up in the first place?
> > What is wrong with the way it is today?  What future changes require
> > this file to be in smaller pieces?  If none, why make this?  If there
> > are future changes, then please submit this change when you submit
> > those, as that would show a real need.
> 
> The purpose is let me easy to maintain the driver.
> The code is larger and larger. And I find that the
> r8169.c has been separated into three files.
> Therefore, I think maybe I could split the driver
> into small parts like r8169. Then, the code wouldn't
> be complex.

I do not know, is it really easier to find things in 3 different files
instead of one?  That's up to you, but you did not say why this change
is needed.

thanks,

greg k-h
