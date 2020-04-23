Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A4E1B513B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDWAVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgDWAVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 20:21:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BB9D20704;
        Thu, 23 Apr 2020 00:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587601311;
        bh=ic4v7Bk99U/2TTEq7gGalaOGjQfJ77Qj/nZpBQvFafs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xc9xahHPbLcSTN9pbScT2pW9xqYT8eG4za17xS7KW0hqL5f8ky+TvyRUlzYD7UDxK
         9mC40qyTljL+k3WCcuv0KpkXtpcQKlpln6tpk4EeuutnkIte5xANP2nXsSiU/CMa0p
         hZUQL6dJAZIQGCam4N+q19C2SKnoqbTcRLE3yagA=
Date:   Wed, 22 Apr 2020 17:21:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     khalasa@piap.pl, davem@davemloft.net, linus.walleij@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: Re: [PATCH v2] net: ethernet: ixp4xx: Add error handling in
 ixp4xx_eth_probe()
Message-ID: <20200422172149.787fdc3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422010922.17728-1-tangbin@cmss.chinamobile.com>
References: <20200422010922.17728-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 09:09:22 +0800 Tang Bin wrote:
> The function ixp4xx_eth_probe() does not perform sufficient error
> checking after executing devm_ioremap_resource(), which can result
> in crashes if a critical error path is encountered.
> 
> Fixes: f458ac479777 ("ARM/net: ixp4xx: Pass ethernet physical base as resource")
> 

No extra lines, between the tags, though, please.

> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
