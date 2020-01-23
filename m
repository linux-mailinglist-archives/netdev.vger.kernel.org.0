Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB8D147244
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgAWUBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:01:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:41158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbgAWUBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 15:01:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7A6E7AC44;
        Thu, 23 Jan 2020 20:01:09 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 21F09E06F7; Thu, 23 Jan 2020 21:01:06 +0100 (CET)
Date:   Thu, 23 Jan 2020 21:01:06 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Luigi Rizzo <lrizzo@google.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net-core: remove unnecessary ETHTOOL_GCHANNELS
 initialization
Message-ID: <20200123200106.GU22304@unicorn.suse.cz>
References: <20200122223326.187954-1-lrizzo@google.com>
 <20200122234753.GA13647@lunn.ch>
 <CAMOZA0LiSV2WyzfHuU5=_g0Ru2z-osx0B-WkS-QHMaQeY4GXeA@mail.gmail.com>
 <20200123084000.GT22304@unicorn.suse.cz>
 <CAMOZA0L7+ugo7e=VeiGUc49fyNTxr0HmU4cuM8jHfRO3OMYuXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMOZA0L7+ugo7e=VeiGUc49fyNTxr0HmU4cuM8jHfRO3OMYuXw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 09:47:56AM -0800, Luigi Rizzo wrote:
> 
> For the same reason though (comply with the header) we might perhaps
> want to replace with cmd with ETHTOOL_SCHANNELS before actually
> calling dev->ethtool_ops->set_channels()
> 
> (I realize this is not particularly important)

That structure is filled by copy_from_user() and the structure passed by
userspace already has .cmd = ETHTOOL_SCHANNELS - otherwise we wouldn't
end up in ethtool_set_channels().

Michal
