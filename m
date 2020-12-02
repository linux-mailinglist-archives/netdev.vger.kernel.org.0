Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C72CC733
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389834AbgLBTxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:53:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388104AbgLBTxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:53:32 -0500
Date:   Wed, 2 Dec 2020 11:52:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606938771;
        bh=8BolA7lFJfL6D4zfjbrI9nnx6Jokie3CsS/Zh/BYugE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=sPFRLN6wj9V7oG0tefJBuXR33sVtmTaW/Ix9MOVrGCNz8QbCAiYW3uK/FzX6NxVUM
         pBChcoWeoc1/djnB34melSOj7/B5X8pvXvsvVB6g3WlT51Bb4lnWebTs7zm59WbpBI
         uT+3O764g6slrMmhLbYlAEggBPm7psddP1enJ4CRbxNIwRhkALvSm4OvpM9g/Fkavf
         HcwMVSKfG5SGmiGkS1wMWGmV71aeA0GTmdy/XO1wEloIlgm7QRuqNrP/4JEv8mgqBX
         9pWlBIUkeP8icNRWXoEn5sXLF/jg8lvlYvS9UjDJIws7jTqzvbHneqBobph63FHLDC
         Qv9/RIfKv/usA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dpaa_eth: copy timestamp fields to new skb in A-050385
 workaround
Message-ID: <20201202115249.7d777416@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <VI1PR04MB5807833DEB5F5C25D19DFD18F2F30@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20201201075258.1875-1-yangbo.lu@nxp.com>
        <VI1PR04MB5807833DEB5F5C25D19DFD18F2F30@VI1PR04MB5807.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 13:17:46 +0000 Camelia Alexandra Groza wrote:
> > The timestamp fields should be copied to new skb too in
> > A-050385 workaround for later TX timestamping handling.
> > 
> > Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
>
> Acked-by: Camelia Groza <camelia.groza@nxp.com>

Applied, thanks!
