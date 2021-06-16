Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D6D3AA084
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhFPP7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:59:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235111AbhFPP6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 11:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oonBVpl7g2GdZJ4lxCN/ckpA2HWv0G5g5Kyuw1GGMQk=; b=MLnscUPt5mmh48+cq/HxbbY4+0
        YrES7gRalA9LrFjA78sfq8yybGZ3BCWNDBbr4WOfa0lI14e769YhL689siS7GlutAPz57I8nhIB/p
        ahdr9s3WjTI+sJRo66IcsNzPv7XCRYUVFMkdUZInvTzXMoO8seZt6PYn6cl2ni/fVfts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltXtg-009kWC-Vy; Wed, 16 Jun 2021 17:56:08 +0200
Date:   Wed, 16 Jun 2021 17:56:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH v2 net-next 2/8] net: phy: correct format of block
 comments
Message-ID: <YMofGHONjA0hoxu0@lunn.ch>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
 <1623837686-22569-3-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623837686-22569-3-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 06:01:20PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> Block comments should not use a trailing */ on a separate line and every
> line of a block comment should start with an '*'.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
