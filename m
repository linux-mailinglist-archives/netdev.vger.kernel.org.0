Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E795CAA4A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405513AbfJCRCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:02:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:55460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405817AbfJCRCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 13:02:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD122B230;
        Thu,  3 Oct 2019 17:02:51 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1F7ACE04C7; Thu,  3 Oct 2019 19:02:51 +0200 (CEST)
Date:   Thu, 3 Oct 2019 19:02:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>, sameehj@amazon.com,
        davem@davemloft.net, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V2 net-next 5/5] net: ena: ethtool: support set_channels
 callback
Message-ID: <20191003170251.GI24815@unicorn.suse.cz>
References: <20191002082052.14051-1-sameehj@amazon.com>
 <20191002082052.14051-6-sameehj@amazon.com>
 <20191002131132.7b81f339@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002131132.7b81f339@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 01:11:32PM -0700, Jakub Kicinski wrote:
> On Wed, 2 Oct 2019 11:20:52 +0300, sameehj@amazon.com wrote:
> > +
> > +	new_channel_count = clamp_val(channels->tx_count,
> > +				      ENA_MIN_NUM_IO_QUEUES, channels->max_tx);
> 
> You should return an error if the value is not within bounds, rather
> than guessing.

And ethtool_set_channels() already does that if any of the requested
counts exceeds the corresponding maximum so that the upper bound check
here is superfluous.

Michal
