Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477802A5ACD
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 00:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgKCXzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 18:55:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:41264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgKCXzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 18:55:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3A516ACE6;
        Tue,  3 Nov 2020 23:55:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EF49C60788; Wed,  4 Nov 2020 00:55:01 +0100 (CET)
Date:   Wed, 4 Nov 2020 00:55:01 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH ethtool] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201103235501.sw27v355z7f375k3@lion.mk-sys.cz>
References: <20201102184036.866513-1-idosch@idosch.org>
 <20201102225803.pcrqf6nhjlvmfxwt@lion.mk-sys.cz>
 <20201103142430.GA951743@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103142430.GA951743@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 04:24:30PM +0200, Ido Schimmel wrote:
> 
> I have the changes you requested here:
> https://github.com/idosch/ethtool/commit/b34d15839f2662808c566c04eda726113e20ee59
> 
> Do you want to integrate it with your nl_parse() rework or should I?

I pushed the combined series to

  https://git.kernel.org/pub/scm/linux/kernel/git/mkubecek/ethtool.git

as branch mk/master/advertise-all. I only ran few quick tests so far,
it's not submission ready yet.

First two patches are unrelated fixes found while testing, I'm going to
submit and push them separately. Third patch reworks nl_parser()
handling of multiple request messages as indicated in my previous mail.
Fourth patch is the ioctl compatibility fix.

Michal
