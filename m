Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF39149F40
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 08:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgA0HbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 02:31:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:37248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgA0HbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 02:31:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7904DAC37;
        Mon, 27 Jan 2020 07:30:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B0272E0B78; Mon, 27 Jan 2020 08:30:55 +0100 (CET)
Date:   Mon, 27 Jan 2020 08:30:55 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] ethtool netlink interface, part 2
Message-ID: <20200127073055.GD570@unicorn.suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <20200126233448.GA12816@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126233448.GA12816@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 12:34:48AM +0100, Andrew Lunn wrote:
> On Sun, Jan 26, 2020 at 11:10:58PM +0100, Michal Kubecek wrote:
> > This shorter series adds support for getting and setting of wake-on-lan
> > settings and message mask (originally message level). Together with the
> > code already in net-next, this will allow full implementation of
> > "ethtool <dev>" and "ethtool -s <dev> ...".
> 
> Hi Michal
> 
> It is nice to see more of this work being posted. But what about the
> user space side? Do you plan to post that soon?

Yes, once I get it into presentable shape. I definitely want ethtool 5.6
to support what kernel 5.6 will.

Michal
