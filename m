Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D5430E2A9
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhBCSih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhBCSiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:38:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FBBA64E31;
        Wed,  3 Feb 2021 18:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612377461;
        bh=LqWx3DlGAj4pkQkQ0viaHg88mOweLomSms4ucdwDTBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WQD1aDxB9FYtlLOZNdP2TQs4tYPw7HCoUjRBFV6QYtJYzS0ZA9E0vmEYwzrzWmMJn
         JctdPl9hvmink0izV4qYfAvdvGA0M0axHb3rNc6CRYKEN/jqy4YlGA45lKl8cKyN4n
         ApOArmVqbDH2Dj6KkM44Hc/04SFy4vyWu1xc5wkOfW8Te++fzgpxfZ6ppTVpwfXr/4
         UAF4GsjsXrRFAlAyxtIQf2riaFpBNOlYZyx2ny41YMPvVA0kxiTB3slngIo95Ztzvv
         AySAgAuBVCdPp/dTkmili5XYqOuD5cPI8Y/yqfJxc107pPWIRbdGbYzSpCxbWjeMky
         XyELWZGJCIyLg==
Date:   Wed, 3 Feb 2021 10:37:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Rybak, Eryk Roch" <eryk.roch.rybak@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Bhandare, KiranX" <kiranx.bhandare@intel.com>
Subject: Re: [PATCH net-next 6/6] i40e: Log error for oversized MTU on
 device
Message-ID: <20210203103739.563c13c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR11MB28761B036F7DDDFBE7D53CB5E5B49@DM6PR11MB2876.namprd11.prod.outlook.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
        <20210202022420.1328397-7-anthony.l.nguyen@intel.com>
        <20210202183448.060eeabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM6PR11MB28761B036F7DDDFBE7D53CB5E5B49@DM6PR11MB2876.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 09:14:24 +0000 Loktionov, Aleksandr wrote:
> Good day Jakub

Please don't top post.

> We want to be user friendly to help users troubleshoot faster.
> Only dmesg message can have template parameters so we can provide
> exact acceptable maximum bytes. Can you could you take this into
> account?

I was making the same exact point when adding the message for NFP
years ago and it was shot down :)

Today upstream is getting close to removing the page-per-packet
requirement, so this will hopefully become irrelevant soon. Maciej
should have the details on that, he seems to be keeping up the most
with upstream in ITP.
