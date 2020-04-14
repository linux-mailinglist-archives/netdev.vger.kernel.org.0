Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502A41A8EC3
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgDNWuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:50:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:55808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633677AbgDNWuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 18:50:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F3575AE2D;
        Tue, 14 Apr 2020 22:50:09 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B92EDE16A6; Wed, 15 Apr 2020 00:50:09 +0200 (CEST)
Date:   Wed, 15 Apr 2020 00:50:09 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Edward Cree <ecree@solarflare.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200414225009.GX3141@unicorn.suse.cz>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414173718.GE1011271@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414173718.GE1011271@unreal>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:37:18PM +0300, Leon Romanovsky wrote:
> 
> The autoselection process works good enough for everything outside
> of netdev community.

That's very far from true. I have seen and heard many complaints about
AUTOSEL and inflation of stable trees in general, both in private and in
public lists. It was also discussed on Kernel Summit few times - with
little success.

Just for fun, I suggest everyone to read first section of
Documentation/process/stable-kernel-rules.rst and compare with today's
reality. Of course, rules can change over time but keeping that document
in kernel tree as a memento is rather sad - I went through the rules now
and there are only three which are not broken on a regular basis these
days.

Michal Kubecek
