Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C66D1D641F
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 23:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgEPVNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 17:13:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:48376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgEPVNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 May 2020 17:13:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9A107AC7B;
        Sat, 16 May 2020 21:13:06 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 11CA060347; Sat, 16 May 2020 23:13:03 +0200 (CEST)
Date:   Sat, 16 May 2020 23:13:03 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kernel-team@fb.com
Subject: Re: [PATCH net-next 0/3] ethtool: set_channels: add a few more checks
Message-ID: <20200516211302.GA15101@lion.mk-sys.cz>
References: <20200515194902.3103469-1-kuba@kernel.org>
 <20200516.135658.485531358159506210.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516.135658.485531358159506210.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 01:56:58PM -0700, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Fri, 15 May 2020 12:48:59 -0700
> 
> > There seems to be a few more things we can check in the core before
> > we call drivers' ethtool_ops->set_channels. Adding the checks to
> > the core simplifies the drivers. This set only includes changes
> > to the NFP driver as an example.
> > 
> > There is a small risk in the first patch that someone actually
> > purposefully accepts a strange configuration without RX or TX
> > channels, but I couldn't find such a driver in the tree.
> 
> Series applied, thanks Jakub.
> 
> And for the record I accept logical 'or' of booleans as valid :-)

For the record, my point was that "|=" is a bitwise operator, not logical.

Michal
