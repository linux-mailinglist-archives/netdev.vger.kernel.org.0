Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD73A3631F3
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 21:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhDQTSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 15:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235234AbhDQTSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 15:18:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C30DC61210;
        Sat, 17 Apr 2021 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618687089;
        bh=efVUTuyorW+Kyua40egclS6VKMETllqOGSOKUOCpO60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ww0Y2hWhUP3s087DE+JIGmDNjGrHPWPzrCpSdDD2iKBOhGcd5L9joy7Xhv5MXLKLp
         rjQO+FsezIajuCrgpCb1x4H5gme9ZoOQOO0R2X0SMsDLQoW9OfrHNs2F/3bLWqgKD/
         0LjufxElIzVOAr8pROSFHpEdJzwqWBr/UuWTofRhEHwDBHF4oiiHLfMAISlciba7oK
         qKb3zPNHSVNi7IF/0WycE/ub6i0ATkC1944cQFsgnDqu1Z2TMx/p3ujyDaqen9DBYq
         gIOl7DM6HbUIOS7F9oPj14Msj7AjSIISeZKqVNCJnsgn4fqgMMFrWnXYSHdF76V7cF
         S/Jwc99fsQX6A==
Date:   Sat, 17 Apr 2021 12:18:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <20210417121808.593e221d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210417121520.242b0c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210416192745.2851044-1-kuba@kernel.org>
        <20210416192745.2851044-4-kuba@kernel.org>
        <YHsXnzqVDjL9Q0Bz@shredder.lan>
        <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YHsutM6vesbQq+Ju@shredder.lan>
        <20210417121520.242b0c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 12:15:20 -0700 Jakub Kicinski wrote:
> On Sat, 17 Apr 2021 21:53:40 +0300 Ido Schimmel wrote:
> > On Sat, Apr 17, 2021 at 11:13:51AM -0700, Jakub Kicinski wrote:  
> > > On Sat, 17 Apr 2021 10:57:42 -0700 Jakub Kicinski wrote:    
> > >
> > > FWIW ethnl_parse_bit() -> ETHTOOL_A_BITSET_BIT_NAME
> > > User space can also use raw flags like --groups 0xf but that's perhaps
> > > too spartan for serious use.    
> > 
> > So the kernel can work with ETHTOOL_A_BITSET_BIT_INDEX /
> > ETHTOOL_A_BITSET_BIT_NAME, but I was wondering if using ethtool binary
> > we can query the strings that the kernel will accept. I think not?  

Heh, I misunderstood your question. You're asking if the strings can be
queried from the command line.

No, I don't think so. We could add some form of "porcelain" command if
needed.
