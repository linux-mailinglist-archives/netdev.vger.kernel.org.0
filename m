Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67F22BC11F
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 18:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgKURjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 12:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgKURjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 12:39:43 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA87C0613CF;
        Sat, 21 Nov 2020 09:39:43 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kgWrG-00C5aP-26; Sat, 21 Nov 2020 18:39:34 +0100
Message-ID: <36507863a9d9a7189b7b3b3d46313299969deea7.camel@sipsolutions.net>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Florian Westphal <fw@strlen.de>, Ido Schimmel <idosch@idosch.org>
Cc:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Date:   Sat, 21 Nov 2020 18:39:32 +0100
In-Reply-To: <20201121165227.GT15137@breakpoint.cc>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
         <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
         <20201121160941.GA485907@shredder.lan>
         <20201121165227.GT15137@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-21 at 17:52 +0100, Florian Westphal wrote:
> 
> Aleksandr, why was this made into an skb extension in the first place?
> 
> AFAIU this feature is usually always disabled at build time.
> For debug builds (test farm /debug kernel etc) its always needed.
> 
> If thats the case this u64 should be an sk_buff member, not an
> extension.

Because it was requested :-)

https://lore.kernel.org/netdev/20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

johannes

