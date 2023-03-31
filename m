Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454006D1BD1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCaJSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjCaJSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:18:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6DAD50E;
        Fri, 31 Mar 2023 02:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=zICmNz0LQot+6Vmr74x/QKcyOggp99GsmNnVZkLk70M=;
        t=1680254296; x=1681463896; b=tWV8uw6eS4/j6uDZ0iKkQphz+UWm4mMGf3YYhxCqSLFa3x4
        GzDQ0o2iH3cKzkpXEz2JHKoZYkPK60pGtaVx0ALm4loHML3fyGM9YMT7mcHKKvQNfqh/gF5+uPbxi
        BTCX22p9US3lY8k4AmuL7wwh2QVN/+cC20+D8rSpVlAojTGOFiHI8Po82g8V8eyI3WG9hSX2fWc6r
        pqMBLoy/svgwZdBcp4v666GQs0IobgH+azv14U1b2qzH0Y8V7YsWovxVQA63mGZc6nn+RqEIsa3aD
        AhWYZFlk95QQF1jsBy5GtB8L6gPREFgzfBaYfhBrcn4lkC2sNSZ1Kvf+WW3usL2Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1piAtS-0029P5-1b;
        Fri, 31 Mar 2023 11:17:58 +0200
Message-ID: <51ccdfaee8deff0c172fafcec4bf427e8b54371e.camel@sipsolutions.net>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Date:   Fri, 31 Mar 2023 11:17:57 +0200
In-Reply-To: <20230331104959.0b30604d@canb.auug.org.au>
References: <20230331104959.0b30604d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-31 at 10:49 +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the wireless-next tree got a conflict in:
>=20
>   net/mac80211/rx.c
>=20
> between commit:
>=20
>   a16fc38315f2 ("wifi: mac80211: fix potential null pointer dereference")
>=20
> from the wireless tree and commit:
>=20
>   fe4a6d2db3ba ("wifi: mac80211: implement support for yet another mesh A=
-MSDU format")
>=20
> from the wireless-next tree.

Thanks for the heads-up. I sort of expected this, but didn't want to do
a merge or wireless into wireless-next before it was pulled, maybe I
should've staggered the pull requests, but you would've seen the merge
issue anyway.

Anyway, I've now pulled wireless into wireless-next, so you might
continue seeing this issue (*) if you merge net/net-next before merging
wireless-next, but it'll be completely resolved when we send the next
pull request to net-next (next week).

Thanks!

(*) and another one in nl80211 policy, I think?

joahnnes
