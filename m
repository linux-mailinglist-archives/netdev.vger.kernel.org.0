Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE422922B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 09:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389252AbfEXH5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 03:57:03 -0400
Received: from narfation.org ([79.140.41.39]:46862 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389193AbfEXH5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 03:57:03 -0400
Received: from bentobox.localnet (p200300C5970CBFF65DBBA6E41EE33035.dip0.t-ipconnect.de [IPv6:2003:c5:970c:bff6:5dbb:a6e4:1ee3:3035])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 772481100E1;
        Fri, 24 May 2019 09:56:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1558684620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sxepySEKhb40R5+oRea/rhZHSEGikD/C+/RJzO11JmE=;
        b=aLa7guY8qPQNejVipVe/OCYgca/oQYNsu7Y7dfWiBKGgxNow62HIexQrcasGQF//uhM4ba
        e21zA0tXVAJbaoicNQ16SEjOaWKoPw/qE1R2gbGMQrFcReWshy7nsxTD2GOayuhHt25vdB
        3IRNEW95z0cLj0Cr1yagBrtyzjNwEfk=
From:   Sven Eckelmann <sven@narfation.org>
To:     b.a.t.m.a.n@lists.open-mesh.org
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        netdev@vger.kernel.org,
        syzbot+d454a826e670502484b8@syzkaller.appspotmail.com,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] batadv: fix for leaked TVLV handler.
Date:   Fri, 24 May 2019 09:56:47 +0200
Message-ID: <3325808.M3JPgbICzP@bentobox>
In-Reply-To: <2234850.c0QxkmldC6@sven-edge>
References: <00000000000017d64c058965f966@google.com> <20190521195857.14639-1-jeremy@azazel.net> <2234850.c0QxkmldC6@sven-edge>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart779344695.vhicoALKBS"; micalg="pgp-sha512"; protocol="application/pgp-signature"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1558684620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sxepySEKhb40R5+oRea/rhZHSEGikD/C+/RJzO11JmE=;
        b=a0hXAkq4J5w0h88Oq6JovD/Af+uWToj5cV1bIxd+nDk5B1BzchFiz9LqypsOQJ2gul5xPz
        LdWHtHfEJV/yYwBE2+RvL4zfZ7hMYk9HLUdMbUqCaF5jpb+xLF0Dr/PXduGSKLc922ZMTf
        Ezn+13HTeQgHNbRScd/2wUDI79jmZ3g=
ARC-Seal: i=1; s=20121; d=narfation.org; t=1558684620; a=rsa-sha256;
        cv=none;
        b=kPz4jAqjEs9A4U+D6iGKRv8sGrUwFFKRursJ1KXsRvhaOysOyUUQsWWp3Fo7ceugC5MxdD
        TlIGZN4nDoYslBAc7Ni8xCUrxEJs863Wobn3gOHLXbVvFg/eA/CpI4BOl/R4/wl1eO9xtG
        a//plln1TjsoBqyLis57HAsm5Hrpbzk=
ARC-Authentication-Results: i=1;
        v3-1039.vlinux.de;
        auth=pass smtp.auth=sven smtp.mailfrom=sven@narfation.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart779344695.vhicoALKBS
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, 21 May 2019 22:48:32 CEST Sven Eckelmann wrote:
> Fixes: 122edaa05940 ("batman-adv: tvlv - convert roaming adv packet to use tvlv unicast packets")

This patch was queued up [1] for submission but it is the only queued patch at 
the moment. And I already saw that David marked this patch as "Under review" 
in patchwork [2]. May I ask whether this means that you (David) would directly 
apply it (unless there are objections)? If so then we could save ourselves an 
extra PR for just this patch. Just depends on what you (David) prefers.

Reviewed-by: Sven Eckelmann <sven@narfation.org>

The only adjustments I personally would like to see when it is applied:

* the Fixes: line
* prefix "batman-adv:" (at least this still seems the one which is usually 
  used for net/batman-adv/ related code)
  But this isn't really a hard  requirement and I also use the shorter 
  "batadv" all the time in other contexts

Kind regards,
	Sven

[1] https://git.open-mesh.org/linux-merge.git/commit/17f78dd1bd624a4dd78ed5db3284a63ee807fcc3
[2] https://patchwork.ozlabs.org/patch/1102982/
--nextPart779344695.vhicoALKBS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlzno78ACgkQXYcKB8Em
e0aPtw/+O0SulpXspnbKNveVpmmTL9ZVMCnwLGvkY6gxRKk/2Qm8dPsGVlhl9z2A
8CUhfYIoUtDO7fk+9RmezldlK+hvO0FJPDjKKIG2f0XteRBPncnxtnaTRliB87PX
yScD4ivUNQxbO+aYh3rbtWw9aPvjMAcgjS2Vmlf+i8IiXOp9EQVxQ8ffJuDMpBeH
Pc4TThVWBFymceZqjGUSJtiQvm9XXphfEH41sTqWra+HLv/YegHahRrJiBVLzV31
Rtje4Z1ggdQe0OuNeD5S4UrqDOTmCvnOgs4w7j5ts0o0YU3xeYIITClArT+OqkFx
NmZtgXHAO7nhaoc1Xdv+CttngZfvg2MGDp+AS/mhOtDNCdYkDlLFfl1McuOmxXHv
5HnD1/LZnpR+mVNs4kPfqRN3UDU/JF6OGN9XrJKTGxWzvoT4Q71K+OL8MSmrqzzZ
WMeGtgVbHwrV0O+R9P5VDeIqlCnCM0c1t9QVVruhLK1fVghkgyaKEe6+PetWobqW
CGtUGT2/gVVAS6c6bq4RCcVXmGqh66HsbIDvhYgUzRSNRQ7+v78FPuJFcZRNXpcX
RCQCWWmAZSjw30uW2pvRYe7aA/HMJVIY8D4wAnlfddMVhvdXvaVnkUVJYZUswsoF
kcZBHph3OyzKoLzUj9W/ySN1oeYFL/zPx+aeG3STXQs+/i+A2CQ=
=ec3e
-----END PGP SIGNATURE-----

--nextPart779344695.vhicoALKBS--



