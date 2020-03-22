Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2986718E9E0
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 16:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCVPsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 11:48:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:44582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgCVPsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 11:48:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9057FAAB8;
        Sun, 22 Mar 2020 15:48:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DF80CE0FD3; Sun, 22 Mar 2020 16:48:11 +0100 (CET)
Date:   Sun, 22 Mar 2020 16:48:11 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] ethtool: remove XCVR_DUMMY entries
Message-ID: <20200322154811.GC31519@unicorn.suse.cz>
References: <44908ff8-22dd-254e-16f8-f45f64e8e98e@gmail.com>
 <20200322140837.GG11481@lunn.ch>
 <731810bd-7e8f-8e34-304a-52e0f1286ba0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <731810bd-7e8f-8e34-304a-52e0f1286ba0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 03:45:22PM +0100, Heiner Kallweit wrote:
> On 22.03.2020 15:08, Andrew Lunn wrote:
> > A quick search found:
> > 
> > http://www.infradead.org/~tgr/libnl/doc/api/ethtool_8c_source.html
> > 
> I checked here http://git.infradead.org/users/tgr/libnl.git and there
> hasn't been such an ethtool.c file for ages.

I doubt it was ever part of the official libnl tree - and it certainly
never was in master branch of libnl git. It rather looks as part of an
old attempt at a netlink interface for ethtool (2010 or 2011, according
to the file banner).

Michal
