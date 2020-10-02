Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD66281579
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388190AbgJBOmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388179AbgJBOmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:42:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B71C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 07:42:37 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOMGQ-00FI2p-Nl; Fri, 02 Oct 2020 16:42:26 +0200
Message-ID: <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Date:   Fri, 02 Oct 2020 16:42:09 +0200
In-Reply-To: <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
         <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 07:40 -0700, Jakub Kicinski wrote:

> > I suppose you could make an argument that only some attrs might be
> > accepted in doit and somewhat others in dumpit, or perhaps none in
> > dumpit because filtering wasn't implemented?
> 
> Right? Feels like it goes against our strict validation policy to
> ignore input on dumpit.
> 
> > But still ... often we treat filtering as "advisory" anyway (except
> > perhaps where there's no doit at all, like the dump_policy thing here),
> > so it wouldn't matter if some attribute is ending up ignored?
> 
> It may be useful for feature discovery to know if an attribute is
> supported.

Fair point.

> I don't think it matters for any user right now, but maybe we should
> require user space to specify if they are interested in normal req
> policy or dump policy? That'd give us the ability to report different
> ones in the future when the need arises.

Or just give them both? I mean, in many (most?) cases they're anyway
going to be the same, so with the patches I posted you could just give
them the two different policy indexes, and they can be the same?

But whichever, doesn't really matter much.

johannes

