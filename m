Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EECE4EF838
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348653AbiDAQn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350448AbiDAQng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:43:36 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD62314FB92
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 09:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=AcBPC6b8Ow54uIrFRglU9gzXaSUC
        Q4cd7DaZDtjcLyQ=; b=Tep0sd+ZQs/pV7W17OP62Su2NA/HIveSPhneZhKmB3yr
        EFlsmnQ5J+3HzyhQ8LEt7EK1iocP9C2nrggkVq47g0R2v2ipR57zJ83uApFUonar
        qZ9hKdd71rBIwi6WhnPuU9lacp/q/XseyT093J/wJcxudPOdGVdA1ORY6mfVvpY=
Received: (qmail 801843 invoked from network); 1 Apr 2022 18:25:03 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 1 Apr 2022 18:25:03 +0200
X-UD-Smtp-Session: l3s3148p1@tUKLOJrbdqYgAQnoAGGbAFirbAEmXd1u
Date:   Fri, 1 Apr 2022 18:25:03 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-mmc@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [RFC PATCH 00/10] mmc: improve API to make clear {h|s}w_reset is
 for cards
Message-ID: <YkcnXxNjMNdDgEBt@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-mmc@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        SHA-cyfmac-dev-list@infineon.com
References: <20220321115059.21803-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PxhwHXhOFLOXfgmr"
Content-Disposition: inline
In-Reply-To: <20220321115059.21803-1-wsa+renesas@sang-engineering.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PxhwHXhOFLOXfgmr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I tested it with my Renesas boards, so far no regressions. Buildbots are

Wishful thinking, the patches crash now when booting. Still checking
what is the difference to when I send the patches out.

Still, looking forward to comments on the general approach.


--PxhwHXhOFLOXfgmr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmJHJ1oACgkQFA3kzBSg
KbYPGw//YUU0c/TCXVii8TbBtVaxFJ+SFYjCQiY3RhhVPIrWlCF7+1v7BKyWdqz+
I/ctuhs3uUutw1dE3/WI12HevWANnVdw6EI8D0+aJOrxaCfMueJpEugMYguwpk8t
ZWB8Kh+8Lozg55uOn7i4byGA5UThrrbV9k6/IwKnfbGS+fKUVWL9uJxMKssYx0uM
ZjgVIKF0bSg0As+UuQBiFhKqJQybnBa27DHtl1n8Co3zX79M5T//aB/SvLbeyyKM
MhsVF3xd7LxdWDVTkXEdjQqVtApNlGAp9+2iYdb86V0dd+hz0PWO9Acp9VB2ZOEv
OcIhc8r0iExSdFITQeSevS5LdnRhyxv8mA0K4pS2ndbIPwut0dmHSSU4PnseFcAy
khFA8jDujq1jz83z0ucAlCsr3U/u0Yrb7CGyLA3zKTCP05RLvPsbAxyymT2EOfen
S9+LsJhEXiQ2KstNsFqWch/PebTxMkyrVvCo+US+HhCsDTP01WvqxwtC0TkB69Zk
cjVeDWo5QkggA1nYKPntr9OIyqeHCmowWHW+2V4zmWAgI1qodhPfQnFsUuzwbbXy
j8cavhOoe3ZKwLeH5X1gP0mOClgbRWFEzOBEFq2W94rLvt8gMp85Md8l2Y1MMUO2
5byHakN0xAIFBbcv+tGO6SAK9ld3vFtWIoPtyYHnDKjmKQwU1GE=
=v18S
-----END PGP SIGNATURE-----

--PxhwHXhOFLOXfgmr--
