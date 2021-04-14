Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3EA35F740
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242680AbhDNPKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhDNPKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:10:19 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE71FC061574;
        Wed, 14 Apr 2021 08:09:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lWh9O-00BgYI-5w; Wed, 14 Apr 2021 17:09:54 +0200
Message-ID: <d919fd21c36bd72955ff18190fe628eae438b098.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: indicate support for 60GHz channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Date:   Wed, 14 Apr 2021 17:09:53 +0200
In-Reply-To: <CAK8U23ZXs1LYFXaXKmNfT3M4yXPGhoGoFNh4r4G45YaMHtU-Xg@mail.gmail.com> (sfid-20210414_170712_484139_3E38AB65)
References: <20210413010613.50128-1-ramonreisfontes@gmail.com>
         <4d0a27c465522ddd8d6ae1e552221c707ec05b22.camel@sipsolutions.net>
         <CAK8U23ZXs1LYFXaXKmNfT3M4yXPGhoGoFNh4r4G45YaMHtU-Xg@mail.gmail.com>
         (sfid-20210414_170712_484139_3E38AB65)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-14 at 12:06 -0300, Ramon Fontes wrote:
> > Advertise 60GHz channels to mac80211.
> Oh.. That was a mistake. Sorry for that.
> 
> Anyway, can we indicate 60GHz support even though it is not being
> supported by mac80211 yet?
> 
No, that makes no sense. DMG operation is significantly different from
non-DMG operation, even the A-MSDU format for example (an abbreviated
format called "short A-MSDU" is used in DMG). Similarly beacons, etc.,
all kinds of operations are significantly different.

Adding 60 GHz channels to hwsim would be essentially operating as non-
DMG yet on a DMG channel, which makes no sense.

I don't think anyone's planning to add DMG support to mac80211, and in
the absence of a real driver requiring that it wouldn't make sense
anyway. Quite possibly, it simply doesn't make sense period, because DMG
operation is sufficiently different.

johannes

