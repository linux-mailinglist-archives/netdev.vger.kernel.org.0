Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711BC371FAF
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 20:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhECSbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 14:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhECSbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 14:31:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAAE9610FC;
        Mon,  3 May 2021 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620066612;
        bh=tw/vJpPLayjdZJ5Xk9/adCcM6F2GJc3VKtrnKbs2xLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r7EWQ+h4rBmLwUBYyk5LXA6Fh4F5/jK3jEUCMAprga0WOMaPBvEGYJYSTvNDH66I9
         OhhynYJwIILSx0KS37NrlXcjqCtJcPNl1AT+DOt/bHv3J1MBUxb8LruZgmx6rJ3Hz6
         Pg5IGoNd4pMBjXyXjacDWBpDAmsCDUT2pPa7u2EssNzOBbwlNIiYKdMRdW5H1JFWY3
         W/5Y+M22J7ZOZhjaJjR1BcYkm+CVIwG3OY+D0dcb5jwAT062/0Q4N7OQ69d4LxwvWA
         rn1i9XTSwkaSmOwOuKdUHRnCCNZBXGYTrhIp/3M7RAvLFOpRDWV37dYYdsj37hxMZN
         nKU2PgNiC9a7A==
Date:   Mon, 3 May 2021 11:30:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Lowe <nick.lowe@gmail.com>
Cc:     Matt Corallo <linux-wired-list@bluematt.me>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Message-ID: <20210503113010.774e4ca6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADSoG1sf9zXj9CQfJ3kQ1_CUapmZDa6ZeKtbspUsm34c7TSKqw@mail.gmail.com>
References: <20201221222502.1706-1-nick.lowe@gmail.com>
        <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
        <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
        <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <69e92a09-d597-2385-2391-fee100464c59@bluematt.me>
        <CADSoG1vn-T3ZL0uZSR-=TnGDdcqYDXjuAxqPaHb0HjKYSuQwXg@mail.gmail.com>
        <20210201123350.159feabd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADSoG1sf9zXj9CQfJ3kQ1_CUapmZDa6ZeKtbspUsm34c7TSKqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 May 2021 13:32:24 +0100 Nick Lowe wrote:
> Hi all,
> 
> Now that the 5.12 kernel has released, please may we consider
> backporting commit 6e6026f2dd2005844fb35c3911e8083c09952c6c to both
> the 5.4 and 5.10 LTS kernels so that RSS starts to function with the
> i211?

No objections here. Please submit the backport request to stable@.
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-2

