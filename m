Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF17F37BCBA
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhELMno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:43:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhELMnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EFP5Q7/kXoKBuiMlQ5GcOCkNrP4o1c9f5iz3wfMKxKg=; b=StEy27UeNoDmxam9YPysCBi/ZC
        0ZJG1H0RCoevUBjXjk+f3xAK2hHoaQxbDuA3pFMJi0CIkmQ7w5RevXx7oXSb++p7RQkpCJKEdSHaZ
        YtLT/YbyZfS4vLuqNnJQdQqJj1Wwte1Z7W00ewBGlWd3BoCtpUpwhpZ3gzjySLUnCQR0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgoBw-003uJ4-0h; Wed, 12 May 2021 14:42:20 +0200
Date:   Wed, 12 May 2021 14:42:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, joel@jms.id.au, andrew@aj.id.au,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mdio: Add missing MODULE_DEVICE_TABLE
Message-ID: <YJvNLExb9AtMYGZo@lunn.ch>
References: <1620790204-15658-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620790204-15658-1-git-send-email-zou_wei@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 11:30:04AM +0800, Zou Wei wrote:
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.

Please make the subject line more specific. There are a number of MDIO
bus drivers in the kernel. Adding "aspeed:" would make it clear which
one you are changing.

    Andrew
