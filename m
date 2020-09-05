Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7E625EA6B
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgIEUgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEUgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 16:36:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 230EB20738;
        Sat,  5 Sep 2020 20:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599338197;
        bh=cs7rrEwHik/Su4uXsEY7WRBvMHghd/7hkKnFHM+VebQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zdtZtatn/kqpKdEIxI4FrGk03ElUXhFKU4IfSxcj/2d+WDFKEoJYA4iWPx/e0Trbu
         CqKRLF8IX3YZNwMCIKyhFSxhrR1RP8bOSvLvyHvy6iisIEyAQLgeodTV4c7AbOm51O
         9jUHUmMtUrIx3QDhGaYqcD3ucXOMzjYsFvm6G9BM=
Date:   Sat, 5 Sep 2020 13:36:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: repair reference in LYNX PCS MODULE
Message-ID: <20200905133635.497c3663@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905103700.17162-1-lukas.bulwahn@gmail.com>
References: <20200905103700.17162-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 12:37:00 +0200 Lukas Bulwahn wrote:
> Commit 0da4c3d393e4 ("net: phy: add Lynx PCS module") added the files in
> ./drivers/net/pcs/, but the new LYNX PCS MODULE section refers to
> ./drivers/net/phy/.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:
> 
>   warning: no file matches    F:    drivers/net/phy/pcs-lynx.c
> 
> Repair the LYNX PCS MODULE section by referring to the right location.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Applied, thanks!
