Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086152AE60C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732612AbgKKBuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732518AbgKKBuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:50:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA942216C4;
        Wed, 11 Nov 2020 01:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605059443;
        bh=7OmifCASSAPOWMwLhEQ4aEs/0y5vN154DJ2oJ41dtbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SHeEF8i/tmqO1z99iOEqU5AVgwiAn3JbzT5EwRsK7tSOaOJr17MptarBMBfVid/i2
         fv6GbsQdGxj1W/SSKl6Y9L3GAV2Mtch0VOsngx+7KVKZBV1+++DnohNgUw2sdjpZie
         NgHZdjCUjZEAqbCvvxYeXK14+0lAIi1H6cb1o7vY=
Date:   Tue, 10 Nov 2020 17:50:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, zhangxiaoxu <zhangxiaoxu5@huawei.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Fix memleak in
 mv88e6xxx_region_atu_snapshot
Message-ID: <20201110175042.70cd7bec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109144657.GH1258576@lunn.ch>
References: <20201109144416.1540867-1-zhangxiaoxu5@huawei.com>
        <20201109144657.GH1258576@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 15:46:57 +0100 Andrew Lunn wrote:
> On Mon, Nov 09, 2020 at 09:44:16AM -0500, zhangxiaoxu wrote:
> > When mv88e6xxx_fid_map return error, we lost free the table.
> > 
> > Fix it.
> > 
> > Fixes: bfb255428966 ("net: dsa: mv88e6xxx: Add devlink regions")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: zhangxiaoxu <zhangxiaoxu5@huawei.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
