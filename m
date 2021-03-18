Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51879340FFC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhCRVmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:42:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhCRVkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:40:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lN0Nf-00BkhB-20; Thu, 18 Mar 2021 22:40:35 +0100
Date:   Thu, 18 Mar 2021 22:40:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH] net: check all name nodes in  __dev_alloc_name
Message-ID: <YFPI0ws/GrEa24SN@lunn.ch>
References: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 04:42:53AM +0100, Jiri Bohac wrote:
> __dev_alloc_name(), when supplied with a name containing '%d',
> will search for the first available device number to generate a
> unique device name.
> 
> Since commit ff92741270bf8b6e78aa885f166b68c7a67ab13a ("net:
> introduce name_node struct to be used in hashlist") network
> devices may have alternate names.  __dev_alloc_name() does take

Should this be "does not take"

> these alternate names into account, possibly generating a name
> that is already taken and failing with -ENFILE as a result.

  Andrew
