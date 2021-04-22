Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA6368365
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhDVPfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhDVPfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C59613C4;
        Thu, 22 Apr 2021 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619105697;
        bh=oReKqq6pnz/ofmPvrTV4OwXSyUY1C9NcXmiExzcierQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=muqPJzv2KjS9c8009mT4zwdw4ab20vmf/rS778xZqaR6X21iDcKbdqiraEMYvtL7n
         6VH33vcJhhptTvIWs3gwHfQLn7eZxUKuQuDW4mI18DgFlao9O/scbUMNObxrGJK6zE
         Xw/wOEJwpj2G87w5UpjHQI93M59QXjwlstkS/1wOHbIqfIWLFOe/K8V7r4eap7sZ/4
         frJWoZs1WHy8zvCUEPANk2/u0Wn0ta6zitjo6M2MqeUg4JCWggR8Y65FU7TIEKtRY9
         BYIMadQ0qfb2Kv/Mk9DWm+r9FuM81wCsBPQu08dqyM8mccaC79d2Md+tNQHhZyQmsn
         xyk3QjETzAx7Q==
Date:   Thu, 22 Apr 2021 08:34:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next 0/7] ethtool: support FEC and standard
 stats
Message-ID: <20210422083456.418a4e16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YIE4gZWsjrHNrZGA@shredder.lan>
References: <20210420003112.3175038-1-kuba@kernel.org>
        <YIE4gZWsjrHNrZGA@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 11:49:05 +0300 Ido Schimmel wrote:
> On Mon, Apr 19, 2021 at 05:31:05PM -0700, Jakub Kicinski wrote:
> > This series adds support for FEC requests via netlink
> > and new "standard" stats.  
> 
> Jakub, you wrote "ethtool-next" in subject, but I only managed to apply
> the patches to the master branch.

Indeed, sorry about that. Let me rebase and repost.
Thanks for testing!

> Michal, I assume we are expected to send new features to next? If so,
> can you please update the web page [1] ?
> 
> Thanks
> 
> [1] https://mirrors.edge.kernel.org/pub/software/network/ethtool/devel.html

