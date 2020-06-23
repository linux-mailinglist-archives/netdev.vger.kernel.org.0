Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0164D2066E4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388707AbgFWWGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:06:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:46334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388171AbgFWWGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 18:06:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6A96AE19;
        Tue, 23 Jun 2020 22:06:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BB43A6046D; Wed, 24 Jun 2020 00:06:50 +0200 (CEST)
Date:   Wed, 24 Jun 2020 00:06:50 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
Message-ID: <20200623220650.kymq7vbqiogvnsj3@lion.mk-sys.cz>
References: <20200622205355.GA869719@tws>
 <32da6a56-0217-acda-c12c-49f7c74275ef@gmail.com>
 <3230b95a-1ce0-b569-3d00-f7063ae9f1d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3230b95a-1ce0-b569-3d00-f7063ae9f1d9@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 01:30:29AM +0200, Oliver Herms wrote:
> 
> I'm encountering the issues due to cache entries that are created by 
> tnl_update_pmtu. However, I'm going to address that issue in another thread
> and patch.
> 
> As entries in the cache can be caused on many ways this should be fixed on the GC
> level.

Actually, not so many as starting with (IIRC) 4.2, IPv6 routing cache is
only used for exceptions (like PMTU), not for regular lookup results.

Michal
