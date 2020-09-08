Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CBA26092D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgIHEBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgIHEBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 00:01:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1689F2087D;
        Tue,  8 Sep 2020 04:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599537700;
        bh=KCOKP1nk/GX2uhb921/Zv1o/CwYliUAenrqJ1DVHZkE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VLEEgUoXcfyc15ajYkkBk9VmyTpdCucRBMGN2tIOzFfV17v9HADZOCkT5rCaqcqrK
         myRsRPIvjLKRhWr+f7U7cAl/xH2S9eE/Y9ahaBrvVkHKdNc1dFm2jHfrkBnlHC9p5z
         2u6N+IpntNrup4LH2OjRfhBQKfB7Oyoub1eDDZF4=
Date:   Mon, 7 Sep 2020 21:01:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: don't print non-fatal MTU error if
 not supported
Message-ID: <20200907210138.118cc176@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907232556.1671828-1-olteanv@gmail.com>
References: <20200907232556.1671828-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 02:25:56 +0300 Vladimir Oltean wrote:
> Commit 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set
> the MTU") changed, for some reason, the "err && err != -EOPNOTSUPP"
> check into a simple "err". This causes the MTU warning to be printed
> even for drivers that don't have the MTU operations implemented.
> Fix that.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks everyone!
