Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13B5FDE07
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiJMQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJMQNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:13:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E00F36DCF;
        Thu, 13 Oct 2022 09:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=K+qxzC7p66uFYQQ6Ojc1Y4Vg7MiXPZ2xlKqgcyqWRt4=;
        t=1665677583; x=1666887183; b=ixBGhjI7GmKIqMKmkC4eYnecRfNZyjgAgqKq/qJlQ3sDNYt
        HjSmj6i3Uosp16JE+cVS6He8eRUdr46zjTxHJwQWKCSs0U6AQ3lFb7i6RBR24vIhiZCWfPXBF8wjN
        iO4xTI5u1Ip2WVLkUiM7qjND5f5cDwiQYyHSG8ckVcjjcd2cYhWMN3ryjd8gQIWCdWN4Rz+dooDIh
        /eD3IdstCxyBJxA0oiE/rb+1dbLDxcOmlqPjLQV6Q015DBgfvsAukArDSTe3gIW+JJMvoZjCHWz0E
        KI3J7CZLaIils62CCQNeOWvQMtsiUeHYVGnCZebZYjleeXpIdzdsOM5gkgpdgSZA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oj0pQ-005kO2-2y;
        Thu, 13 Oct 2022 18:13:01 +0200
Message-ID: <e012c43378b21fe9a9753d3d1a1f550df8de60a0.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-2022-10-13
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Thu, 13 Oct 2022 18:13:00 +0200
In-Reply-To: <20221013083254.5d302a5e@kernel.org>
References: <20221013100522.46346-1-johannes@sipsolutions.net>
         <20221013083254.5d302a5e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-13 at 08:32 -0700, Jakub Kicinski wrote:
> On Thu, 13 Oct 2022 12:04:51 +0200 Johannes Berg wrote:
> > Please pull and let me know if there's any problem.
>=20
> Since you asked if there are any problems... :)
>=20
> net/wireless/scan.c:1677:61: warning: incorrect type in argument 2 (diffe=
rent address spaces)
> net/wireless/scan.c:1677:61:    expected struct cfg80211_bss_ies const *n=
ew_ies
> net/wireless/scan.c:1677:61:    got struct cfg80211_bss_ies const [nodere=
f] __rcu *beacon_ies
>=20

Oh shoot, I had noticed this later and forgot about it ...

FWIW, it's harmless, but we do need to silence the sparse warning. I'll
add a follow-up patch for our next pull request, unless you want it
quickly, then I can send it to you directly?

johannes
