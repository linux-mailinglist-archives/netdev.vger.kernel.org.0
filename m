Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CA11CCCF7
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 20:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgEJSk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 14:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgEJSk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 14:40:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10CAA2080C;
        Sun, 10 May 2020 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589136057;
        bh=tR/IFz9g/5KCFDPAMwVRLyColMmVlLz/GYzR7rK84GU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cHecr9sZeP1MjsMDDwqcXVqSMgcNDGJBQ1TTmKtOURgKhBrSQ0KVpaMQQn7Kzh5Ic
         GRrYIlUJcVNp5Nkp7Io/KzDRKVA4wk8jQXoH/alN1GOMGU+a8h4/XBFtCutNYl3bfq
         g4KwjPFTORHcdrIS8AChMAbj3H2tVulTrE7PmjvE=
Date:   Sun, 10 May 2020 11:40:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net] net: dsa: loop: Add module soft dependency
Message-ID: <20200510114055.7c3c7c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509234544.17088-1-f.fainelli@gmail.com>
References: <20200509234544.17088-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 16:45:44 -0700 Florian Fainelli wrote:
> There is a soft dependency against dsa_loop_bdinfo.ko which sets up the
> MDIO device registration, since there are no symbols referenced by
> dsa_loop.ko, there is no automatic loading of dsa_loop_bdinfo.ko which
> is needed.
> 
> Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thank you!
