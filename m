Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E94D454B39
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhKQQpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:45:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238842AbhKQQpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 11:45:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iqSiA3LmgA7H/XJNRSJpFE5oYX/xAJgapN7ANdzkkOY=; b=UFWbDCumNUu8hl3441QMaycJ4D
        9FdiAy8fmiS6NZ0WyK0rBNvdY7wH7KIZg+Vhgij3MH71mDviNwGDETwUQ5NovnrQLLKgkMFFhpsiA
        l5/4hvWndDbd0H5Gf4LJDfEH1kViEc91eg0BZvjlmCCoJj2eQGVobdQygwjDLBN+9bKs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnO0h-00DsK3-J1; Wed, 17 Nov 2021 17:42:11 +0100
Date:   Wed, 17 Nov 2021 17:42:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dejin Zheng <zhengdejin5@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH] Revert "net: ethernet: bgmac: Use
 devm_platform_ioremap_resource_byname"
Message-ID: <YZUw4w3NsfuDO4qS@lunn.ch>
References: <20211117160718.122929-1-jonas.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117160718.122929-1-jonas.gorski@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 05:07:18PM +0100, Jonas Gorski wrote:
> This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.
> 
> Since idm_base and nicpm_base are still optional resources not present
> on all platforms, this breaks the driver for everything except Northstar
> 2 (which has both).
> 
> The same change was already reverted once with 755f5738ff98 ("net:
> broadcom: fix a mistake about ioremap resource").
> 
> So let's do it again.

Hi Jonas

It is worth adding a comment in the code about them being optional. It
seems like bot handlers are dumber than the bots they use, but they
might read a comment and not make the same mistake a 3rd time.

  Andrew
