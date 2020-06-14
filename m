Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6EB1F8B4D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgFNX0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:26:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:57692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgFNX0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 19:26:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DF440AE65;
        Sun, 14 Jun 2020 23:26:11 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8A0A3603CB; Mon, 15 Jun 2020 01:26:07 +0200 (CEST)
Date:   Mon, 15 Jun 2020 01:26:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
Message-ID: <20200614232607.itigyaqamm5sql63@lion.mk-sys.cz>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
 <20200610115350.wyba5rnpuavkzdl5@lion.mk-sys.cz>
 <b7c7634e-8912-856a-9590-74bd3895d1ed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7c7634e-8912-856a-9590-74bd3895d1ed@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 12:35:30AM +0200, Heiner Kallweit wrote:
> Seems that disabling ETHTOOL_NETLINK for PHYLIB=m has (at least) one
> more side effect. I just saw that ifconfig doesn't report LOWER_UP
> any longer. Reason seems to be that the ioctl fallback supports
> 16 bits for the flags only (and IFF_LOWER_UP is bit 16).
> See dev_ifsioc_locked().

I don't think this is related to CONFIG_ETHTOOL_NETLINK; AFAIK ifconfig
does not use netlink at all and device flags are certainly not passed
via ethtool netlink.

Michal
