Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A273628185F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 18:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388111AbgJBQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 12:55:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:35290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387692AbgJBQzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 12:55:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 569F9B285;
        Fri,  2 Oct 2020 16:55:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C92F360787; Fri,  2 Oct 2020 18:55:01 +0200 (CEST)
Date:   Fri, 2 Oct 2020 18:55:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        dsahern@kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002165501.glpdxfjstpya3srj@lion.mk-sys.cz>
References: <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
 <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
 <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
 <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
 <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <db56057454ee3338a7fe13c8d5cc450b22b18c3b.camel@sipsolutions.net>
 <20201002082517.31e644ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002082517.31e644ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 08:25:17AM -0700, Jakub Kicinski wrote:
> On Fri, 02 Oct 2020 17:13:28 +0200 Johannes Berg wrote:
> > I suppose, I thought you wanted to change it to have separate dump/do
> > policies? Whatever you like there, I don't really care much :)
> 
> I just want to make the uAPI future-proof for now.
> 
> At a quick look ethtool doesn't really accept any attributes but
> headers for GET requests. DO and DUMP are the same there so it's 
> not a priority for me.

This is likely to change, for -x / --show-rxfh-indir / --show-rxfh we
will neeed to specify RSS context id. This is also an example where
different policy for doit and dumpit would make sense.

Michal
