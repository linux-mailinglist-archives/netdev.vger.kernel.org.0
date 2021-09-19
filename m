Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6065141090B
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhISBUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 21:20:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48022 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhISBUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 21:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fu8n6CcadB6MWsB8gIN5VR80o3ILmCwu5IK7XNIncAI=; b=q1jar6//CrBEEC2URJGTV6khls
        tsawJWD0Q7qISH0CQxqiMOMfiYXfaPqPoWB9yzwJ9HS4Yg4Teelb706cN113HskAgHrGMwkwJwr2z
        02/4OJl2JMJxvlPeZyhxIFv2yht91vMkZxzDZhVoBzvZf8NmXcd/gJWUSGfjkwQBMjcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRlUI-007HZ2-Dp; Sun, 19 Sep 2021 03:19:22 +0200
Date:   Sun, 19 Sep 2021 03:19:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH] net: bgmac-bcma: handle deferred probe error due to
 mac-address
Message-ID: <YUaQGrZyEPSCPVTh@lunn.ch>
References: <20210918172632.1887059-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210918172632.1887059-1-chunkeey@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 07:26:32PM +0200, Christian Lamparter wrote:
> Since the inclusion of nvmem into the helper function
> of_get_mac_address() by
> commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> it has been possible to receive a -EPROBE_DEFER return code during boot.

Please use this commit as the Fixes: tag.

Also, please base this in net, not next-next, and put net in subject,
as described in the netdev FAQ.

   Andrew
