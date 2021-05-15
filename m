Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEBE38194B
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 16:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhEOOTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 10:19:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41756 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhEOOS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 10:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O24gqUkhnIeZ6rOhyDlYvtV/K6si/ofl9ftES0V36Dg=; b=5T3n/cLEmrFd5XBQjkSYE6YSLf
        xgtRneEc+C+vpv1u/5lIMytpgGF9c2OQJB4wbkXOk8x3djk9eVnRRYFo6JWxxpY2iqT2cSJxl8Pk8
        fiyeXiqUo7V279ZBlBXUQQcwPhuFtQ9jQKg6+rgoQ7r13B+aptDHBvUlastOZ7G2hDnk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhv6p-004Kln-0G; Sat, 15 May 2021 16:17:39 +0200
Date:   Sat, 15 May 2021 16:17:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 23/34] net: phy: Demote non-compliant kernel-doc headers
Message-ID: <YJ/YAr0SOjI/O2XR@lunn.ch>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-24-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621076039-53986-24-git-send-email-shenyang39@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 06:53:48PM +0800, Yang Shen wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/phy/adin.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  drivers/net/phy/rockchip.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
