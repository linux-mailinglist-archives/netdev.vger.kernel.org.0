Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1CEA183AEB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgCLUyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgCLUyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:54:31 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F3D6206B7;
        Thu, 12 Mar 2020 20:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584046470;
        bh=PvbdNsOe0VwVAwRa3+27OnFLtZqNrOjd7DWi6egcw0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sl4tyNuT2NJgT0ATGSvNl73f72I8Nc9OrXTs5996fl7lA5RNGsM8hrhfl01FYdaL/
         pVtnJt4mXZw4vgVPXsut1VoUtIkKcFtTFEU+lQkjlGAreZ/7rK/mIX7Ol+faHPejOF
         aiKMFG3bCHRavOre0S1y9U7X+OspXHxNa0qul7qk=
Date:   Thu, 12 Mar 2020 13:54:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 14/15] ethtool: set device channel counts
 with CHANNELS_SET request
Message-ID: <20200312135429.1a507199@kicinski-fedora-PC1C0HJN>
In-Reply-To: <58eaff0d7ec1cd4a85142c07e4a1c97772b784e3.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
        <58eaff0d7ec1cd4a85142c07e4a1c97772b784e3.1584043144.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 21:08:43 +0100 (CET) Michal Kubecek wrote:
> Implement CHANNELS_SET netlink request to set channel counts of a network
> device. These are traditionally set with ETHTOOL_SCHANNELS ioctl request.
> 
> Like the ioctl implementation, the generic ethtool code checks if supplied
> values do not exceed driver defined limits; if they do, first offending
> attribute is reported using extack. Checks preventing removing channels
> used for RX indirection table or zerocopy AF_XDP socket are also
> implemented.
> 
> Move ethtool_get_max_rxfh_channel() helper into common.c so that it can be
> used by both ioctl and netlink code.
> 
> v2:
>   - fix netdev reference leak in error path (found by Jakub Kicinsky)
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
