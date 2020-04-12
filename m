Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C571A5FDA
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgDLSfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgDLSfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:35:40 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DC3C0A3BF0;
        Sun, 12 Apr 2020 11:35:40 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F1F320692;
        Sun, 12 Apr 2020 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586716540;
        bh=3/wGsfbfYY5CVO1/2e2j77ki+CMc/twF4oRNiRbEzgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UIalYcu8ewiz/BxpdRnR86ChTIsMg79miPvh9DuiBixYAQdWQB8kwSILVCHa+ZHp/
         +NSKUp3LGhMtGn9pBNI0lXUr5uqisW+0S81i+cEYss2P30iUEINYK/Tduo6XSbRFMp
         GFnUOTIGXPdwgXSarYFLtJjw9BsRgj1sPRhkZQGk=
Date:   Sun, 12 Apr 2020 11:35:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     khalasa@piap.pl, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
Subject: Re: [PATCH] net: ethernet: ixp4xx: Add error handling in
 ixp4xx_eth_probe()
Message-ID: <20200412113538.517669d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200412092728.8396-1-tangbin@cmss.chinamobile.com>
References: <20200412092728.8396-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Apr 2020 17:27:28 +0800 Tang Bin wrote:
> The function ixp4xx_eth_probe() does not perform sufficient error
> checking after executing devm_ioremap_resource(),which can result
> in crashes if a critical error path is encountered.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> Signed-off-by: Shengju Zhang <zhangshengju@cmss.chinamobile.com>

Please provide an appropriate Fixes: tag.
