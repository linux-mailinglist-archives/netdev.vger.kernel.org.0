Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768DD11AD1D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 15:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfLKONg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 09:13:36 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55158 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfLKONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 09:13:36 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1if2k6-004C7H-6n; Wed, 11 Dec 2019 15:13:30 +0100
Message-ID: <e65574ac1bb414c9feb3d51e5cbd643c2907b221.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Steve French <smfrench@gmail.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 11 Dec 2019 15:13:29 +0100
In-Reply-To: <87o8wfeyx5.fsf@toke.dk>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         <d4a48cbdc4b0db7b07b8776a1ee70b140e8a9bbf.camel@sipsolutions.net>
         <87o8wfeyx5.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-12-11 at 15:09 +0100, Toke Høiland-Jørgensen wrote:
> 
> If we're doing this on a per-driver basis, let's make it a proper
> NL80211_EXT_FEATURE and expose it to userspace; that way users can at
> least discover if it's supported on their device. I can send a patch
> adding that...

Sure. Just didn't get to that yet, but if you want to send a patch
that's very welcome. I have to run out now, will be back in the evening
at most.

> Maybe we should untangle this from airtime_flags completely, since if we
> just use the flags people could conceivably end up disabling it by
> mistake, couldn't they?

Yes, that sounds like a good plan, now I was wondering why it's there
anyway.

johannes

