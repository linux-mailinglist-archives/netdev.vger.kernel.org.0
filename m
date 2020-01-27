Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51BF14A558
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgA0Np2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:45:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgA0Np2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 08:45:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0YvuuddQXRFtGFHr5Vzl3DQnUflm7JmNEWkDCKIMtEg=; b=KPwjAsrl8gTlCr4BGCwXn2ZaSr
        EaA3gV7D4TFSA+GGpE4HVmtLRWTFsqt/IodsxVPPZhBIYhZj4hylNW565kI0xZGtsObCsFBiwjVN7
        hqOX67oQljqc/k715fHoByOBj4+8K6Y6cmmEWAakisakWYDs4uwQnzMd+FBk3docZWPs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iw4hY-0006UZ-Rt; Mon, 27 Jan 2020 14:45:16 +0100
Date:   Mon, 27 Jan 2020 14:45:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@redhat.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, f.fainelli@gmail.com, linville@tuxdriver.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] ethtool netlink interface, part 2
Message-ID: <20200127134516.GH12816@lunn.ch>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <20200127.104049.2252228859572866640.davem@davemloft.net>
 <20200127095744.GG570@unicorn.suse.cz>
 <20200127.113239.1283544245838356770.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127.113239.1283544245838356770.davem@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 11:32:39AM +0100, David Miller wrote:
> From: Michal Kubecek <mkubecek@suse.cz>
> Date: Mon, 27 Jan 2020 10:57:44 +0100
> 
> > On Mon, Jan 27, 2020 at 10:40:49AM +0100, David Miller wrote:
> >> From: Michal Kubecek <mkubecek@suse.cz>
> >> Date: Sun, 26 Jan 2020 23:10:58 +0100 (CET)
> >> 
> >> > This shorter series adds support for getting and setting of wake-on-lan
> >> > settings and message mask (originally message level). Together with the
> >> > code already in net-next, this will allow full implementation of
> >> > "ethtool <dev>" and "ethtool -s <dev> ...".
> >> > 
> >> > Older versions of the ethtool netlink series allowed getting WoL settings
> >> > by unprivileged users and only filtered out the password but this was
> >> > a source of controversy so for now, ETHTOOL_MSG_WOL_GET request always
> >> > requires CAP_NET_ADMIN as ETHTOOL_GWOL ioctl request does.
> >> 
> >> It looks like this will need to be respun at least once, and net-next
> >> is closing today so....
> > 
> > The problem with ethnl_parse_header() name not making it obvious that it
> > takes a reference is not introduced in this series, the function is
> > already in net-next so that it does not matter if this series is merged
> > or not. Other than that, there is only the missing "the" in
> > documentation.
> 
> Ok, looks good, series applied.

Yes, i don't see anything here which cannot be fixed up later. So i
agree with merging it.

      Andrew
