Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C18678190
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 17:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjAWQfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 11:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjAWQfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 11:35:52 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BD02B2A3;
        Mon, 23 Jan 2023 08:35:50 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id BDCBD240007;
        Mon, 23 Jan 2023 16:35:43 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:BONDING DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bonding: Fix full name of the GPL
Date:   Mon, 23 Jan 2023 17:35:29 +0100
Message-ID: <13026035.HZuavB1mZQ@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <20230122194201.61105-1-didi.debian@cknow.org>
References: <20230122194201.61105-1-didi.debian@cknow.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3462809.QUY0Gc0ynl";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3462809.QUY0Gc0ynl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Subject: Re: [PATCH] bonding: Fix full name of the GPL
Date: Mon, 23 Jan 2023 17:35:29 +0100
Message-ID: <13026035.HZuavB1mZQ@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <20230122194201.61105-1-didi.debian@cknow.org>
References: <20230122194201.61105-1-didi.debian@cknow.org>
MIME-Version: 1.0

On Sunday, 22 January 2023 20:42:01 CET Diederik de Haas wrote:
>   *     This software may be used and distributed according to the terms
> - *     of the GNU Public License, incorporated herein by reference.
> + *     of the GNU General Public License, incorporated herein by reference.

Please ignore this patch.
I now think that I would be changing the license and I'm not qualified to do 
so. See https://lore.kernel.org/lkml/2281101.Yu7Ql3qPJb@prancing-pony/

Apologies for the noise.

Diederik
--nextPart3462809.QUY0Gc0ynl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY863UQAKCRDXblvOeH7b
bjOlAP9aarpsOSDJOBTjIrk9L0lW6Mlx6QgWhaaEcMmt0Jx4qQD/YKsalq/C9+nb
is1nKVvt2RXKMlOc0I9xYSGBw8XJeQ0=
=/+Vf
-----END PGP SIGNATURE-----

--nextPart3462809.QUY0Gc0ynl--



