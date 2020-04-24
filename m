Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C550E1B76E5
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgDXNXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:23:34 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:39096 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgDXNXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 09:23:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1587734609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dsK2ZIMTYawZW9l36oBg+gPJG3DkvGU1qVhX0hUsVPI=;
        b=uwGMNuQsSER4UWN4htR+7CfFr0Sdy3lbMFcVVdD8vpAsLKR2LYLY90xrtkc2jP7YjnntS7
        Xx5nfiGPEwnQyJS0SEXXqht8dp7s8WUi2UulrQN5RqPGIKzTI+qIL+InBkVh9bIB5cR0Z0
        4E+1tfGjQlT6iP/t7N14uAstkueL8Ms=
From:   Sven Eckelmann <sven@narfation.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        davem@davemloft.net, kuba@kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] batman-adv: remove unsued inline function batadv_arp_change_timeout
Date:   Fri, 24 Apr 2020 15:23:25 +0200
Message-ID: <1719233.A8nWWOm8zQ@bentobox>
In-Reply-To: <20200424131437.48124-1-yuehaibing@huawei.com>
References: <20200424131437.48124-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1636235.vcL7jAjQFi"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1636235.vcL7jAjQFi
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, 24 April 2020 15:14:37 CEST YueHaibing wrote:
> There's no callers in-tree.

Added with typo fix in subject [1]

Thanks,
	Sven

[1] https://git.open-mesh.org/linux-merge.git/commit/e73f94d1b6f05f6f22434c63de255a9dec6fd23d
--nextPart1636235.vcL7jAjQFi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl6i6E0ACgkQXYcKB8Em
e0bG6A/9G8rOJU9MaYiBjI468YWQu6QexetKaiKqoSKUPPk4MLwVZ7tMdlFvLQRC
+HPvUF017vbd79PQffUd6qwWXkhr6NOA6Kh6P0jP4il8bmZP9jEJXRIPvRXwh01f
bG03gsykHx3sddTMQOufMSHCv96YA4gh30M5A+yMkY40cikgMvzKGsPCSlaNKNp0
oDNzt1y7+WYTFS62bfMaasvcKB6PwCtz96SAiiH2/CXhgfgedLtiAazGLTglQY3y
JwI37xYXH5qircD0dhgrA/r47qHx+4jA37V8Y4TZJ3nHM5BIYPd/LuW/nf7rhNpf
qUNzjDOAe8NFURBHaeTPtU1YwVL4p/IqIxmtJCaiXH0+rgT7Lgny8zpEIt0k9zOE
KR5yxh3iBIdIjBrvbetaw465QW9rEYZ6M8infTCcHJQ6ydlE1RV7atrYRloBCdoP
LYvN24RkLEOCSEDgjXEs3bqieNhM5cOEmBje0TwfwxcC6r6Q86okM9k9X9fhNxlY
oDMWjZAC6wm592cX1Bbu3VeAHTW+IE/4vxDLPQaL7VJMkIy+qJiuspHItQu/IF1B
vbVdsAjHZ71ryrHil3qTygrRDZz8v0jQcHxAXGgSqWHvONLzEm1fNj0bMc7zjC3B
3Uq3u4SUcBhh+9vgLTlltqN/cgsVNSUBsfo+0bBn6j3rgH2BfS0=
=LFgh
-----END PGP SIGNATURE-----

--nextPart1636235.vcL7jAjQFi--



