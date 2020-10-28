Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF92029DBD3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390751AbgJ2ANI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50724 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390746AbgJ2ANH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXa7L-003uJM-3Z; Wed, 28 Oct 2020 02:19:11 +0100
Date:   Wed, 28 Oct 2020 02:19:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH net-next] net: ceph: Fix most of the kerneldoc warings
Message-ID: <20201028011911.GA931318@lunn.ch>
References: <20201028005907.930575-1-andrew@lunn.ch>
 <20201027180908.49885105@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027180908.49885105@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 06:09:08PM -0700, Jakub Kicinski wrote:
> On Wed, 28 Oct 2020 01:59:07 +0100 Andrew Lunn wrote:
> > net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oid' not described in 'ceph_cls_break_lock'
> > net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oloc' not described in 'ceph_cls_break_lock'
> > ...
> 
> I think this will be for Ilya and Jeff to pick up. Doesn't seem
> particularly network-centric.

Hi Jakub

I want with what get_maintainers said:

$ ./scripts/get_maintainer.pl 0001-net-ceph-Fix-most-of-the-kerneldoc-warings.patch 
Ilya Dryomov <idryomov@gmail.com> (supporter:CEPH COMMON CODE (LIBCEPH),commit_signer:2/3=67%)
Jeff Layton <jlayton@kernel.org> (supporter:CEPH COMMON CODE (LIBCEPH))
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
"Gustavo A. R. Silva" <gustavoars@kernel.org> (commit_signer:1/3=33%,authored:1/3=33%,removed_lines:1/3=33%)
Andrew Lunn <andrew@lunn.ch> (commit_signer:1/3=33%,authored:1/3=33%,added_lines:20/22=91%,removed_lines:1/3=33%)
"Alexander A. Klimov" <grandmaster@al2klimov.de> (commit_signer:1/3=33%,authored:1/3=33%,removed_lines:1/3=33%)
ceph-devel@vger.kernel.org (open list:CEPH COMMON CODE (LIBCEPH))
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

But i did miss ceph-devel@vger.kernel.org :-(

    Andrew
