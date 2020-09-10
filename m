Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E13C264E58
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgIJTLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgIJTLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 15:11:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02F4721556;
        Thu, 10 Sep 2020 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599765060;
        bh=vRhytxH+ZPybmOhxpa6GnqyOansdyJrmFGZEgGAE3uA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CtgVHrsymdneso6ij45KQJVvfWSOaJHYzy9GemKiY5sXW0i9fNm2zfiiU8RUQh2MF
         P3p+vCBB1RkmzUGUkb3XPQq+/LmbTIZKQmY/3fmy4cs352AEJ1md+oEJGa1W8YdRv8
         GDWACyeHc4jPcFwaBqwzm8s/BT0yXLQ7sTzwCNEM=
Date:   Thu, 10 Sep 2020 12:10:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] tunnels: implement new --show-tunnels command
Message-ID: <20200910121058.2be67e06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910101605.ivuohkkgnt4hi5qs@lion.mk-sys.cz>
References: <20200909221811.410014-1-kuba@kernel.org>
        <20200910101605.ivuohkkgnt4hi5qs@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 12:16:05 +0200 Michal Kubecek wrote:
> On Wed, Sep 09, 2020 at 03:18:11PM -0700, Jakub Kicinski wrote:
> > Add support for the new show-tunnels command. Support dump.
> > 
> >  # ethtool --show-tunnels \*
> > Tunnel information for eth0:
> >   UDP port table 0:
> >     Size: 4
> >     Types: vxlan
> >     No entries
> >   UDP port table 1:
> >     Size: 4
> >     Types: geneve, vxlan-gpe
> >     Entries (2):
> >         port 1230, vxlan-gpe
> >         port 6081, geneve
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> The patch looks good except for one cosmetic issue below. But you will
> need to update the uapi header copies first to get the new constants.
> You can use the script at the end of this mail.

Thanks! I wasn't sure if you sync yourself, like iproute2 folks do.
Now I know :)
