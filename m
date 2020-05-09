Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E311CBDD4
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgEIFod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgEIFod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:44:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B133A21582;
        Sat,  9 May 2020 05:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589003072;
        bh=/O2LZeS4VAr5I9gMNcPDpaNC54Se35odPM5MalyE8h4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eWBdmPvak5Tc3y+wjP/gSynpYem1rF26L2DnbcMqyIlyAeEJcZv4AcU2KVdvEOoe3
         sZWRLR6V6e2Dg/IOrC4ksS03R+oTmX19IOKqKpFYBXjWzDG87E+RZWIdIuKZJ+oIOJ
         xACKqGpW3m9yWYkDHdL3uUzoRahIyRJ1FKe7QZX0=
Date:   Fri, 8 May 2020 22:44:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] r8169: sync few functionalities with
 vendor driver
Message-ID: <20200508224431.4344f702@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
References: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 23:28:51 +0200 Heiner Kallweit wrote:
> Add few helpers (with names copied from vendor drivers) to make clearer
> what the respective code is doing. In addition improve reset preparation
> for chips from RTL8168g.

Applied, thank you!
