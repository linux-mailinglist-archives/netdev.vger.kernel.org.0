Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B985AD8C7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 20:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiIESFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 14:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIESFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 14:05:22 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6A648CA5;
        Mon,  5 Sep 2022 11:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=z8jf+PP5vcdgak6uTtp2D0X66cnyXeaQf4ShUd/j6cI=;
        t=1662401121; x=1663610721; b=lGPrekkSEJkM1LRezVvLKAP87LWwzFtFOARR6fYwjQMb/N2
        4Lf+1iUXbtBC4gx1JbCP9fB0xm9iut88yH5qK88TOa4wOwJPcGncjvAKDckQhVUJoFdQdKO5lWP89
        5+C5iXR1tt2C7bqnSLWi4UpxoDZt9p3NR1ayL2EwpcMEo/DEqrdDaEZO1cSjkLch5emmMUlk86918
        ayxqJFZ0hJYE5NLQmqOqo1c7FT5Syf5hwFFq9UyCMRZwCPr69FYaOrFyPr5hxiKWoyteIXjXgXxe1
        SkWyjeKMP1aWPUKHpsRhaCGjG4rIgY0nd72liigI7umbXpi9jBZOYLiPeFGxgKyA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oVGTA-008ewh-29;
        Mon, 05 Sep 2022 20:05:12 +0200
Message-ID: <e4b31ef5ca8c846a84609c546fc5df4f93044741.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: don't spam logs with NSS>2 messages
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, gregory.greenman@intel.com
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Mon, 05 Sep 2022 20:05:11 +0200
In-Reply-To: <87h71ld8lg.fsf@kernel.org>
References: <20220905172246.105383-1-Jason@zx2c4.com>
         <87h71ld8lg.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 20:39 +0300, Kalle Valo wrote:
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>=20
> > I get a log line like this every 4 seconds when connected to my AP:
> >=20
> > [15650.221468] iwlwifi 0000:09:00.0: Got NSS =3D 4 - trimming to 2
> >=20
> > Looking at the code, this seems to be related to a hardware limitation,
> > and there's nothing to be done. In an effort to keep my dmesg
> > manageable, downgrade this error to "debug" rather than "info".
> >=20
> > Cc: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>=20
> Gregory, can I take this directly to wireless tree for v6.0?
>=20
We have an identical patch in our tree that I wrote a while ago, just
hasn't made it out ... I guess you can :)

johannes
