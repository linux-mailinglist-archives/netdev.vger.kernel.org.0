Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D09E280D77
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 08:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgJBG3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 02:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBG3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 02:29:31 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6B4C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 23:29:31 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOEZM-00F5Qq-St; Fri, 02 Oct 2020 08:29:29 +0200
Message-ID: <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Fri, 02 Oct 2020 08:29:27 +0200
In-Reply-To: <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 17:36 -0700, Jakub Kicinski wrote:
> On Thu,  1 Oct 2020 15:59:23 -0700 Jakub Kicinski wrote:
> > Hi!
> > 
> > The objective of this series is to dump ethtool policies
> > to be able to tell which flags are supported by the kernel.
> > Current release adds ETHTOOL_FLAG_STATS for dumping extra
> > stats, but because of strict checking we need to make sure
> > that the flag is actually supported before setting it in
> > a request.
> 
> Do we need support for separate .doit and .dumpit policies?
> Or is that an overkill?

I suppose you could make an argument that only some attrs might be
accepted in doit and somewhat others in dumpit, or perhaps none in
dumpit because filtering wasn't implemented?

But still ... often we treat filtering as "advisory" anyway (except
perhaps where there's no doit at all, like the dump_policy thing here),
so it wouldn't matter if some attribute is ending up ignored?

johannes

