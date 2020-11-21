Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01C32BC228
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgKUU6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 15:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgKUU6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 15:58:51 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFB0C0613CF;
        Sat, 21 Nov 2020 12:58:51 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kgZxu-00CAJ8-TN; Sat, 21 Nov 2020 21:58:39 +0100
Message-ID: <86c6369a937c760e374c78f5252ffc67cf67b1e1.camel@sipsolutions.net>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Ido Schimmel <idosch@idosch.org>,
        Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        davem@davemloft.net, edumazet@google.com, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Date:   Sat, 21 Nov 2020 21:58:37 +0100
In-Reply-To: <20201121125508.4d526dd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
         <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
         <20201121160941.GA485907@shredder.lan>
         <20201121165227.GT15137@breakpoint.cc>
         <20201121100636.26aaaf8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <bcfb0fe1b207d2f4bb52f0d1ef51207f9b5587de.camel@sipsolutions.net>
         <20201121103529.4b4acbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <106fc65f0459bc316e89beaf6bd71e823c4c01b7.camel@sipsolutions.net>
         <20201121125508.4d526dd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-21 at 12:55 -0800, Jakub Kicinski wrote:
> [snip]
> Ack, you have to figure out all the places anyway, the question is
> whether you put probes there or calls in the source code.
> 
> Shifting the maintenance burden but also BPF is flexibility.

Yeah, true. Though I'd argue also visibility - this stuff is pretty
simple now, if it gets into lots of lines of BPF code to track it that
is maintained "elsewhere", we won't see the bugs in it :-)

And it's kinda a thing that we as kernel developers _should_ be the ones
looking at since it's testing our code.

> Yup, the point is you can feed a raw skb pointer (and all other
> possible context you may want) to a BPF prog in kcov_remote_start() 
> and let BPF/BTF give you the handle it recorded in its maps.

Yeah, it's possible. Personally, I don't think it's worth the
complexity.

> It is more complicated. We can go back to an skb field if this work is
> expected to yield results for mac80211. Would you mind sending a patch?

I can do that, but I'm not going to be able to do it now/tonight (GMT+1
here), so probably only Monday/Tuesday or so, sorry.

johannes

