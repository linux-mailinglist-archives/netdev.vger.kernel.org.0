Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC4E3AB408
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhFQMxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhFQMxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 08:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561A661209;
        Thu, 17 Jun 2021 12:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623934251;
        bh=k4q7NzRZSiwdbbAWtQLvpe237U6i/9kMgcR/koBL1RY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DARwNKlE21Pt2vFuI9IbpKY/YTepvjYj2nxb9Z+Iez0iUD1/sAYyyPt+lXyYD5fD+
         1zoaEcvXn1+i6V08NyY5V0brqdfdA/yk2UZ3pgKU4RucObWWGxsYv0kTN4Qb6TKWmB
         6E1xi+YbkhbBvY0SBV5JB0UFDPBTOY0oOk8nVgN4=
Date:   Thu, 17 Jun 2021 14:50:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        rafael@kernel.org, grant.likely@arm.com,
        calvin.johnson@oss.nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 2/3] driver core: add a helper to setup both
 the of_node and fwnode of a device
Message-ID: <YMtFKaQVWzjissYr@kroah.com>
References: <20210617122905.1735330-1-ciorneiioana@gmail.com>
 <20210617122905.1735330-3-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617122905.1735330-3-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 03:29:04PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> There are many places where both the fwnode_handle and the of_node of a
> device need to be populated. Add a function which does both so that we
> have consistency.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

