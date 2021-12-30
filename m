Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481E2481E49
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 17:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbhL3Ql3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 11:41:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240031AbhL3Ql3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 11:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=a47Ww1AEiqQnaQ5wYqUIdSxjBl7hkeMkukfHuBSF06Y=; b=2d1Ik+qRmJgwpS+HlOjujXBhAq
        PHlbVEqLSWqq+womkQt//sJCWwdGdi1YFvJ9RpL0ZZjrRGVOJXnPyKD7nGkqGDD2kFSo8qcXw+xUN
        DDu9T9y6LIkqa0lVsOWREU3mGgM6bdblqsqAsm6oZ/Iywvtvmj2x1Ys9ODeXSzmyJ/c4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n2yUZ-000B3d-5x; Thu, 30 Dec 2021 17:41:27 +0100
Date:   Thu, 30 Dec 2021 17:41:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Cc:     aelior@marvell.com, netdev@vger.kernel.org, palok@marvell.com
Subject: Re: [PATCH net-next v2 1/1] qed: add prints if request_firmware()
 failed
Message-ID: <Yc3hN/BTYtoKBLnC@lunn.ch>
References: <YcrmpvMAD5zKHqTE@lunn.ch>
 <20211229110232.336845-1-vbhavaraju@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229110232.336845-1-vbhavaraju@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 03:02:32AM -0800, Venkata Sudheer Kumar Bhavaraju wrote:
> > Hi Venkata
> > 
> > When you decide to do something different to what has been requested,
> > it is a good idea to say why. There might be a very good reason for
> > this, but unless you explain it, i have no idea what it is.
> > 
> >    Andrew
> 
> Hello Andrew,
> 
> I moved the FW_REPO macro to qed_if.h under include/linux since I didn't
> want to bloat something like include/linux/firmware.h. It's really used
> (exact URL in a print after request_firmware() fails) at two other places.

So you think the intel drivers are going to include qed_if.h? Don't
you think something vendor neutral would be better?

Anyway, from what Jakub is saying, you don't need the print at all.

	Andrew
