Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D713E863A
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhHJWvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:51:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235138AbhHJWvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+WeUotpxsncc4sKYmqrpBVzbxS2TK1OVzHvR7DoKzfk=; b=dKPLyrZhO4hfQN52SZ7ig1Jz8g
        OvjI+W2EkNFOJHl1AqS8XckJCBS6Ldv5OIvE1yDKTp/dr46Zk42i3KNftVCNRRVooom1oa9htN8LC
        r+Q77tQdMHqtXTJzhuF5H9Os/7/gJa0w5maxL6HB0HhXawBUkfJiMhc0x03a76VDuCI4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDaaV-00GzWl-W9; Wed, 11 Aug 2021 00:51:11 +0200
Date:   Wed, 11 Aug 2021 00:51:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRMC3zWIlIPeK2NB@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The patch is well defined but it doesn't provide user with the answer
> to the question "why is the SFP still up if I asked it to be down?"

Can the user even see that the SFP is still up? Does ip link show
give:

3: eth42: <BROADCAST,MULTICAST,LOWER_UP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000

i.e. LOWER_UP despite DOWN?

Roopa added:

    rtnetlink: add support for protodown reason

Maybe we need the opposite as well?

      Andrew
