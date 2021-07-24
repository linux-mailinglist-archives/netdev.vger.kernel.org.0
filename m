Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9D33D48DA
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhGXQnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:43:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhGXQnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 12:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I9g3dgoBONfq5xCj/pnogfGBUGq1X2goqFKI9y+GLGk=; b=qy8oVpVE1FHcadGy23IA0X3+/N
        fh5Ds9crLlPfgMhtIHxn4GGUC4s6MoUea67d+qps2CB883OKkhFZ1Gc/qef3lzJsBdQaJyxXysFop
        hn4KNrNG/uUqJ8ZNqNrCAs0RyVvcu6z7Io+oxjtKTqBOV3unHNy0Ow2npczLxJTqxjGE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m7LN7-00EeDm-Qe; Sat, 24 Jul 2021 19:23:33 +0200
Date:   Sat, 24 Jul 2021 19:23:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v2 1/2] net: ethtool: Support setting ntuple rule count
Message-ID: <YPxMlaxjT0vSeqZg@lunn.ch>
References: <1627064206-16032-1-git-send-email-sgoutham@marvell.com>
 <1627064206-16032-2-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627064206-16032-2-git-send-email-sgoutham@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:46:45PM +0530, Sunil Goutham wrote:
> Some NICs share resources like packet filters across
> multiple interfaces they support. From HW point of view
> it is possible to use all filters for a single interface.
> Currently ethtool doesn't support modifying filter count so
> that user can allocate more filters to a interface and less
> to others. This patch adds ETHTOOL_SRXCLSRLCNT ioctl command
> for modifying filter count.
> 
> example command:
> ./ethtool -U eth0 rule-count 256

How can use see what the current usage is? How many in total you have
available?  What the current split is between the interfaces?

You say:

   * Jakub suggested if devlink-resource can be used for this.

devlink-resource provides you a standardised mechanism to answer the
questions i just asked. So i would have to agree with Jakub.

	  Andrew
