Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25092815E9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388175AbgJBO6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387893AbgJBO6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:58:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C261C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 07:58:38 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOMW4-00FIVM-5W; Fri, 02 Oct 2020 16:58:36 +0200
Message-ID: <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Date:   Fri, 02 Oct 2020 16:58:33 +0200
In-Reply-To: <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
         <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
         <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > Or just give them both? I mean, in many (most?) cases they're anyway
> > going to be the same, so with the patches I posted you could just give
> > them the two different policy indexes, and they can be the same?
> 
> Ah, I missed your posting!

Huh, I even CC'ed you I think?

https://lore.kernel.org/netdev/20201002090944.195891-1-johannes@sipsolutions.net/t/#u

and userspace:

https://lore.kernel.org/netdev/20201002102609.224150-1-johannes@sipsolutions.net/t/#u

>  Like this?
> 
> [OP_POLICY]
>    [OP]
>       [DO]   -> u32
>       [DUMP] -> u32

Yeah, that'd work. I'd probably wonder if we shouldn't do

[OP_POLICY]
  [OP] -> (u32, u32)

in a struct with two u32's, since that's quite a bit more compact.

I did only:

[OP_POLICY]
  [OP] -> u32

johannes

