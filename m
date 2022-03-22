Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4AF4E3927
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 07:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiCVGpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 02:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237033AbiCVGpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 02:45:34 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123DC53B55
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 23:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=bhAaAoHzDrHU3De5X0RjnAUGIT+O
        wJfzwQ5eF0K/cVQ=; b=O1PKZFbygdvZvUPjWOql2HeAuNmG+Mqzue+CrPt+BXKJ
        k+GX/2eEhNr6I7MDSJy99FdhNAeg6ArjWNMTC/3LJJSOSY6oY6OQ4/xGOvEwwF66
        f8G+ucaN20R3cPf3ZJ8WmSkaK7+cNqNO1H9eQ570kLH1nvWceNuF9eAbQMRA+yY=
Received: (qmail 1202223 invoked from network); 22 Mar 2022 07:44:02 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 22 Mar 2022 07:44:02 +0100
X-UD-Smtp-Session: l3s3148p1@O7gT8MjaPpQgAQnoAGKBAM/VPJLYEVe1
Date:   Tue, 22 Mar 2022 07:43:59 +0100
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
Message-ID: <YjlwLzxxxR1QIpDK@ninjato>
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
        protocol="application/pgp-signature"; boundary="WMfMF+E/rJD23w9V"
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


--WMfMF+E/rJD23w9V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I tested it with my Renesas boards, so far no regressions. Buildbots are
> currently checking the series.

Update: buildbots are happy \o/


--WMfMF+E/rJD23w9V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmI5cCsACgkQFA3kzBSg
Kbau+Q//bVoc4SoG8It5AVIpQdUks3DAupSbmrT8ebI7arPQCFlUV7n9abCA3RZW
aH9m01itrfZ7TWxSJ2gUp4VR49LlweNqQEcyo/TEkzfZ558St7Wu8pRV9rPfEleo
v310K9zePQwzipMwNJ1htVYvN6wapEoromv45gj//La15GSw3pc8GJxSZBp+AxHa
VaeazFG6z9uAL3MGjpTwU8cEu4vWZFP8txloEVXTtT7iRu26H9/x/Rrmu+8xuchk
ReGG2mn/rAMo3JAzEJvvempkzHSUpjnMq2kDYOqqYvGT8yRGjVcEMSSjp5bVKevz
vi9zIkfJ8Q+Q/oXSC1jOFP7y98lXv8mIOyPlnHev6KhIZMGVooNWDFpnJqPAaTa7
HU8mQ1IEqoNsZ7/OCdCliRZGQG5NL0XJDGyxcZyBoUSiAvegDlh8v17A5ukm/jBS
eWGHjajY/McPxd8LM78WOANF0sQD5Adiyhrx1U5gStqWRYrVE5ppRig38LvSQ3ZH
GOg3rN2Jfjq/PJv38Ykow9fv4TPIywy/UlZuVGpt3GlqcN1rNojffDYTzbKCPUwX
83cEyZW4/ngtKZf6scgipsHntN7WDQ/xbSWDHb7uZux/x+cIsZuKQiHB61mqecwa
k1BwoutPwvyQkK9gHC3hlPEDa+S5CRl5NIQlnPkB1Fic4C1/S1k=
=nk9X
-----END PGP SIGNATURE-----

--WMfMF+E/rJD23w9V--
