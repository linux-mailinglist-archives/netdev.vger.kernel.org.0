Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9441330B0F2
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhBAT5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232277AbhBATq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 14:46:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF9164EA8;
        Mon,  1 Feb 2021 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612208746;
        bh=Bt2SwOJhVscQlRl7BvleAmRRaOwkfn08bxiTPtNDXxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aQxGljOO6aGVufZhBC7phwXf0r+zX+r2OOemqI6jlqXNCFu0jcX4ScQNQ2ONqw6/n
         HI41xAJ0oPu8N3GcxLfMTsIN4K8+ZRyF4puzB0ePuuRD/RinSd/UcD7Ot7hVLxGZWR
         jjapcvtIgvlW37tIjP50Ci8zU5OKZVB3q7FCfwt2bi4HejHpWa1SbZHUheRRE/F+eg
         EcFQhtrWXv4N+cc6WLiqnkXClkZEYUIgiMg/Wn9mxmbwkRcKnKV2pnlBOfdh26NIDU
         aGcHGBCjeCjCPKZAaYE/Sz9hQUCAsdOB3fKhPm7v3j3BSLR+dl3F5fHucqiUsG9qBm
         HE0xM2A7RNeIA==
Date:   Mon, 1 Feb 2021 11:45:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "linux-wired-list@bluematt.me" <linux-wired-list@bluematt.me>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "nick.lowe@gmail.com" <nick.lowe@gmail.com>
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Message-ID: <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
References: <20201221222502.1706-1-nick.lowe@gmail.com>
        <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
        <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 18:32:50 +0000 Nguyen, Anthony L wrote:
> On Mon, 2021-02-01 at 08:47 -0800, Jakub Kicinski wrote:
> > On Sun, 31 Jan 2021 18:17:11 -0500 Matt Corallo wrote:  
> > > Given this fixes a major (albeit ancient) performance regression,
> > > is
> > > it not a candidate for backport? It landed on Tony's dev-queue
> > > branch
> > > with a Fixes tag but no stable CC.  
> > 
> > Tony's tree needs to get fed into net, then net into Linus's tree and
> > then we can do the backport :(  
> 
> The behavior looks to have always been since support was introduced
> with f96a8a0b7854 ("igb: Add Support for new i210/i211 devices."). I
> was unable to determine the original reason for excluding it so I was
> planning on sending through net-next as added functionality, however, I
> will go ahead and send this through net and add it to the current
> series that I need to make changes to.

Hm, no need for net if it's not really a regression IMO. Not after -rc6.

Matt, would you mind clarifying if this is indeed a regression for i211?
