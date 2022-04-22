Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41B250B29A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445462AbiDVIGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445460AbiDVIGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:06:45 -0400
X-Greylist: delayed 491 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 01:03:52 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FAA52E41;
        Fri, 22 Apr 2022 01:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1650614137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=FFj6+/K+6ijDBVy6GU0k6XitYfz7fo/RaeEwRuAByJ4=;
        b=hwcVhN6601PAIDsZN+Ji0A/wlk+AnYcRg99FBkeGflffJA7MRpJJgwXAv8suOG7bouq4K0
        pL595d9LsgxwqoOjOYTvVHg6XYmZXkMebHu9/9s5cfjPJ3u65hzjqU8iZuA31FuX89AXil
        n5/E5ypdRCuFHd0KoeVVR29oAT4NX2g=
From:   Sven Eckelmann <sven@narfation.org>
To:     yuzhe@nfschina.com
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kernel-janitors@vger.kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, pabeni@redhat.com, sven@narfation.org,
        sw@simonwunderlich.de
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
Date:   Fri, 22 Apr 2022 09:55:34 +0200
Message-ID: <3537486.13E77TLkhO@ripper>
In-Reply-To: <20220421154829.9775-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3059673.4202UCAtWU"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3059673.4202UCAtWU
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: yuzhe@nfschina.com
Cc: a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net, kernel-janitors@vger.kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, liqiong@nfschina.com, mareklindner@neomailbox.ch, netdev@vger.kernel.org, pabeni@redhat.com, sven@narfation.org, sw@simonwunderlich.de
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
Date: Fri, 22 Apr 2022 09:55:34 +0200
Message-ID: <3537486.13E77TLkhO@ripper>
In-Reply-To: <20220421154829.9775-1-yuzhe@nfschina.com>

Hi,

we neither received your mail via the mailing list nor our private mail 
servers. It seems your mail setup is broken:

    Apr 21 15:48:37 dvalin postfix/smtpd[10256]: NOQUEUE: reject: RCPT from unknown[2400:dd01:100f:2:72e2:84ff:fe10:5f45]: 450 4.7.1 <ha.nfschina.com>: Helo command rejected: Host not found; from=<yuzhe@nfschina.com> to=<sven@narfation.org> proto=ESMTP helo=<ha.nfschina.co>


And when I test it myself, it is also not working:

    $ dig @8.8.8.8 ha.nfschina.com

    ; <<>> DiG 9.16.27-Debian <<>> @8.8.8.8 ha.nfschina.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 39639
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
    
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 512
    ;; QUESTION SECTION:
    ;ha.nfschina.com.               IN      A
    
    ;; AUTHORITY SECTION:
    nfschina.com.           600     IN      SOA     dns11.hichina.com. hostmaster.hichina.com. 2022011002 3600 1200 86400 600

    ;; Query time: 328 msec
    ;; SERVER: 8.8.8.8#53(8.8.8.8)
    ;; WHEN: Fri Apr 22 09:51:56 CEST 2022
    ;; MSG SIZE  rcvd: 105


Please fix this before sending patches out.


But the kernel test bot already demonstrated why this patch is not a good 
idea. You can improve it and resent it but I will not accept it in this form.


Kind regards,
	Sven
--nextPart3059673.4202UCAtWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmJiX3YACgkQXYcKB8Em
e0Y0dQ/+NFnsxqJsaMC0zYzt5WK1JDVmpYneRZuoEf62CIsbpN+AtGouyHyqpRQA
UBOK4KaKDKL/iUTAz9m6kJ7k65RxnE9/WnwJaEbY1JNzn0V7mhxJOEarZrjjcz1J
R4MVT/l/vQHDhcGWwX0l4YHkXiUDjtmT1SripHZGouhOoxW/yCg7MPGDsIHNCWBw
Nj3kqClxRhwp+MExsKxmylX6EnIlOxO3Z5gtk848BaDgvpatjJkAxRDmpuxvDFn/
QTm70eQ5mLV/B2E5aZSH1IfYB77n9upt9PGp/r3FSwaUJaCBMPTyK6iDGG7fiwym
GlJhzoagbtr2zy8GlFWTFJKcTFt6uwhl1yRqQ37BTWVB86oFEp9pB2d+1J14m3gK
1+MjhWhfVN5Q8SALqpIZl5ms9grA+R1+SAW95mvdRitYgIqSpQt5+aLuelHiJMu0
fKgHOBQPabaFdTv973KAZP24lQTTOnkXQGPSbKRFzXperFql1sy7Rm+ZxUi4HmbS
HbUm9dApMdPpv+h/km0LKOnyca4c5ZPXXrY7iI9Y/lSevPSgQD8M8YtcV64kkAn7
s73LFpzveIGz/ITKycpOhGeWVJQRDKndJiZIQLJTfAGiy8P9SUeo+2I3fYT69lkb
y+z5SmMz1RBBXRmLhy6OiCe6xajWe/gQ82SN74O0uRthjQIX8dQ=
=yYih
-----END PGP SIGNATURE-----

--nextPart3059673.4202UCAtWU--



